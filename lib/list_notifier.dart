import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutter/foundation.dart';

class ListNotifier<E> extends ListListenable<E> {
  ListNotifier(List<E> list) : super(list);

  set value(List<E> newValue) {
    if (const DeepCollectionEquality().equals(_value, newValue)) return;
    _value = newValue;
    notifyListeners();
  }

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
  void sort([int Function(E a, E b) compare]) {
    super.sort(compare);
    notifyListeners();
  }

  @override
  void shuffle([Random random]) {
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
  bool remove(Object value) {
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
  void fillRange(int start, int end, [E fillValue]) {
    super.fillRange(start, end, fillValue);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    super.replaceRange(start, end, replacement);
    notifyListeners();
  }
}

class ListListenable<E> extends IterableListenable<List<E>, E>
    implements List<E> {
  ListListenable(List<E> list) : super(list);

  @override
  List<R> cast<R>() {
    return _value.cast<R>();
  }

  @override
  E operator [](int index) {
    return _value[index];
  }

  @override
  void operator []=(int index, E value) {
    _value[index] = value;
  }

  @override
  set first(E value) {
    _value.first = value;
  }

  @override
  set last(E value) {
    _value.last = value;
  }

  @override
  set length(int newLength) {
    _value.length = newLength;
  }

  @override
  void add(E value) {
    _value.add(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _value.addAll(iterable);
  }

  @override
  Iterable<E> get reversed => _value.reversed;

  @override
  void sort([int compare(E a, E b)]) {
    _value.sort(compare);
  }

  @override
  void shuffle([Random random]) {
    _value.shuffle(random);
  }

  @override
  int indexOf(E element, [int start = 0]) => _value.indexOf(element, start);

  @override
  int indexWhere(bool test(E element), [int start = 0]) =>
      _value.indexWhere(test, start);

  @override
  int lastIndexWhere(bool test(E element), [int start]) =>
      _value.lastIndexWhere(test, start);

  @override
  int lastIndexOf(E element, [int start]) => _value.lastIndexOf(element, start);

  @override
  void clear() {
    _value.clear();
  }

  @override
  void insert(int index, E element) {
    _value.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _value.insertAll(index, iterable);
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _value.setAll(index, iterable);
  }

  @override
  bool remove(Object value) {
    return _value.remove(value);
  }

  @override
  E removeAt(int index) {
    return _value.removeAt(index);
  }

  @override
  E removeLast() {
    return _value.removeLast();
  }

  @override
  void removeWhere(bool test(E element)) {
    _value.removeWhere(test);
  }

  @override
  void retainWhere(bool test(E element)) {
    _value.retainWhere(test);
  }

  @override
  List<E> operator +(List<E> other) {
    return _value + other;
  }

  @override
  List<E> sublist(int start, [int end]) => _value.sublist(start, end);

  @override
  Iterable<E> getRange(int start, int end) => _value.getRange(start, end);

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _value.setRange(start, end, iterable);
  }

  @override
  void removeRange(int start, int end) {
    _value.removeRange(start, end);
  }

  @override
  void fillRange(int start, int end, [E fillValue]) {
    _value.fillRange(start, end, fillValue);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    _value.replaceRange(start, end, replacement);
  }

  @override
  Map<int, E> asMap() => _value.asMap();

  @override
  bool operator ==(Object other) => _value == other;

  @override
  int get hashCode => _value.hashCode;
}

class IterableListenable<T extends Iterable<E>, E> extends ChangeNotifier
    implements Iterable<E>, ValueListenable<T> {
  T _value;

  IterableListenable(T list) : _value = list;

  void notifyChange() => notifyListeners();

  @override
  T get value => _value;

  @override
  Iterator<E> get iterator => _value.iterator;

  @override
  Iterable<R> cast<R>() => _value.cast<R>();

  @override
  Iterable<E> followedBy(Iterable<E> other) => _value.followedBy(other);

  @override
  Iterable<T> map<T>(T f(E e)) => _value.map(f);

  @override
  Iterable<E> where(bool test(E element)) => _value.where(test);

  @override
  Iterable<T> whereType<T>() => _value.whereType();

  @override
  Iterable<T> expand<T>(Iterable<T> f(E element)) => _value.expand(f);

  @override
  bool contains(Object element) => _value.contains(element);

  @override
  void forEach(void f(E element)) => _value.forEach(f);

  @override
  E reduce(E combine(E value, E element)) => _value.reduce(combine);

  @override
  T fold<T>(T initialValue, T combine(T previousValue, E element)) =>
      _value.fold(initialValue, combine);

  @override
  bool every(bool test(E element)) => _value.every(test);

  @override
  String join([String separator = ""]) => _value.join(separator);

  @override
  bool any(bool test(E element)) => _value.any(test);

  @override
  List<E> toList({bool growable = true}) => _value.toList(growable: growable);

  @override
  Set<E> toSet() => _value.toSet();

  @override
  int get length => _value.length;

  @override
  bool get isEmpty => _value.isEmpty;

  @override
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  Iterable<E> take(int count) => _value.take(count);

  @override
  Iterable<E> takeWhile(bool test(E value)) => _value.takeWhile(test);

  @override
  Iterable<E> skip(int count) => _value.skip(count);

  @override
  Iterable<E> skipWhile(bool test(E value)) => _value.skipWhile(test);

  @override
  E get first => _value.first;

  @override
  E get last => _value.last;

  @override
  E get single => _value.single;

  @override
  E firstWhere(bool test(E element), {E orElse()}) =>
      _value.firstWhere(test, orElse: orElse);

  @override
  E lastWhere(bool test(E element), {E orElse()}) =>
      _value.lastWhere(test, orElse: orElse);

  @override
  E singleWhere(bool test(E element), {E orElse()}) =>
      _value.singleWhere(test, orElse: orElse);

  @override
  E elementAt(int index) => _value.elementAt(index);

  @override
  String toString() => _value.toString();

  @override
  bool operator ==(Object other) => _value == other;

  @override
  int get hashCode => _value.hashCode;
}
