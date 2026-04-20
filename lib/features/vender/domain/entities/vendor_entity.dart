import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_entity.freezed.dart';
part 'vendor_entity.g.dart';

@freezed
abstract class VendorEntity with _$VendorEntity {
  factory VendorEntity({
    required int id,
    required String vendorName,
    required String vendorAddress,
    required String vendorNotes,
    required String companyName,
    required String contactNumber,
    required DateTime createdAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active', defaultValue: true) required bool isActive,
  }) = _VendorEntity;

  factory VendorEntity.fromJson(Map<String, dynamic> json) =>
      _$VendorEntityFromJson(json);
}
