// 📦 Package imports:
import 'package:json_annotation/json_annotation.dart';

// 🌎 Project imports:
import 'package:portone_flutter_v2/src/enums/card_company.dart';

part 'freeinstallmentplan.g.dart';

/// 무이자 할부 설정 객체
@JsonSerializable()
class FreeInstallmentPlans {
  /// [FreeInstallmentPlans] 생성자
  FreeInstallmentPlans({
    this.cardCompany,
    this.months,
  });

  /// JSON에서 [FreeInstallmentPlans] 객체로 변환하는 팩토리 메서드
  factory FreeInstallmentPlans.fromJson(Map<String, dynamic> json) =>
      _$FreeInstallmentPlansFromJson(json);

  /// 무이자 할부를 제공하는 카드사
  ///
  final CardCompany? cardCompany;

  /// 무이자 할부를 제공하는 개월 수
  ///
  final List<int>? months;

  /// [FreeInstallmentPlans] 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$FreeInstallmentPlansToJson(this);
}
