// 📦 Package imports:
import 'package:json_annotation/json_annotation.dart';

// 🌎 Project imports:

part 'installmentmonthoption.g.dart';

/// 할부 개월 수 설정 객체
@JsonSerializable()
class InstallmentMonthOption {
  /// [InstallmentMonthOption] 생성자
  InstallmentMonthOption({
    this.fixedMonth,
    this.availableMonthList,
  });

  /// JSON에서 [InstallmentMonthOption] 객체로 변환하는 팩토리 메서드
  factory InstallmentMonthOption.fromJson(Map<String, dynamic> json) =>
      _$InstallmentMonthOptionFromJson(json);

  /// 구매자가 선택할 수 없도록 고정된 할부 개월수
  /// 구매자가 할부 개월 수를 선택할 수 있도록 하려면 [availableMonthList]를 사용해주세요.
  ///
  final int? fixedMonth;

  /// 구매자가 선택할 수 있는 할부 개월수 리스트
  /// 구매자가 할부 개월 수를 선택할 수 없도록 하려면 [fixedMont]를 사용해주세요.
  ///
  final List<int>? availableMonthList;

  /// [InstallmentMonthOption] 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$InstallmentMonthOptionToJson(this);
}
