// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequestUnionCard _$PaymentRequestUnionCardFromJson(
  Map<String, dynamic> json,
) => PaymentRequestUnionCard(
  cardCompany: $enumDecodeNullable(_$CardCompanyEnumMap, json['cardCompany']),
  availableCards: (json['availableCards'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$CardCompanyEnumMap, e))
      .toList(),
  useFreeInterestFromMall: json['useFreeInterestFromMall'] as bool?,
  installment: json['installment'] == null
      ? null
      : Installment.fromJson(json['installment'] as Map<String, dynamic>),
  useCardPoint: json['useCardPoint'] as bool?,
  useAppCardOnly: json['useAppCardOnly'] as bool?,
  useInstallment: json['useInstallment'] as bool?,
);

Map<String, dynamic> _$PaymentRequestUnionCardToJson(
  PaymentRequestUnionCard instance,
) => <String, dynamic>{
  'cardCompany': ?_$CardCompanyEnumMap[instance.cardCompany],
  'availableCards': ?instance.availableCards
      ?.map((e) => _$CardCompanyEnumMap[e]!)
      .toList(),
  'useFreeInterestFromMall': ?instance.useFreeInterestFromMall,
  'installment': ?instance.installment?.toJson(),
  'useCardPoint': ?instance.useCardPoint,
  'useAppCardOnly': ?instance.useAppCardOnly,
  'useInstallment': ?instance.useInstallment,
};

const _$CardCompanyEnumMap = {
  CardCompany.KOREA_DEVELOPMENT_BANK: 'KOREA_DEVELOPMENT_BANK',
  CardCompany.KFCC: 'KFCC',
  CardCompany.SHINHYUP: 'SHINHYUP',
  CardCompany.EPOST: 'EPOST',
  CardCompany.SAVINGS_BANK_KOREA: 'SAVINGS_BANK_KOREA',
  CardCompany.KAKAO_BANK: 'KAKAO_BANK',
  CardCompany.WOORI_CARD: 'WOORI_CARD',
  CardCompany.BC_CARD: 'BC_CARD',
  CardCompany.GWANGJU_CARD: 'GWANGJU_CARD',
  CardCompany.SAMSUNG_CARD: 'SAMSUNG_CARD',
  CardCompany.SHINHAN_CARD: 'SHINHAN_CARD',
  CardCompany.HYUNDAI_CARD: 'HYUNDAI_CARD',
  CardCompany.LOTTE_CARD: 'LOTTE_CARD',
  CardCompany.SUHYUP_CARD: 'SUHYUP_CARD',
  CardCompany.CITI_CARD: 'CITI_CARD',
  CardCompany.NH_CARD: 'NH_CARD',
  CardCompany.JEONBUK_CARD: 'JEONBUK_CARD',
  CardCompany.JEJU_CARD: 'JEJU_CARD',
  CardCompany.HANA_CARD: 'HANA_CARD',
  CardCompany.KOOKMIN_CARD: 'KOOKMIN_CARD',
  CardCompany.K_BANK: 'K_BANK',
  CardCompany.TOSS_BANK: 'TOSS_BANK',
  CardCompany.MIRAE_ASSET_SECURITIES: 'MIRAE_ASSET_SECURITIES',
  CardCompany.KAKAO_PAY: 'KAKAO_PAY',
};
