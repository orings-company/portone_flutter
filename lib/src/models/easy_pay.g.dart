// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'easy_pay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EasyPay _$EasyPayFromJson(Map<String, dynamic> json) => $checkedCreate(
  'EasyPay',
  json,
  ($checkedConvert) {
    final val = EasyPay(
      easyPayProvider: $checkedConvert('easyPayProvider', (v) => v as String?),
    );
    return val;
  },
);

Map<String, dynamic> _$EasyPayToJson(EasyPay instance) => <String, dynamic>{
  'easyPayProvider': ?instance.easyPayProvider,
};
