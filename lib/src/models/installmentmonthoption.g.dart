// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installmentmonthoption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentMonthOption _$InstallmentMonthOptionFromJson(
  Map<String, dynamic> json,
) => InstallmentMonthOption(
  fixedMonth: (json['fixedMonth'] as num?)?.toInt(),
  availableMonthList: (json['availableMonthList'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$InstallmentMonthOptionToJson(
  InstallmentMonthOption instance,
) => <String, dynamic>{
  'fixedMonth': ?instance.fixedMonth,
  'availableMonthList': ?instance.availableMonthList,
};
