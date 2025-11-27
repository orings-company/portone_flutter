// 📦 Package imports:
import 'package:json_annotation/json_annotation.dart';

// 🌎 Project imports:
import 'package:portone_flutter_v2/src/enums/card_company.dart';
import 'package:portone_flutter_v2/src/models/freeinstallmentplan.dart';
import 'package:portone_flutter_v2/src/models/installmentmonthoption.dart';

part 'installment.g.dart';

/// 카드 결제 설정 객체
@JsonSerializable()
class Installment {
  /// [Installment] 생성자
  Installment({
    this.freeInstallmentPlans,
    this.monthOption,
  });

  /// JSON에서 [Installment] 객체로 변환하는 팩토리 메서드
  factory Installment.fromJson(Map<String, dynamic> json) =>
      _$InstallmentFromJson(json);

  /// 할부 설정
  ///
  final FreeInstallmentPlans? freeInstallmentPlans;

  final InstallmentMonthOption? monthOption;

  /// [Installment] 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$InstallmentToJson(this);
}
