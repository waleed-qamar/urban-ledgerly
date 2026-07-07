import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_entity.freezed.dart';
part 'vendor_entity.g.dart';

@freezed
abstract class VendorEntity with _$VendorEntity {
  factory VendorEntity({
    required int id,
    @JsonKey(name: 'vendor_name') required String vendorName,
    @JsonKey(name: 'vendor_address') required String vendorAddress,
    @JsonKey(name: 'vendor_notes') required String vendorNotes,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'contact_number') required String contactNumber,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active', defaultValue: true) required bool isActive,
  }) = _VendorEntity;

  factory VendorEntity.fromJson(Map<String, dynamic> json) =>
      _$VendorEntityFromJson(json);
}
