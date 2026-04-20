import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_entity.freezed.dart';
part 'client_entity.g.dart';

@freezed
abstract class ClientEntity with _$ClientEntity {
  factory ClientEntity({
    required int id,
    required String clientName,
    required String contactNumber,
    required String clientAddress,
    required DateTime createdAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active', defaultValue: true) required bool isActive,
  }) = _ClientEntity;

  factory ClientEntity.fromJson(Map<String, dynamic> json) =>
      _$ClientEntityFromJson(json);
}
