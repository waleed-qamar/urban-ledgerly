import 'package:freezed_annotation/freezed_annotation.dart';

part 'operator_entity.freezed.dart';
part 'operator_entity.g.dart';

@freezed
abstract class OperatorEntity with _$OperatorEntity {
  const factory OperatorEntity({
    required int id,
    required String name,
    required String phone,
    String? cnic,
    @JsonKey(name: 'joining_date') required DateTime joiningDate,
    @JsonKey(name: 'default_per_day') @Default(0.0) double defaultPerDay,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _OperatorEntity;

  factory OperatorEntity.fromJson(Map<String, dynamic> json) =>
      _$OperatorEntityFromJson(json);
}
