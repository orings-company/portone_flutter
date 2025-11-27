// 📦 Package imports:
import 'package:json_annotation/json_annotation.dart';

// 🌎 Project imports:
import 'package:portone_flutter_v2/portone_flutter_v2.dart';
import 'package:portone_flutter_v2/src/enums/card_company.dart';

part 'card.g.dart';

/// 카드 결제 설정 객체
@JsonSerializable()
class PaymentRequestUnionCard {
  /// [PaymentRequestUnionCard] 생성자
  PaymentRequestUnionCard({
    this.cardCompany,
    this.availableCards,
    this.useFreeInterestFromMall,
    this.installment,
    this.useCardPoint,
    this.useAppCardOnly,
    this.useInstallment,
  });

  /// JSON에서 [PaymentRequestUnionCard] 객체로 변환하는 팩토리 메서드
  factory PaymentRequestUnionCard.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestUnionCardFromJson(json);

  /// 카드사 다이렉트 호출 시 필요한 카드사 식별 값
  ///
  final CardCompany? cardCompany;

  /// 사용 가능한 카드 목록
  ///
  final List<CardCompany>? availableCards;

  /// 상점 분담 무이자 할부 사용 여부
  ///
  final bool? useFreeInterestFromMall;

  /// 할부 설정
  ///
  final Installment? installment;

  /// 카드 포인트 사용 설정
  ///
  final bool? useCardPoint;

  /// 앱 카드만 허용할지 여부
  ///
  final bool? useAppCardOnly;

  /// 할부 사용 가능 여부
  ///
  final bool? useInstallment;

  /// [PaymentRequestUnionCard] 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$PaymentRequestUnionCardToJson(this);
}
