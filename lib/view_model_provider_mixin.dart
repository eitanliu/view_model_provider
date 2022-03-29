import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'view_model_provider.dart';

abstract class ViewModelProviderMixin<VM extends ChangeNotifier>
    implements ViewModelProviderCreate<VM> {
  get _lifecycle => this as ViewModelProviderLifecycle<VM>?;

  get _builder => this as ViewModelProviderBuilder<VM>?;

  @protected
  Widget buildProvider(
    BuildContext context,
    Widget? child, [
    ViewModelWidgetBuilder<VM>? builder,
  ]) {
    return ViewModelProvider<VM>(
      create: create,
      initViewModel: _lifecycle?.initViewModel,
      bindViewModel: _lifecycle?.bindViewModel,
      disposeViewModel: _lifecycle?.disposeViewModel,
      child: child,
      builder: builder ?? _builder?.buildChild,
    );
  }
}

abstract class ChildViewModelProviderMixin<PVM extends ChangeNotifier,
        VM extends ChangeNotifier>
    implements ChildViewModelProviderCreate<PVM, VM> {
  get _lifecycle => this as ChildViewModelProviderLifecycle<PVM, VM>?;

  get _builder => this as ChildViewModelProviderBuilder<PVM, VM>?;

  @protected
  Widget buildProvider(
    BuildContext context,
    Widget? child, [
    ViewModelWidgetBuilder<VM>? builder,
  ]) {
    return ChildViewModelProvider(
      create: create,
      initViewModel: _lifecycle?.initViewModel,
      bindViewModel: _lifecycle?.bindViewModel,
      disposeViewModel: _lifecycle?.disposeViewModel,
      changeViewModel: _lifecycle?.changeViewModel,
      child: child,
      builder: builder ?? _builder?.buildChild,
    );
  }
}

abstract class ValueViewModelProviderMixin<PVM extends ChangeNotifier,
        VM extends ChangeNotifier>
    implements ValueViewModelProviderCreate<PVM, VM> {
  get _lifecycle => this as ChildViewModelProviderLifecycle<PVM, VM>?;

  get _builder => this as ChildViewModelProviderBuilder<PVM, VM>?;

  @protected
  Widget buildProvider(
    BuildContext context,
    Widget? child, [
    ViewModelWidgetBuilder<VM>? builder,
  ]) {
    return ValueViewModelProvider(
      create: create,
      initViewModel: _lifecycle?.initViewModel,
      bindViewModel: _lifecycle?.bindViewModel,
      disposeViewModel: _lifecycle?.disposeViewModel,
      changeViewModel: _lifecycle?.changeViewModel,
      child: child,
      builder: builder ?? _builder?.buildChild,
    );
  }
}

abstract class ViewModelProviderCreate<VM> {
  VM create(BuildContext context);
}

abstract class ViewModelProviderBuilder<VM> {
  Widget buildChild(BuildContext context, VM viewModel, Widget? child);
}

abstract class ViewModelProviderLifecycle<VM> {
  void initViewModel(BuildContext context, VM viewModel) {}

  void bindViewModel(BuildContext context, VM viewModel) {}

  void disposeViewModel(BuildContext context, VM viewModel) {}
}

abstract class ChildViewModelProviderCreate<PVM, VM> {
  VM create(BuildContext context, PVM parent);
}

abstract class ValueViewModelProviderCreate<PVM, VM> {
  ValueListenable<VM> create(BuildContext context, PVM parent);
}

abstract class ChildViewModelProviderBuilder<PVM, VM> {
  Widget buildChild(
      BuildContext context, PVM parent, VM viewModel, Widget? child);
}

abstract class ChildViewModelProviderLifecycle<PVM, VM> {
  void initViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void bindViewModel(BuildContext context, PVM parent, VM viewModel) {}

  void changeViewModel(
      BuildContext context, PVM parent, VM viewModel, VM? oldViewModel) {}

  void disposeViewModel(BuildContext context, PVM parent, VM viewModel) {}
}
