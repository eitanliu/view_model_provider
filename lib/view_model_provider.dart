import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tuple/tuple.dart';

import 'lifecycle_widget.dart';
import 'view_model_binding.dart';
import 'view_model_provider_mixin.dart';

export 'package:provider/single_child_widget.dart';

export 'view_model_binding.dart';
export 'view_model_provider_mixin.dart';

typedef ViewModelWidgetCallback<VM> = void Function(
    BuildContext context, VM viewModel);

typedef ViewModelWidgetChange<VM> = void Function(
    BuildContext context, VM viewModel, VM? oldViewModel);

typedef ViewModelWidgetBuilder<VM> = Widget Function(
    BuildContext context, VM viewModel, Widget? child);

typedef PairViewModelWidgetCallback<PVM, VM> = void Function(
    BuildContext context, PVM parent, VM viewModel);

typedef PairViewModelWidgetChange<PVM, VM> = void Function(
    BuildContext context, PVM parent, VM viewModel, VM? oldViewModel);

typedef PairViewModelWidgetBuilder<PVM, VM> = Widget Function(
    BuildContext context, PVM parent, VM viewModel, Widget? child);

class ViewModelProvider<VM extends ChangeNotifier>
    extends SingleChildStatelessWidget {
  final VM Function(BuildContext context) create;

  final ViewModelWidgetCallback<VM>? initViewModel;

  final ViewModelWidgetCallback<VM>? initFrame;

  final ViewModelWidgetCallback<VM>? bindViewModel;

  final ViewModelWidgetCallback<VM>? disposeViewModel;

  final ViewModelWidgetBuilder<VM>? builder;

  ViewModelProvider({
    Key? key,
    required this.create,
    this.initViewModel,
    this.initFrame,
    this.bindViewModel,
    this.disposeViewModel,
    Widget? child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ChangeNotifierProvider<VM>(
      create: (_) => create(context),
      child: child,
      builder: (context, child) {
        return ViewModelBinding<VM, VM>(
          selector: (context, vm) => vm,
          child: child,
          builder: (context, value, isBinding, child) {
            final buildWidget = () {
              if (isBinding) bindViewModel?.call(context, value);
              return builder?.call(context, value, child) ??
                  child ??
                  const SizedBox();
            };
            if (initViewModel != null ||
                initFrame != null ||
                disposeViewModel != null) {
              return LifecycleBuilder<VM>(
                create: (context) => value,
                initState: (_) => initViewModel?.call(context, value),
                initFrame: (_, __) => initFrame?.call(context, value),
                dispose: (_, value) => disposeViewModel?.call(context, value),
                child: child,
                builder: (context, setState, value, child) => buildWidget(),
              );
            }
            return buildWidget();
          },
        );
      },
    );
  }
}

class ChildViewModelProvider<VM extends ChangeNotifier>
    extends SingleChildStatelessWidget {
  final VM Function(BuildContext context) create;

  final ViewModelWidgetCallback<VM>? initViewModel;

  final ViewModelWidgetCallback<VM>? initFrame;

  final ViewModelWidgetCallback<VM>? bindViewModel;

  final ViewModelWidgetCallback<VM>? disposeViewModel;

  final ViewModelWidgetChange<VM>? changeViewModel;

  final ViewModelWidgetBuilder<VM>? builder;

  ChildViewModelProvider({
    Key? key,
    required this.create,
    this.initViewModel,
    this.initFrame,
    this.bindViewModel,
    this.disposeViewModel,
    this.changeViewModel,
    Widget? child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ViewModelBinding0<VM>(
      selector: (context) => create(context),
      shouldRebuild: (previous, next) {
        return !const DeepCollectionEquality().equals(previous, next);
      },
      child: child,
      builder: (context, value, isBinding, child) {
        return ListenableProvider.value(
          value: value,
          child: child,
          builder: (context, child) {
            final buildWidget = () {
              if (isBinding) {
                bindViewModel?.call(context, value);
              }
              return builder?.call(context, value, child) ??
                  child ??
                  const SizedBox();
            };
            if (initViewModel != null ||
                initFrame != null ||
                disposeViewModel != null ||
                changeViewModel != null) {
              return LifecycleBuilder<VM>(
                create: (context) => context.viewModel<VM>(),
                initState: (_) => initViewModel?.call(context, value),
                initFrame: (_, __) => initFrame?.call(context, value),
                dispose: (_, __) => disposeViewModel?.call(context, value),
                didChangeDependencies: (context, oldValue) {
                  if (!const DeepCollectionEquality().equals(oldValue, value)) {
                    changeViewModel?.call(context, value, oldValue);
                  }
                },
                child: child,
                builder: (context, setState, value, child) => buildWidget(),
              );
            }
            return buildWidget();
          },
        );
      },
    );
  }
}

class ValueViewModelProvider<VM extends ChangeNotifier>
    extends SingleChildStatelessWidget {
  final ValueListenable<VM> Function(BuildContext context) create;

  final ViewModelWidgetCallback<VM>? initViewModel;

  final ViewModelWidgetCallback<VM>? initFrame;

  final ViewModelWidgetCallback<VM>? bindViewModel;

  final ViewModelWidgetCallback<VM>? disposeViewModel;

  final ViewModelWidgetChange<VM>? changeViewModel;

  final ViewModelWidgetBuilder<VM>? builder;

  ValueViewModelProvider({
    Key? key,
    required this.create,
    this.initViewModel,
    this.initFrame,
    this.bindViewModel,
    this.disposeViewModel,
    this.changeViewModel,
    Widget? child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ViewModelBinding0<ValueListenable<VM>>(
      selector: (context) => create(context),
      child: child,
      builder: (context, value, isBinding, child) {
        return ValueListenableBuilder<VM>(
          valueListenable: value,
          child: child,
          builder: (context, model, child) {
            return ListenableProvider<VM>.value(
              value: model,
              child: child,
              builder: (context, child) {
                final buildWidget = () {
                  if (isBinding) {
                    bindViewModel?.call(context, model);
                  }
                  return builder?.call(context, model, child) ??
                      child ??
                      const SizedBox();
                };
                if (initViewModel != null ||
                    disposeViewModel != null ||
                    changeViewModel != null) {
                  return LifecycleBuilder<VM>(
                    create: (context) => context.viewModel<VM>(),
                    initState: (_) => initViewModel?.call(context, model),
                    initFrame: (_, __) => initFrame?.call(context, model),
                    dispose: (_, __) => disposeViewModel?.call(context, model),
                    didChangeDependencies: (_, oldValue) {
                      if (!const DeepCollectionEquality()
                          .equals(oldValue, model)) {
                        changeViewModel?.call(context, model, oldValue);
                      }
                    },
                    child: child,
                    builder: (context, setState, model, child) => buildWidget(),
                  );
                }
                return buildWidget();
              },
            );
          },
        );
      },
    );
  }
}

class PairChildViewModelProvider<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> extends SingleChildStatelessWidget {
  final VM Function(BuildContext context, PVM parent) create;

  final PairViewModelWidgetCallback<PVM, VM>? initViewModel;

  final PairViewModelWidgetCallback<PVM, VM>? initFrame;

  final PairViewModelWidgetCallback<PVM, VM>? bindViewModel;

  final PairViewModelWidgetCallback<PVM, VM>? disposeViewModel;

  final PairViewModelWidgetChange<PVM, VM>? changeViewModel;

  final PairViewModelWidgetBuilder<PVM, VM>? builder;

  PairChildViewModelProvider({
    Key? key,
    required this.create,
    this.initViewModel,
    this.initFrame,
    this.bindViewModel,
    this.disposeViewModel,
    this.changeViewModel,
    Widget? child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ViewModelBinding<PVM, Tuple2<PVM, VM>>(
      selector: (context, pvm) => Tuple2(pvm, create(context, pvm)),
      shouldRebuild: (previous, next) {
        return !const DeepCollectionEquality()
            .equals(previous.item2, next.item2);
      },
      child: child,
      builder: (context, value, isBinding, child) {
        return ListenableProvider.value(
          value: value.item2,
          child: child,
          builder: (context, child) {
            final buildWidget = () {
              if (isBinding) {
                bindViewModel?.call(context, value.item1, value.item2);
              }
              return builder?.call(context, value.item1, value.item2, child) ??
                  child ??
                  const SizedBox();
            };
            if (initViewModel != null ||
                initFrame != null ||
                disposeViewModel != null ||
                changeViewModel != null) {
              return LifecycleBuilder<VM>(
                create: (context) => context.viewModel<VM>(),
                initState: (_) =>
                    initViewModel?.call(context, value.item1, value.item2),
                initFrame: (_, __) =>
                    initFrame?.call(context, value.item1, value.item2),
                dispose: (_, __) =>
                    disposeViewModel?.call(context, value.item1, value.item2),
                didChangeDependencies: (context, oldValue) {
                  if (!const DeepCollectionEquality()
                      .equals(oldValue, value.item2)) {
                    changeViewModel?.call(
                        context, value.item1, value.item2, oldValue);
                  }
                },
                child: child,
                builder: (context, setState, value, child) => buildWidget(),
              );
            }
            return buildWidget();
          },
        );
      },
    );
  }
}

class PairValueViewModelProvider<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> extends SingleChildStatelessWidget {
  final ValueListenable<VM> Function(BuildContext context, PVM parent) create;

  final PairViewModelWidgetCallback<PVM, VM>? initViewModel;

  final PairViewModelWidgetCallback<PVM, VM>? initFrame;

  final PairViewModelWidgetCallback<PVM, VM>? bindViewModel;

  final PairViewModelWidgetCallback<PVM, VM>? disposeViewModel;

  final PairViewModelWidgetChange<PVM, VM>? changeViewModel;

  final PairViewModelWidgetBuilder<PVM, VM>? builder;

  PairValueViewModelProvider({
    Key? key,
    required this.create,
    this.initViewModel,
    this.initFrame,
    this.bindViewModel,
    this.disposeViewModel,
    this.changeViewModel,
    Widget? child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ViewModelBinding<PVM, Tuple2<PVM, ValueListenable<VM>>>(
      selector: (context, pvm) => Tuple2(pvm, create(context, pvm)),
      child: child,
      builder: (context, value, isBinding, child) {
        return ValueListenableBuilder<VM>(
          valueListenable: value.item2,
          child: child,
          builder: (context, model, child) {
            return ListenableProvider<VM>.value(
              value: model,
              child: child,
              builder: (context, child) {
                final buildWidget = () {
                  if (isBinding) {
                    bindViewModel?.call(context, value.item1, model);
                  }
                  return builder?.call(context, value.item1, model, child) ??
                      child ??
                      const SizedBox();
                };
                if (initViewModel != null ||
                    disposeViewModel != null ||
                    changeViewModel != null) {
                  return LifecycleBuilder<VM>(
                    create: (context) => context.viewModel<VM>(),
                    initState: (_) =>
                        initViewModel?.call(context, value.item1, model),
                    initFrame: (_, __) =>
                        initFrame?.call(context, value.item1, model),
                    dispose: (_, __) =>
                        disposeViewModel?.call(context, value.item1, model),
                    didChangeDependencies: (_, oldValue) {
                      if (!const DeepCollectionEquality()
                          .equals(oldValue, model)) {
                        changeViewModel?.call(
                            context, value.item1, model, oldValue);
                      }
                    },
                    child: child,
                    builder: (context, setState, model, child) => buildWidget(),
                  );
                }
                return buildWidget();
              },
            );
          },
        );
      },
    );
  }
}

abstract class ViewModelProviderWidget<VM extends ChangeNotifier>
    extends SingleChildStatelessWidget
    with ViewModelProviderMixin<VM>
    implements ViewModelProviderBuilder<VM> {
  ViewModelProviderWidget({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return buildProvider(context, child);
  }
}

abstract class ChildViewModelProviderWidget<PVM extends ChangeNotifier,
        VM extends ChangeNotifier> extends SingleChildStatelessWidget
    with PairChildViewModelProviderMixin<PVM, VM> {
  ChildViewModelProviderWidget({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return buildProvider(context, child);
  }
}

abstract class ValueViewModelProviderWidget<PVM extends ChangeNotifier,
        VM extends ChangeNotifier> extends SingleChildStatelessWidget
    with PairValueViewModelProviderMixin<PVM, VM>
    implements PairViewModelProviderBuilder<PVM, VM> {
  ValueViewModelProviderWidget({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  Widget buildChild(
      BuildContext context, PVM parent, VM? viewModel, Widget? child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return buildProvider(context, child);
  }
}

extension ViewModelContext on BuildContext {
  T viewModel<T>() => this.select((T value) => value);
}
