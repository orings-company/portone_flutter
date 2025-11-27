// 📦 Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'virtual_account.g.dart';

/// 가상계좌 정보
@JsonSerializable()
class VirtualAccount {
  /// [VirtualAccount] 생성자
  VirtualAccount({this.cashReceiptType, this.accountExpiry});

  /// JSON에서 [VirtualAccount] 객체로 변환하는 팩토리 메서드
  factory VirtualAccount.fromJson(Map<String, dynamic> json) =>
      _$VirtualAccountFromJson(json);

  final String? cashReceiptType;
  final AccountExpiry? accountExpiry;

  /// [VirtualAccount] 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$VirtualAccountToJson(this);
}

/// 가상계좌 정보
@JsonSerializable()
class AccountExpiry {
  /// [AccountExpiry] 생성자
  AccountExpiry({this.validHours});

  /// JSON에서 [AccountExpiry] 객체로 변환하는 팩토리 메서드
  factory AccountExpiry.fromJson(Map<String, dynamic> json) =>
      _$AccountExpiryFromJson(json);

  final int? validHours;

  /// [AccountExpiry] 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$AccountExpiryToJson(this);
}
