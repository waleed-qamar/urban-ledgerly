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
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'work_group_id') int? workGroupId,
    @JsonKey(name: 'default_wage_role_id') int? defaultWageRoleId,
    @JsonKey(name: 'overtime_enabled') @Default(true) bool overtimeEnabled,
  }) = _OperatorEntity;

  factory OperatorEntity.fromJson(Map<String, dynamic> json) =>
      _$OperatorEntityFromJson(json);
}
