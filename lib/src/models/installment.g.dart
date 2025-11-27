// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Installment _$InstallmentFromJson(Map<String, dynamic> json) => Installment(
  freeInstallmentPlans: json['freeInstallmentPlans'] == null
      ? null
      : FreeInstallmentPlans.fromJson(
          json['freeInstallmentPlans'] as Map<String, dynamic>,
        ),
  monthOption: json['monthOption'] == null
      ? null
      : InstallmentMonthOption.fromJson(
          json['monthOption'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$InstallmentToJson(Installment instance) =>
    <String, dynamic>{
      'freeInstallmentPlans': ?instance.freeInstallmentPlans?.toJson(),
      'monthOption': ?instance.monthOption?.toJson(),
    };
