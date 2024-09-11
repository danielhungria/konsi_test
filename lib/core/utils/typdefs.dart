import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef Result<T> = Either<Failure, T>;

typedef DataMap = Map<String, dynamic>;
