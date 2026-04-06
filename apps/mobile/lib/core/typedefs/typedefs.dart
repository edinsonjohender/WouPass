import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/errors/failures.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = Future<Either<Failure, void>>;
