import 'package:freezed_annotation/freezed_annotation.dart';

part 'wage_role.freezed.dart';

@freezed
abstract class WageRole with _$WageRole {
  const factory WageRole({
    required int id,
    required int workGroupId,
    required String roleName,
    required bool isActive,
  }) = _WageRole;
}
