import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/audit_log_entity.dart';
import '../../domain/entities/audit_log_filter.dart';
import '../../domain/repositories/audit_log_repository.dart';
import '../datasource/audit_log_remote_datasource.dart';

class AuditLogRepositoryImpl implements AuditLogRepository {
  final AuditLogRemoteDataSource remoteDataSource;

  AuditLogRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AuditLogEntity>>> getAuditLogs({
    required AuditLogFilter filter,
    required int page,
    required int pageSize,
  }) => _guard(
    () => remoteDataSource.getAuditLogs(
      filter: filter,
      page: page,
      pageSize: pageSize,
    ),
  );

  @override
  Future<Either<Failure, List<String>>> getDistinctTables() =>
      _guard(() => remoteDataSource.getDistinctTables());

  @override
  Future<Either<Failure, List<AuditLogActor>>> getDistinctActors() =>
      _guard(() => remoteDataSource.getDistinctActors());

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
