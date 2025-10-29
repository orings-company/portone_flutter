// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'virtual_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VirtualAccount _$VirtualAccountFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VirtualAccount', json, ($checkedConvert) {
  final val = VirtualAccount(
    cashReceiptType: $checkedConvert('cashReceiptType', (v) => v as String?),
    accountExpiry: $checkedConvert(
      'accountExpiry',
      (v) =>
          v == null ? null : AccountExpiry.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$VirtualAccountToJson(VirtualAccount instance) =>
    <String, dynamic>{
      'cashReceiptType': ?instance.cashReceiptType,
      'accountExpiry': ?instance.accountExpiry?.toJson(),
    };

AccountExpiry _$AccountExpiryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AccountExpiry', json, ($checkedConvert) {
      final val = AccountExpiry(
        validHours: $checkedConvert('validHours', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$AccountExpiryToJson(AccountExpiry instance) =>
    <String, dynamic>{'validHours': ?instance.validHours};
