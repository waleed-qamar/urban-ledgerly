import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_entity.freezed.dart';
part 'employee_entity.g.dart';

@freezed
abstract class EmployeeEntity with _$EmployeeEntity {
  const factory EmployeeEntity({
    required int id,
    required String name,
    required String phone,
    String? cnic,
    String? email,
    @JsonKey(name: 'joining_date') required DateTime joiningDate,
    @JsonKey(name: 'is_active') required bool isActive,
    String? role,
    @JsonKey(name: 'role_id') int? roleId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _EmployeeEntity;

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) =>
      _$EmployeeEntityFromJson(json);
}

