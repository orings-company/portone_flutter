// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'virtual_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VirtualAccount _$VirtualAccountFromJson(Map<String, dynamic> json) =>
    VirtualAccount(
      cashReceiptType: json['cashReceiptType'] as String?,
      accountExpiry: json['accountExpiry'] == null
          ? null
          : AccountExpiry.fromJson(
              json['accountExpiry'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$VirtualAccountToJson(VirtualAccount instance) =>
    <String, dynamic>{
      'cashReceiptType': ?instance.cashReceiptType,
      'accountExpiry': ?instance.accountExpiry?.toJson(),
    };

AccountExpiry _$AccountExpiryFromJson(Map<String, dynamic> json) =>
    AccountExpiry(validHours: (json['validHours'] as num?)?.toInt());

Map<String, dynamic> _$AccountExpiryToJson(AccountExpiry instance) =>
    <String, dynamic>{'validHours': ?instance.validHours};
