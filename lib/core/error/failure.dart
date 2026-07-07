/// Bare-bones Failure hierarchy. If Ledgerly already has `core/error/failure.dart`
/// (very likely, given the rest of the app follows clean architecture), delete
/// this file and point the imports in this feature at the existing one instead.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}
