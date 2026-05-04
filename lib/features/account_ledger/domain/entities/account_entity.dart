import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_entity.freezed.dart';
part 'account_entity.g.dart';

@freezed
abstract class AccountEntity with _$AccountEntity {
  const factory AccountEntity({
    required int id,
    required String accountTitle,
    required String accountType,
    String? bankName,
    String? accountNumber,
    @Default('PKR') String currency,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0.0) double currentBalance,
  }) = _AccountEntity;

  factory AccountEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountEntityFromJson(json);
}
