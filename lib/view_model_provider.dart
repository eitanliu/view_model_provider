import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

import 'lifecycle_widget.dart';
import 'view_model_binding.dart';

export 'package:provider/provider.dart';

export 'view_model_binding.dart';

typedef ViewModelWidgetBuilder<VM> = Widget Function(
    BuildContext context, VM viewModel, Widget child);

typedef ChildViewModelWidgetBuilder<PVM, VM> = Widget Function(
    BuildContext context, PVM parent, VM viewModel, Widget child);

class ViewModelProvider<VM extends ChangeNotifier>
    extends SingleChildStatelessWidget {
  final VM Function(BuildContext context) create;

  final Function(BuildContext context, VM viewModel) initViewModel;

  final Function(BuildContext context, VM viewModel) bindViewModel;

  final Function(BuildContext context, VM viewModel) disposeViewModel;

  final ViewModelWidgetBuilder<VM> builder;

  ViewModelProvider({
    Key key,
    @required this.create,
    this.initViewModel,
    this.bindViewModel,
    this.disposeViewModel,
    Widget child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
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
              return builder?.call(context, value, child) ?? child;
            };
            if (initViewModel != null || disposeViewModel != null) {
              return LifecycleBuilder(
                create: (context) => value,
                initState: (_) => initViewModel?.call(context, value),
                dispose: (_, value) => disposeViewModel?.call(context, value),
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

class ChildViewModelProvider<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> extends SingleChildStatelessWidget {
  final VM Function(BuildContext context, PVM parent) create;

  final Function(BuildContext context, PVM parent, VM viewModel) initViewModel;

  final Function(BuildContext context, PVM parent, VM viewModel) bindViewModel;

  final Function(BuildContext context, PVM parent, VM viewModel)
      disposeViewModel;

  final Function(
          BuildContext context, PVM parent, VM viewModel, VM oldViewModel)
      changeViewModel;

  final ChildViewModelWidgetBuilder<PVM, VM> builder;

  ChildViewModelProvider({
    Key key,
    @required this.create,
    this.initViewModel,
    this.bindViewModel,
    this.disposeViewModel,
    this.changeViewModel,
    Widget child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return ViewModelBinding<PVM, Tuple2<PVM, VM>>(
      selector: (context, pvm) => Tuple2(pvm, create(context, pvm)),
      shouldRebuild: (previous, next) {
        return !const DeepCollectionEquality()
            .equals(previous?.item2, next.item2);
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
                  child;
            };
            if (initViewModel != null ||
                disposeViewModel != null ||
                changeViewModel != null) {
              return LifecycleBuilder<VM>(
                create: (context) => context.viewModel<VM>(),
                initState: (_) =>
                    initViewModel?.call(context, value.item1, value.item2),
                dispose: (_, __) =>
                    disposeViewModel?.call(context, value.item1, value.item2),
                didChangeDependencies: (context, oldValue) {
                  if (!const DeepCollectionEquality()
                      .equals(oldValue, value.item2)) {
                    changeViewModel?.call(
                        context, value.item1, value.item2, oldValue);
                  }
                },
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

class ValueViewModelProvider<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> extends SingleChildStatelessWidget {
  final ValueListenable<VM> Function(BuildContext context, PVM parent) create;

  final Function(BuildContext context, PVM parent, VM viewModel) initViewModel;

  final Function(BuildContext context, PVM parent, VM viewModel) bindViewModel;

  final Function(BuildContext context, PVM parent, VM viewModel)
      disposeViewModel;

  final Function(
          BuildContext context, PVM parent, VM viewModel, VM oldViewModel)
      changeViewModel;

  final ChildViewModelWidgetBuilder<PVM, VM> builder;

  ValueViewModelProvider({
    Key key,
    @required this.create,
    this.initViewModel,
    this.bindViewModel,
    this.disposeViewModel,
    this.changeViewModel,
    Widget child,
    this.builder,
  }) : super(key: key, child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return ViewModelBinding<PVM, Tuple2<PVM, ValueListenable<VM>>>(
      selector: (context, pvm) => Tuple2(pvm, create(context, pvm)),
      child: child,
      builder: (context, value, isBinding, child) {
        return ValueListenableBuilder<VM>(
          valueListenable: value.item2,
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
                      child;
                };
                if (initViewModel != null ||
                    disposeViewModel != null ||
                    changeViewModel != null) {
                  return LifecycleBuilder<VM>(
                    create: (context) => context.viewModel<VM>(),
                    initState: (_) =>
                        initViewModel?.call(context, value.item1, model),
                    dispose: (_, __) =>
                        disposeViewModel?.call(context, value.item1, model),
                    didChangeDependencies: (_, oldValue) {
                      if (!const DeepCollectionEquality()
                          .equals(oldValue, model)) {
                        changeViewModel?.call(
                            context, value.item1, model, oldValue);
                      }
                    },
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
    extends SingleChildStatelessWidget {
  ViewModelProviderWidget({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  VM create(BuildContext context);

  void initViewModel(BuildContext context, VM viewModel) {}

  void bindViewModel(BuildContext context, VM viewModel) {}

  void disposeViewModel(BuildContext context, VM viewModel) {}

  Widget buildChild(BuildContext context, VM viewModel, Widget child);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return ChangeNotifierProvider<VM>(
      create: (_) => create(context),
      child: child,
      builder: (context, child) {
        return ViewModelBinding<VM, VM>(
          selector: (context, vm) => vm,
          child: child,
          builder: (context, value, isBinding, child) {
            return LifecycleBuilder(
              create: (context) => value,
              initState: (_) => initViewModel(context, value),
              dispose: (_, value) => disposeViewModel(context, value),
              builder: (context, setState, value, child) {
                if (isBinding) bindViewModel(context, value);
                return buildChild(context, value, child);
              },
            );
          },
        );
      },
    );
  }
}

abstract class ChildViewModelProviderWidget<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> extends SingleChildStatelessWidget {
  ChildViewModelProviderWidget({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  VM create(BuildContext context, PVM parent);

  void initViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void bindViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void disposeViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void changeViewModel(
      BuildContext context, PVM parent, VM viewModel, VM oldViewModel) {}

  Widget buildChild(
      BuildContext context, PVM parent, VM viewModel, Widget child);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
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
            return LifecycleBuilder<VM>(
              create: (context) => context.viewModel<VM>(),
              initState: (_) =>
                  initViewModel(context, value.item1, value.item2),
              dispose: (_, __) =>
                  disposeViewModel(context, value.item1, value.item2),
              didChangeDependencies: (context, oldValue) {
                if (!const DeepCollectionEquality()
                    .equals(oldValue, value.item2)) {
                  changeViewModel(context, value.item1, value.item2, oldValue);
                }
              },
              builder: (context, setState, model, child) {
                if (isBinding) {
                  bindViewModel?.call(context, value.item1, value.item2);
                }
                return buildChild(context, value.item1, value.item2, child);
              },
            );
          },
        );
      },
    );
  }
}

abstract class ValueViewModelProviderWidget<PVM extends ChangeNotifier,
    VM extends ChangeNotifier> extends SingleChildStatelessWidget {
  ValueViewModelProviderWidget({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  ValueListenable<VM> create(BuildContext context, PVM parent);

  void initViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void bindViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void disposeViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void changeViewModel(
      BuildContext context, PVM parent, VM viewModel, VM oldViewModel) {}

  Widget buildChild(
      BuildContext context, PVM parent, VM viewModel, Widget child);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return ViewModelBinding<PVM, Tuple2<PVM, ValueListenable<VM>>>(
      selector: (context, pvm) => Tuple2(pvm, create(context, pvm)),
      child: child,
      builder: (context, value, isBinding, child) {
        return ValueListenableBuilder<VM>(
          valueListenable: value.item2,
          builder: (context, model, child) {
            return ListenableProvider<VM>.value(
              value: model,
              child: child,
              builder: (context, child) {
                return LifecycleBuilder<VM>(
                  create: (context) => context.viewModel<VM>(),
                  initState: (_) => initViewModel(context, value.item1, model),
                  dispose: (_, __) =>
                      disposeViewModel(context, value.item1, model),
                  didChangeDependencies: (_, oldValue) {
                    if (!const DeepCollectionEquality()
                        .equals(oldValue, model)) {
                      changeViewModel(context, value.item1, model, oldValue);
                    }
                  },
                  builder: (context, setState, model, child) {
                    if (isBinding) {
                      bindViewModel(context, value.item1, model);
                    }
                    return buildChild(context, value.item1, model, child);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

extension ViewModelContext on BuildContext {
  T viewModel<T>() => this.select((T value) => value);
}
