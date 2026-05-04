import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class AccountEntity with _$AccountEntity {
  const factory AccountEntity({
    required String id,
    required String accountTitle,
    required String accountType,
    required String bankName,
    required String accountNumber,
    String? currncy,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    required double balance,
  }) = _AccountEntity;

  factory AccountEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountEntityFromJson(json);
}
