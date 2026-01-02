/*
  A simple Either type for functional error handling
  Left represents failure/error, Right represents success/value
*/
sealed class Either<L, R> {
  const Either();

  /// Create a Left (error/failure) value
  const factory Either.left(L value) = Left<L, R>;

  /// Create a Right (success) value
  const factory Either.right(R value) = Right<L, R>;

  /// Fold the Either into a single value
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);

  /// Check if this is a Left value
  bool isLeft() => this is Left<L, R>;

  /// Check if this is a Right value
  bool isRight() => this is Right<L, R>;

  /// Get the Left value, throws if this is a Right
  L get left =>
      fold((l) => l, (r) => throw StateError('Either is Right, not Left'));

  /// Get the Right value, throws if this is a Left
  R get right =>
      fold((l) => throw StateError('Either is Left, not Right'), (r) => r);
}

/// Left side of Either - represents error/failure
class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onLeft(value);
  }

  @override
  String toString() => 'Left($value)';
}

/// Right side of Either - represents success/value
class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onRight(value);
  }

  @override
  String toString() => 'Right($value)';
}
