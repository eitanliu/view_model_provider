import 'package:flutter/material.dart';
import 'package:view_model_provider/view_model.dart';

class ViewModel extends ChangeNotifier {
  final value1 = ValueNotifier(0);
  final value2 = ValueNotifier(0);

  addValue1() {
    value1.value++;
  }

  addValue2() {
    value2.value++;
  }
}

/// 监听数据变化
class ViewModelWidget extends StatelessWidget {
  final ViewModel viewModel;

  const ViewModelWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildValueListenable(viewModel),
          _buildViewModelValue(),
          ElevatedButton(
            onPressed: () => viewModel.addValue1(),
            child: Text("addValue1"),
          ),
          ElevatedButton(
            onPressed: () => viewModel.addValue2(),
            child: Text("addValue2"),
          ),
        ],
      ),
    );
  }

  /// 外部传入 ViewModel，可采用[ValueListenableBuilder]系列监听数据变化
  Widget _buildValueListenable(ViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 监听单个数据变化
        ValueListenableBuilder(
            valueListenable: viewModel.value1,
            builder: (context, value, child) {
              debugPrint("ValueListenableBuilder $value");
              return Text("ValueListenableBuilder $value");
            }),

        /// 监听多个数据变化，继承自
        ValueListenableListBuilder(
          valueListenables: [
            viewModel.value1,
            viewModel.value2,
          ],
          builder: (context, value, child) {
            debugPrint(
                "ValueListenableListBuilder ${value.first}, ${value.last}");
            return Text(
                "ValueListenableListBuilder ${value.first}, ${value.last}");
          },
        ),

        /// 监听多个数据变化，继承自[ValueListenableListBuilder]可指定泛型
        ValueListenableTuple2Builder(
          valueListenables: Tuple2(viewModel.value1, viewModel.value2),
          builder: (context, value, child) {
            debugPrint(
                "ValueListenableTuple2Builder ${value.item1}, ${value.item2}");
            return Text(
                "ValueListenableTuple2Builder ${value.item1}, ${value.item2}");
          },
        ),
      ],
    );
  }

  /// 不通过外部传入 ViewModel，可采用[ViewModelValueBuilder]系列获取 ViewModel 并监听数据变化
  Widget _buildViewModelValue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewModelValueBuilder(
          valueListenable: (ViewModel viewModel) => viewModel.value1,
          builder: (context, viewModel, value, child) {
            debugPrint("ViewModelValueBuilder $value");
            return Text("ViewModelValueBuilder $value");
          },
        ),
        ViewModelValueListBuilder(
          valueListenables: (ViewModel viewModel) => [
            viewModel.value1,
            viewModel.value2,
          ],
          builder: (context, viewModel, value, child) {
            debugPrint(
                "ViewModelValueListBuilder ${value.first}, ${value.last}");
            return Text(
                "ViewModelValueListBuilder ${value.first}, ${value.last}");
          },
        ),
        ViewModelValueTuple2Builder(
          valueListenables: (ViewModel viewModel) =>
              Tuple2(viewModel.value1, viewModel.value2),
          builder: (context, viewModel, value, child) {
            debugPrint(
                "ViewModelValueTuple2Builder ${value.item1}, ${value.item2}");
            return Text(
                "ViewModelValueTuple2Builder ${value.item1}, ${value.item2}");
          },
        ),
      ],
    );
  }
}

/// [ViewModelProvider] 创建ViewModel
class ProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ViewModel>(
      create: (_) => ViewModel(),
      initViewModel: (context, viewModel) {
        debugPrint("ProviderBuilderExample initViewModel $viewModel");
      },
      bindViewModel: (context, viewModel) {
        debugPrint("ProviderBuilderExample bindViewModel $viewModel");
      },
      disposeViewModel: (context, viewModel) {
        debugPrint("ProviderBuilderExample disposeViewModel $viewModel");
      },
      builder: (context, viewModel, child) {
        debugPrint("ProviderBuilderExample builder $viewModel");
        return ViewModelWidget(viewModel);
      },
    );
  }
}

/// 继承 [ViewModelProviderWidget] 创建ViewModel
class ProviderWidgetExample extends ViewModelProviderWidget<ViewModel>
    with ViewModelProviderLifecycle<ViewModel> {
  ProviderWidgetExample() : super();

  @override
  ViewModel create(BuildContext context) => ViewModel();

  @override
  void initViewModel(BuildContext context, ViewModel viewModel) {
    debugPrint("ProviderWidgetExample initViewModel $viewModel");
  }

  @override
  void bindViewModel(BuildContext context, ViewModel viewModel) {
    debugPrint("ProviderWidgetExample bindViewModel $viewModel");
  }

  @override
  Widget buildChild(BuildContext context, ViewModel viewModel, Widget? child) {
    debugPrint("ProviderWidgetExample build $viewModel");
    return ViewModelWidget(viewModel);
  }
}

/// 混入 [ViewModelProviderMixin] 创建ViewModel
/// 混入 [ViewModelProviderLifecycle] 监听ViewModel生命周期
/// 混入 [ViewModelProviderBuilder] 支持buildChild
class ProviderMixinExample extends SingleChildStatelessWidget
    with
        ViewModelProviderMixin<ViewModel>,
        ViewModelProviderLifecycle<ViewModel>,
        ViewModelProviderBuilder<ViewModel> {
  ProviderMixinExample() : super();

  @override
  ViewModel create(BuildContext context) => ViewModel();

  @override
  void initViewModel(BuildContext context, ViewModel viewModel) {
    debugPrint("ProviderMixinExample initViewModel $viewModel");
  }
  @override
  void initFrame(BuildContext context, ViewModel viewModel) {
    debugPrint("ProviderMixinExample initFrame $viewModel");
    super.initFrame(context, viewModel);
  }

  @override
  void bindViewModel(BuildContext context, ViewModel viewModel) {
    debugPrint("ProviderMixinExample bindViewModel $viewModel");
  }

  @override
  Widget buildChild(BuildContext context, ViewModel viewModel, Widget? child) {
    debugPrint("ProviderMixinExample build $viewModel");
    return ViewModelWidget(viewModel);
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return buildProvider(context, child);
  }
}

/// 混入调用 [ViewModelProviderLifecycleMixin.buildLifecycle] 支持监听ViewModel生命周期
/// 混入 [ViewModelProviderLifecycle] 监听ViewModel生命周期
class ProviderLifecycleMixinExample extends SingleChildStatelessWidget
    with
        ViewModelProviderLifecycleMixin<ViewModel>,
        ViewModelProviderLifecycle<ViewModel> {
  ProviderLifecycleMixinExample() : super();

  @override
  void initViewModel(BuildContext context, ViewModel viewModel) {
    debugPrint(
        "ViewModelProviderLifecycleMixinExample initViewModel $viewModel");
  }

  @override
  void bindViewModel(BuildContext context, ViewModel viewModel) {
    debugPrint(
        "ViewModelProviderLifecycleMixinExample bindViewModel $viewModel");
  }

  Widget buildChild(BuildContext context, ViewModel viewModel, Widget? child) {
    return buildLifecycle(
      context,
      child,
      builder: (context, viewModel, child) {
        debugPrint("ViewModelProviderLifecycleMixinExample build $viewModel");
        return ViewModelWidget(viewModel);
      },
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ViewModelProvider<ViewModel>(
      create: (context) => ViewModel(),
      builder: buildChild,
    );
  }
}
