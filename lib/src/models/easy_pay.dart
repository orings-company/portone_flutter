// 📦 Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'easy_pay.g.dart';

@JsonSerializable()
class EasyPay {
  /// [EasyPay] 생성자
  EasyPay({this.easyPayProvider});

  /// JSON에서 [EasyPay] 객체로 변환하는 팩토리 메서드
  factory EasyPay.fromJson(Map<String, dynamic> json) =>
      _$EasyPayFromJson(json);

  final String? easyPayProvider;

  /// [EasyPay] 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$EasyPayToJson(this);
}
