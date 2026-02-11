// ignore_for_file: avoid_catches_without_on_clauses just ignore;

// 🎯 Dart imports:
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import 'package:portone_flutter_v2/src/helpers/error_handler.dart';
import 'package:portone_flutter_v2/src/helpers/platform_utils.dart';
import 'package:portone_flutter_v2/src/helpers/url_normalizer.dart';
import 'package:portone_flutter_v2/src/models/payment_request.dart';
import 'package:portone_flutter_v2/src/models/payment_response.dart';
import 'package:portone_flutter_v2/src/validators/webview_error_use_case.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Default logger function interface.
typedef DefaultLogger =
    void Function(String message, {Object? error, StackTrace? stackTrace});

/// Default logger function using [log].
void _defaultLog(String message, {Object? error, StackTrace? stackTrace}) {
  log(message, error: error, stackTrace: stackTrace, name: 'portone');
}

/// A widget that implements the PortOne v2 payment process using an [InAppWebView].
///
/// This widget uses an [IndexedStack] to initially display a placeholder widget ([initialChild])
/// instead of a blank white screen. Once the webpage is fully loaded (as indicated by the
/// [InAppWebView]'s `onLoadStop` callback), the [IndexedStack] displays the actual web view.
///
/// The widget requires a [PaymentRequest] ([data]) to initialize the payment process using
/// PortOne's browser SDK. Optionally, [onError] can be provided for error handling, and [callback]
/// will be invoked with query parameters when a payment result is received.
///
/// The [gestureRecognizers] parameter allows customization of which gestures are forwarded
/// to the web view, which is especially useful when the widget is nested in scrollable containers.
///
/// See also:
///  - [InAppWebView] from flutter_inappwebview
class PortonePayment extends StatefulWidget {
  /// Creates a [PortonePayment] widget.
  ///
  /// The [data] parameter must provide the necessary payment information.
  /// The [initialChild] is an optional widget displayed while the web view is loading.
  PortonePayment({
    required this.data,
    required this.callback,
    required Function onError,
    super.key,
    this.appBar,
    this.logger = _defaultLog,
    this.initialChild,
    this.gestureRecognizers,
  }) : onError = PortoneErrorHandler(onError);

  /// Optional app bar to be displayed at the top of the widget.
  final PreferredSizeWidget? appBar;

  /// Payment information used to initiate the payment process.
  final PaymentRequest data;

  /// Error callback that is invoked when a JavaScript error occurs.
  final PortoneErrorHandler onError;

  /// Callback invoked with the payment result parameters.
  final void Function(PaymentResponse result) callback;

  /// Logger function for debugging purposes.
  final DefaultLogger logger;

  /// An optional widget displayed while the web content is loading.
  final Widget? initialChild;

  /// Set of gesture recognizers that determine which gestures are forwarded to the web view.
  ///
  /// This is useful when embedding the web view in other gesture-sensitive widgets such as
  /// [ListView], [PageView], or custom gesture detectors.
  ///
  /// For example, if vertical drag gestures inside a [ListView] should be recognized by the web
  /// view, you can add a [VerticalDragGestureRecognizer] to this set.
  ///
  /// By default (if null or empty), the web view will only receive pointer events for gestures
  /// that are not claimed by any other widgets.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  @override
  State<PortonePayment> createState() => _PortonePaymentState();
}

/// State class for the [PortonePayment] widget that manages the payment process flow.
///
/// This public state class encapsulates the core logic required to initiate and handle the
/// PortOne v2 payment process using an embedded [InAppWebView]. It is designed to facilitate
/// testing by exposing internal behaviors while remaining responsible for:
///
/// - Generating and loading HTML that invokes PortOne’s browser SDK for processing the payment.
/// - Managing the [InAppWebView] lifecycle including loading events, JavaScript handlers,
///   and navigation actions.
/// - Intercepting and processing URL navigations to capture payment responses or errors:
///   - Allowing normal HTTP/HTTPS navigations.
///   - Capturing the custom app scheme redirections to extract payment result parameters.
///   - Parsing and launching intent URLs according to the provided scheme information.
/// - Propagating errors encountered during the payment flow via the provided [PortonePayment.onError] callback.
///
/// **Note:** This class is declared public primarily to support more granular testing of internal
/// logic and web view interactions without compromising encapsulation in production builds.
///
/// See also:
///  - [PortonePayment]
///  - [InAppWebView] from the flutter_inappwebview package.
class _PortonePaymentState extends State<PortonePayment> {
  /// Callback function name for JavaScript error handling.
  final handlerName = 'portoneError';

  /// MIME type for the HTML content loaded into the web view.
  final contentType = 'text/html';

  /// Controller for managing the embedded [InAppWebView].
  InAppWebViewController? controller;

  /// Current index of Stacked Widgets
  int _stackIndex = 0;

  /// Every time `shouldOverrideUrlLoading` is called, the URL is stored in [_redirectedUrls],
  /// and when an actual error occurs, you can create a stack trace containing this URL history using
  /// [StackTrace.fromString] and pass it on, allowing users to use it for debugging as is.
  final List<Uri> _redirectedUrls = [];

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  /// Known app-market hosts that should be opened outside the WebView.
  bool _isAppMarketHost(Uri uri) {
    if (!PlatformUtil.isAndroid) {
      return false;
    }
    final scheme = uri.scheme.toLowerCase();
    if (scheme == 'market') {
      return true;
    } else if (scheme == 'http' || scheme == 'https') {
      final host = uri.host.toLowerCase();
      return host == 'play.google.com' ||
          host == 'market.android.com' ||
          host == 'play.app.goo.gl';
    } else {
      return false;
    }
  }

  /// Opens the Play Store using the provided URI. (Android only)
  Future<void> _openPlayStore(Uri uri) async {
    if (!PlatformUtil.isAndroid) {
      return;
    }
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (error, stack) {
      widget.logger(
        'Failed to launch Play Store externally: $uri',
        error: error,
        stackTrace: stack,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentData = Map<String, dynamic>.from(widget.data.toJson());
    final NormalizedUrl(:appScheme, :redirectUrl) = NormalizedUrl(
      appScheme: widget.data.appScheme,
      redirectUrl: widget.data.redirectUrl,
    );
    paymentData['redirectUrl'] = redirectUrl;
    widget.logger(jsonEncode(paymentData));

    final html =
        '''
<!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
    <script>
      window.addEventListener("flutterInAppWebViewPlatformReady", () => {
        PortOne.requestPayment(${jsonEncode(paymentData)}).catch((err) =>
          window.flutter_inappwebview.callHandler("$handlerName", err.message),
        );
      });
    </script>
  </head>
  <body></body>
</html>

''';

    const loadingIndicator = Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: widget.appBar,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (await controller?.canGoBack() ?? false) {
            await controller!.goBack();
          } else {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
          }
        },
        child: SafeArea(
          child: IndexedStack(
            index: _stackIndex,
            children: [
              widget.initialChild ?? loadingIndicator,
              InAppWebView(
                gestureRecognizers: widget.gestureRecognizers,
                initialSettings: InAppWebViewSettings(
                  javaScriptCanOpenWindowsAutomatically: true,
                  allowsLinkPreview: false,
                  allowsInlineMediaPlayback: true,
                  useShouldOverrideUrlLoading: true,
                  useOnLoadResource: true,
                  useOnDownloadStart: true,
                  resourceCustomSchemes: ['intent', appScheme],
                  contentBlockers: [],
                ),
                onWebViewCreated: (InAppWebViewController created) async {
                  controller = created;
                  controller!.addJavaScriptHandler(
                    handlerName: handlerName,
                    callback: (List<dynamic> arguments) async {
                      try {
                        widget.logger('PortOne SDK ERROR: $arguments');
                        final portoneError = arguments.first;
                        widget.logger(
                          'PortOne SDK Error type: ${portoneError.runtimeType}',
                        );
                        _handleError(portoneError as Object?);
                      } on PlatformException catch (error, stackTrace) {
                        widget.logger(
                          'Platform Exception Occurred',
                          error: error,
                          stackTrace: stackTrace,
                        );
                        _handleError(error, stackTrace);
                      } on Exception catch (error, stackTrace) {
                        widget.logger(
                          'Exception Occurred',
                          error: error,
                          stackTrace: stackTrace,
                        );
                        _handleError(error, stackTrace);
                      }
                    },
                  );
                  await controller!.loadData(
                    mimeType: contentType,
                    data: html,
                    baseUrl: WebUri('https://flutter-sdk-content.portone.io/'),
                  );
                },
                onLoadResourceWithCustomScheme: (controller, resource) async {
                  await controller.stopLoading();
                  return null;
                },
                onLoadStop: (controller, url) async {
                  if (mounted) {
                    setState(() {
                      _stackIndex = 1;
                    });
                  }
                },
                onReceivedError: (controller, request, error) {
                  if (WebviewErrorUseCase.shouldIgnore(
                    error,
                    isMainFrame: request.isForMainFrame,
                  )) {
                    widget.logger(
                      'Ignored WebView error: ${error.type} ${error.description}',
                    );
                    return;
                  }

                  widget.logger(
                    'onReceivedError (main frame)',
                    error: error,
                  );
                  _handleError(error);
                },
                onReceivedHttpError: (controller, request, errorResponse) {
                  final statusCode = errorResponse.statusCode;
                  if (statusCode == null) {
                    widget.logger(
                      'Ignored HTTP error unknown status code: ${request.url}',
                    );
                    return;
                  }
                  // 요청이 메인 프레임의 문서를 가져오기 위해 이루어진 것이 아니면 무시
                  if (!(request.isForMainFrame ?? false)) {
                    widget.logger(
                      'Ignored HTTP error on subresource: ${request.url} → $statusCode',
                    );
                    return;
                  }

                  if (statusCode >= 400) {
                    widget.logger(
                      'onReceivedHttpError (main frame $statusCode): ${request.url}',
                    );
                    final exception = Exception(
                      'HTTP $statusCode: ${errorResponse.reasonPhrase}',
                    );
                    _handleError(exception);
                  }
                },
                shouldOverrideUrlLoading: (controller, navigateAction) async {
                  final url = navigateAction.request.url;
                  if (url == null) return NavigationActionPolicy.CANCEL;

                  final raw = url.rawValue;
                  if (raw == null || raw.isEmpty) {
                    return NavigationActionPolicy.CANCEL;
                  }

                  final lowerRaw = raw.toLowerCase();
                  widget.logger('Navigation action request raw: $raw');

                  _redirectedUrls.add(Uri.parse(raw));

                  /// ✅ 1. http/https → WebView 내부 유지
                  if (lowerRaw.startsWith('http://') ||
                      lowerRaw.startsWith('https://')) {
                    return NavigationActionPolicy.ALLOW;
                  }

                  /// ✅ 2. 결제 완료 콜백
                  if (lowerRaw.startsWith('${appScheme.toLowerCase()}://')) {
                    try {
                      final uri = Uri.parse(raw);
                      final params = Map<String, dynamic>.from(
                        uri.queryParameters,
                      );
                      final paymentResponse = PaymentResponse.fromJson(params);
                      _handleSuccess(paymentResponse);
                    } catch (e, s) {
                      _handleError(e, s);
                    }
                    return NavigationActionPolicy.CANCEL;
                  }

                  /// ==========================================================
                  /// 🔥 ANDROID intent 처리
                  /// ==========================================================
                  if (Platform.isAndroid && lowerRaw.startsWith('intent:')) {
                    try {
                      final hashIndex = raw.indexOf('#');
                      final urlOrigin = hashIndex >= 0
                          ? raw.substring(0, hashIndex)
                          : raw;
                      var fragment = hashIndex >= 0
                          ? raw.substring(hashIndex + 1)
                          : '';

                      const intentPrefix = 'Intent;';
                      if (fragment.startsWith(intentPrefix)) {
                        fragment = fragment.substring(intentPrefix.length);
                      }

                      final params = <String, String>{};
                      final regexp = RegExp(r'([A-Za-z0-9_.-]+)=(.*?)(?:;|$)');
                      for (final match in regexp.allMatches(fragment)) {
                        final key = match.group(1)!;
                        final val = Uri.decodeComponent(match.group(2)!);
                        params[key] = val;
                      }

                      final scheme = params['scheme'];
                      final fallback = params['S.browser_fallback_url'];
                      final package = params['package'];

                      /// 1️⃣ scheme 직접 실행
                      if (scheme != null) {
                        String replaced;

                        if (lowerRaw.startsWith('intent://')) {
                          replaced = raw.replaceFirst(
                            RegExp(r'^intent://', caseSensitive: false),
                            '$scheme://',
                          );
                        } else {
                          replaced = raw.replaceFirst(
                            RegExp(r'^intent:', caseSensitive: false),
                            '$scheme:',
                          );
                        }

                        await launchUrlString(
                          replaced,
                          mode: LaunchMode.externalApplication,
                        );
                        return NavigationActionPolicy.CANCEL;
                      }

                      /// 2️⃣ fallback
                      if (fallback != null && fallback.isNotEmpty) {
                        await launchUrlString(
                          fallback,
                          mode: LaunchMode.externalApplication,
                        );
                        return NavigationActionPolicy.CANCEL;
                      }

                      /// 3️⃣ package → Play Store
                      if (package != null && package.isNotEmpty) {
                        final marketUrl = 'market://details?id=$package';
                        final playStoreUrl =
                            'https://play.google.com/store/apps/details?id=$package';

                        try {
                          await launchUrlString(
                            marketUrl,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (_) {
                          await launchUrlString(
                            playStoreUrl,
                            mode: LaunchMode.externalApplication,
                          );
                        }

                        return NavigationActionPolicy.CANCEL;
                      }
                    } catch (e, s) {
                      _handleError(e, s);
                    }

                    return NavigationActionPolicy.CANCEL;
                  }

                  /// ==========================================================
                  /// 🔥 iOS custom scheme 처리
                  /// ==========================================================
                  if (Platform.isIOS) {
                    try {
                      final launched = await launchUrlString(
                        raw,
                        mode: LaunchMode.externalApplication,
                      );

                      if (!launched) {
                        widget.logger('iOS scheme launch failed: $raw');
                      }
                    } catch (e, s) {
                      _handleError(e, s);
                    }

                    return NavigationActionPolicy.CANCEL;
                  }

                  /// ==========================================================
                  /// 기타 모든 scheme
                  /// ==========================================================
                  try {
                    await launchUrlString(
                      raw,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e, s) {
                    widget.logger(
                      'External launch failed: $raw',
                      error: e,
                      stackTrace: s,
                    );
                  }

                  return NavigationActionPolicy.CANCEL;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle errors from the WebView.
  void _handleError(Object? error, [StackTrace? stackTrace]) {
    widget.onError(
      error,
      stackTrace ?? StackTrace.fromString(_redirectedUrls.join('\n\tthen ')),
    );
    _redirectedUrls.clear();
  }

  /// Handle successful payment response.
  void _handleSuccess(PaymentResponse paymentResponse) {
    widget.callback(paymentResponse);
    _redirectedUrls.clear();
  }
}
