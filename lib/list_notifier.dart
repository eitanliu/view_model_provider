import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// 可监听 [List] 实现
class ListNotifier<E> extends AbstractListNotifier<E> {
  List<E> _value;

  ListNotifier([List<E>? list])
      : _value = list ?? List<E>.empty(growable: true);

  @override
  List<E> get value => _value;

  set value(List<E> newValue) {
    if (const DeepCollectionEquality().equals(value, newValue)) return;
    _value = newValue;
    notifyListeners();
  }
}

/// [List] 变化调用 [notifyListeners] 通知刷新
abstract class AbstractListNotifier<E> extends ListListenable<E> {
  // set value(List<E> newValue);

  @override
  void operator []=(int index, E value) {
    super[index] = value;
    notifyListeners();
  }

  @override
  set first(E value) {
    super.first = value;
    notifyListeners();
  }

  @override
  set last(E value) {
    super.last = value;
    notifyListeners();
  }

  @override
  set length(int newLength) {
    super.length = newLength;
    notifyListeners();
  }

  @override
  void add(E value) {
    super.add(value);
    notifyListeners();
  }

  @override
  void addAll(Iterable<E> iterable) {
    super.addAll(iterable);
    notifyListeners();
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    super.sort(compare);
    notifyListeners();
  }

  @override
  void shuffle([Random? random]) {
    super.shuffle(random);
    notifyListeners();
  }

  @override
  void clear() {
    super.clear();
    notifyListeners();
  }

  @override
  void insert(int index, E element) {
    super.insert(index, element);
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    super.insertAll(index, iterable);
    notifyListeners();
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    super.setAll(index, iterable);
    notifyListeners();
  }

  @override
  bool remove(Object? value) {
    final value2 = super.remove(value);
    notifyListeners();
    return value2;
  }

  @override
  E removeAt(int index) {
    final value = super.removeAt(index);
    notifyListeners();
    return value;
  }

  @override
  E removeLast() {
    final value = super.removeLast();
    notifyListeners();
    return value;
  }

  @override
  void removeWhere(bool test(E element)) {
    super.removeWhere(test);
    notifyListeners();
  }

  @override
  void retainWhere(bool test(E element)) {
    super.retainWhere(test);
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    super.setRange(start, end, iterable);
    notifyListeners();
  }

  @override
  void removeRange(int start, int end) {
    super.removeRange(start, end);
    notifyListeners();
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    super.fillRange(start, end, fillValue);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    super.replaceRange(start, end, replacement);
    notifyListeners();
  }
}

/// 可监听 [List]
abstract class ListListenable<E> extends IterableListenable<List<E>, E>
    implements List<E> {
  @override
  List<R> cast<R>() {
    return value.cast<R>();
  }

  @override
  E operator [](int index) {
    return value[index];
  }

  @override
  void operator []=(int index, E value) {
    this.value[index] = value;
  }

  @override
  set first(E value) {
    this.value.first = value;
  }

  @override
  set last(E value) {
    this.value.last = value;
  }

  @override
  set length(int newLength) {
    value.length = newLength;
  }

  @override
  void add(E value) {
    this.value.add(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    value.addAll(iterable);
  }

  @override
  Iterable<E> get reversed => value.reversed;

  @override
  void sort([int compare(E a, E b)?]) {
    value.sort(compare);
  }

  @override
  void shuffle([Random? random]) {
    value.shuffle(random);
  }

  @override
  int indexOf(E element, [int start = 0]) => value.indexOf(element, start);

  @override
  int indexWhere(bool test(E element), [int start = 0]) =>
      value.indexWhere(test, start);

  @override
  int lastIndexWhere(bool test(E element), [int? start]) =>
      value.lastIndexWhere(test, start);

  @override
  int lastIndexOf(E element, [int? start]) => value.lastIndexOf(element, start);

  @override
  void clear() {
    value.clear();
  }

  @override
  void insert(int index, E element) {
    value.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    value.insertAll(index, iterable);
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    value.setAll(index, iterable);
  }

  @override
  bool remove(Object? value) {
    return this.value.remove(value);
  }

  @override
  E removeAt(int index) {
    return value.removeAt(index);
  }

  @override
  E removeLast() {
    return value.removeLast();
  }

  @override
  void removeWhere(bool test(E element)) {
    value.removeWhere(test);
  }

  @override
  void retainWhere(bool test(E element)) {
    value.retainWhere(test);
  }

  @override
  List<E> operator +(List<E> other) {
    return value + other;
  }

  @override
  List<E> sublist(int start, [int? end]) => value.sublist(start, end);

  @override
  Iterable<E> getRange(int start, int end) => value.getRange(start, end);

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    value.setRange(start, end, iterable);
  }

  @override
  void removeRange(int start, int end) {
    value.removeRange(start, end);
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    value.fillRange(start, end, fillValue);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    value.replaceRange(start, end, replacement);
  }

  @override
  Map<int, E> asMap() => value.asMap();

  @override
  bool operator ==(Object other) => value == other;

  @override
  int get hashCode => value.hashCode;
}

/// 可监听 [Iterable]
abstract class IterableListenable<T extends Iterable<E>, E>
    extends ChangeNotifier implements Iterable<E>, ValueListenable<T> {
  void notifyChange() => notifyListeners();

  // @override
  // abstract T value;

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  Iterable<R> cast<R>() => value.cast<R>();

  @override
  Iterable<E> followedBy(Iterable<E> other) => value.followedBy(other);

  @override
  Iterable<T> map<T>(T f(E e)) => value.map(f);

  @override
  Iterable<E> where(bool test(E element)) => value.where(test);

  @override
  Iterable<T> whereType<T>() => value.whereType();

  @override
  Iterable<T> expand<T>(Iterable<T> f(E element)) => value.expand(f);

  @override
  bool contains(Object? element) => value.contains(element);

  @override
  void forEach(void f(E element)) => value.forEach(f);

  @override
  E reduce(E combine(E value, E element)) => value.reduce(combine);

  @override
  T fold<T>(T initialValue, T combine(T previousValue, E element)) =>
      value.fold(initialValue, combine);

  @override
  bool every(bool test(E element)) => value.every(test);

  @override
  String join([String separator = ""]) => value.join(separator);

  @override
  bool any(bool test(E element)) => value.any(test);

  @override
  List<E> toList({bool growable = true}) => value.toList(growable: growable);

  @override
  Set<E> toSet() => value.toSet();

  @override
  int get length => value.length;

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  Iterable<E> take(int count) => value.take(count);

  @override
  Iterable<E> takeWhile(bool test(E value)) => value.takeWhile(test);

  @override
  Iterable<E> skip(int count) => value.skip(count);

  @override
  Iterable<E> skipWhile(bool test(E value)) => value.skipWhile(test);

  @override
  E get first => value.first;

  @override
  E get last => value.last;

  @override
  E get single => value.single;

  @override
  E firstWhere(bool test(E element), {E orElse()?}) =>
      value.firstWhere(test, orElse: orElse);

  @override
  E lastWhere(bool test(E element), {E orElse()?}) =>
      value.lastWhere(test, orElse: orElse);

  @override
  E singleWhere(bool test(E element), {E orElse()?}) =>
      value.singleWhere(test, orElse: orElse);

  @override
  E elementAt(int index) => value.elementAt(index);

  @override
  String toString() => value.toString();

  @override
  bool operator ==(Object other) => value == other;

  @override
  int get hashCode => value.hashCode;
}
