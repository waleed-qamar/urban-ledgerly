import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_head.freezed.dart';
part 'expense_head.g.dart';

@freezed
abstract class ExpenseHead with _$ExpenseHead {
  const factory ExpenseHead({
    required int id,
    required String name,
    String? description,
    @JsonKey(name: 'head_type') required HeadType headType,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ExpenseHead;

  factory ExpenseHead.fromJson(Map<String, dynamic> json) =>
      _$ExpenseHeadFromJson(json);
}

enum HeadType {
  developmental,
  nondevelopmental,
  domestic;

  String get value {
    switch (this) {
      case HeadType.developmental:
        return 'developmental';
      case HeadType.nondevelopmental:
        return 'nondevelopmental';
      case HeadType.domestic:
        return 'domestic';
    }
  }
}
