// 📦 Package imports:
import 'package:json_annotation/json_annotation.dart';

/// PG사 enum
@JsonEnum(fieldRename: FieldRename.screamingSnake, valueField: 'value')
enum CardCompany {
  /// KDB산업은행
  KOREA_DEVELOPMENT_BANK('KOREA_DEVELOPMENT_BANK'),

  // 새마을 금고 카드
  KFCC('KFCC'),

  // 신협카드
  SHINHYUP('SHINHYUP'),

  // 우체국 카드
  EPOST('EPOST'),

  // 저축은행 카드
  SAVINGS_BANK_KOREA('SAVINGS_BANK_KOREA'),

  // 카카오뱅크 카드
  KAKAO_BANK('KAKAO_BANK'),

  // 우리 카드
  WOORI_CARD('WOORI_CARD'),

  // BC 카드
  BC_CARD('BC_CARD'),

  // 광주 카드
  GWANGJU_CARD('GWANGJU_CARD'),

  // 삼성 카드
  SAMSUNG_CARD('SAMSUNG_CARD'),

  // 신한 카드
  SHINHAN_CARD('SHINHAN_CARD'),

  // 현대 카드
  HYUNDAI_CARD('HYUNDAI_CARD'),

  // 롯데 카드
  LOTTE_CARD('LOTTE_CARD'),

  // 수협 카드
  SUHYUP_CARD('SUHYUP_CARD'),

  // 씨티 카드
  CITI_CARD('CITI_CARD'),

  // NH농협 카드
  NH_CARD('NH_CARD'),

  // 전북 카드
  JEONBUK_CARD('JEONBUK_CARD'),

  // 제주 카드
  JEJU_CARD('JEJU_CARD'),

  // 하나 카드
  HANA_CARD('HANA_CARD'),

  // 국민 카드
  KOOKMIN_CARD('KOOKMIN_CARD'),

  // 케이뱅크
  K_BANK('K_BANK'),

  // 토스뱅크
  TOSS_BANK('TOSS_BANK'),

  // 미래에셋증권
  MIRAE_ASSET_SECURITIES('MIRAE_ASSET_SECURITIES'),

  //카카오페이 카드결제
  //
  KAKAO_PAY('KAKAO_PAY');

  const CardCompany(this.value);

  /// 직렬화에 사용될 값
  final String value;

  @override
  String toString() => value;
}
