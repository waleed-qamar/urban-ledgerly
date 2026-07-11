import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/wage_role.dart';

part 'wage_role_model.freezed.dart';
part 'wage_role_model.g.dart';

@freezed
abstract class WageRoleModel with _$WageRoleModel {
  const factory WageRoleModel({
    required int id,
    @JsonKey(name: 'work_group_id') required int workGroupId,
    @JsonKey(name: 'role_name') required String roleName,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _WageRoleModel;

  factory WageRoleModel.fromJson(Map<String, dynamic> json) =>
      _$WageRoleModelFromJson(json);

  const WageRoleModel._();

  WageRole toEntity() {
    return WageRole(
      id: id,
      workGroupId: workGroupId,
      roleName: roleName,
      isActive: isActive,
    );
  }
}
