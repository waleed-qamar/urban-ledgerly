import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_entity.freezed.dart';
part 'client_entity.g.dart';

@freezed
abstract class ClientEntity with _$ClientEntity {
  factory ClientEntity({
    required int id,
    @JsonKey(name: 'client_name') required String clientName,
    @JsonKey(name: 'contact_number') required String contactNumber,
    @JsonKey(name: 'client_address') required String clientAddress,
    required String department,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active', defaultValue: true) required bool isActive,
  }) = _ClientEntity;

  factory ClientEntity.fromJson(Map<String, dynamic> json) =>
      _$ClientEntityFromJson(json);
}
