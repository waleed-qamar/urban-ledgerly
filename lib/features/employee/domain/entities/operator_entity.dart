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
    required DateTime joiningDate,
    required bool isActive,
    DateTime? createdAt,
  }) = _OperatorEntity;

  factory OperatorEntity.fromJson(Map<String, dynamic> json) =>
      _$OperatorEntityFromJson(json);
}
