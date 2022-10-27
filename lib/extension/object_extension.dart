extension ObjectExtension on Object {
  /// 类型强转
  T asType<T>() => this as T;

  /// 检查类型并强转或返回空
  T? asSafeType<T>() => this is T ? this as T? : null;
}