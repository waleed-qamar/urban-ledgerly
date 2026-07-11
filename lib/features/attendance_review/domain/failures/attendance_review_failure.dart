import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_review_failure.freezed.dart';

@freezed
class AttendanceReviewFailure with _$AttendanceReviewFailure {
  const factory AttendanceReviewFailure.server(String message) = _Server;
  const factory AttendanceReviewFailure.network(String message) = _Network;
  const factory AttendanceReviewFailure.missingReason() = _MissingReason;
  const factory AttendanceReviewFailure.unknown(String message) = _Unknown;
}
