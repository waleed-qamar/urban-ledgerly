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
    required DateTime joiningDate,
    required bool isActive,
    String? role,
    String? userId,
    DateTime? createdAt,
  }) = _EmployeeEntity;

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) =>
      _$EmployeeEntityFromJson(json);
}
