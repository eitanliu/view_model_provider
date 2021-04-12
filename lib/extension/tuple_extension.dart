import 'package:view_model_provider/value_listenable_list_builder.dart';

extension Tuple2Extension<T1, T2> on Tuple2<T1, T2> {
  List<R> toTypeList<R>({
    bool growable = false,
  }) =>
      List<R>.from([item1, item2], growable: growable);
}

extension Tuple3Extension<T1, T2, T3> on Tuple3<T1, T2, T3> {
  List<R> toTypeList<R>({
    bool growable = false,
  }) =>
      List<R>.from([item1, item2, item3], growable: growable);
}

extension Tuple4Extension<T1, T2, T3, T4> on Tuple4<T1, T2, T3, T4> {
  List<R> toTypeList<R>({
    bool growable = false,
  }) =>
      List<R>.from([item1, item2, item3, item4], growable: growable);
}

extension Tuple5Extension<T1, T2, T3, T4, T5> on Tuple5<T1, T2, T3, T4, T5> {
  List<R> toTypeList<R>({
    bool growable = false,
  }) =>
      List<R>.from([item1, item2, item3, item4, item5], growable: growable);
}

extension Tuple6Extension<T1, T2, T3, T4, T5, T6>
    on Tuple6<T1, T2, T3, T4, T5, T6> {
  List<R> toTypeList<R>({
    bool growable = false,
  }) =>
      List<R>.from([item1, item2, item3, item4, item5, item6],
          growable: growable);
}

extension Tuple7Extension<T1, T2, T3, T4, T5, T6, T7>
    on Tuple7<T1, T2, T3, T4, T5, T6, T7> {
  List<R> toTypeList<R>({
    bool growable = false,
  }) =>
      List<R>.from([item1, item2, item3, item4, item5, item6, item7],
          growable: growable);
}
