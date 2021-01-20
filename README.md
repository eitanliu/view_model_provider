# view_model_provider

A Flutter MVVM Framework.

## Getting Started

基于Provider实现MVVM框架，常用的方式是 ViewModel 继承 ChangeNotifier ，再通过 ChangeNotifierProvider 提供给子Widget，ViewModel数据刷新通过调用 notifyListeners() 来通知Widget进行刷新，Widget 通过 Provider.of 、Consumer、Selector 来监听数据变化重新 build 更新UI。这种方式存在的问题有：

- ViewModel数据刷新需要每次调用 notifyListeners()容易被遗漏
- notifyListeners()作用在整个ViewModel，不方便进行局部UI刷新控制
- Selector 虽然可以控制局部刷新，但需要需要自定义 shouldRebuild 要去了解Provider原理
- 缺少 ViewModel 和 Widget 生命周期的管理

ViewModelProvider 在兼容现有功能基础刷，实现最小改动、不需要每次调用notifyListeners()、支持局部刷新UI和生命周期管理的框架

## 局部刷新控制

### 1. 通过ValueNotifier创建可观察对象

```dart
class ViewModel extends ChangeNotifier {
  final value1 = ValueNotifier(0);
  final value2 = ValueNotifier(0);
}
```

### 2. 通过 ValueListenableBuilder 监听数据变化刷新

```dart
ValueListenableBuilder(
  valueListenable: viewModel.value1,
  builder: (context, value, child) {
    debugPrint("ValueListenableBuilder $value");
    return Text("ValueListenableBuilder $value");
    },
)
```

## 列表刷新控制

### 1. 通过 ListNotifier 创建可观察对象

```dart
class ViewModel extends ChangeNotifier {
  final list = ListNotifier<String>([]);
}
```

### 2. 通过 ListListenableBuilder 监听数据变化刷新

```dart
ListListenableBuilder(
  valueListenable: viewModel.list,
  builder: (context, value, child) {
    debugPrint("ValueListenableBuilder $value");
    return Text("ValueListenableBuilder $value");
    },
)
```

## 实现生命周期管理

LifecycleWidget，提供Widget生命周期监听，开放了以下回调接口可进行初始化和解绑操作

- create，可以监听一个数据变化
- initState，Widget initState 回调
- initFrame，Widget 第一帧绘制完成调用
- deactivate，Widget deactivate 回调
- dispose，Widget dispose 回调
- didUpdateWidget，Widget didUpdateWidget 回调
- didChangeDependencies，Widget didChangeDependencies 回调

## ViewModelProvider

创建ViewModel 提供给子Widget使用，开放了以下回调接口可进行初始化和解绑操作

- initViewModel，ViewModel首次初始化 Widget initState 期间执行
- bindViewModel，ViewModel 首次绑定 Widget ，方法在Widget build 期间执行
- disposeViewModel，ViewModel 销毁，Widget dispose 时执行

```dart
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
```

另外还可以通过继承`ViewModelProviderWidget`来创建ViewModel

```dart
/// 继承 [ViewModelProviderWidget] 创建ViewModel
class ProviderWidgetExample extends ViewModelProviderWidget<ViewModel> {
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
  Widget buildChild(BuildContext context, ViewModel viewModel, Widget child) {
    debugPrint("ProviderWidgetExample build $viewModel");
    return ViewModelWidget(viewModel);
  }
}
```

## ViewModel嵌套处理

ViewModel 嵌套 ViewModel 管理子 ViewModel ，提供了两种方式，一种需要手动调用刷新，另一种通过ValueNotifier包装替换ViewModel不需要手动刷新，同ViewModelProvider一样也有相关的抽象类提供继承支持。

```dart
class ParentViewModel extends ChangeNotifier {
  final valueViewModel = ValueNotifier(ChildViewModel());
  var childViewModel = ChildViewModel();

  void valueNotifier() {
    valueViewModel.value = ChildViewModel();
  }

  void notifyListenerChild() {
    childViewModel = ChildViewModel();
    notifyListeners();
  }
}

class ChildViewModel extends ChangeNotifier {
  final value = ValueNotifier(0);

  addValue() {
    value.value++;
  }
}
```

### 1 通过 ViewModelProvider 创建父ViewModel

```dart
class ChildProviderExapmle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ParentViewModel>(
      create: (context) => ParentViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Container(
            child: Column(
              children: [
                ValueViewModelProviderExample(),
                ChildViewModelProviderExample(),
                ElevatedButton(
                  onPressed: () => viewModel.valueNotifier(),
                  child: Text("valueNotifier"),
                ),
                ElevatedButton(
                  onPressed: () => viewModel.notifyListenerChild(),
                  child: Text("notifyListenerChild"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```


### 2 创建子ViewModelProvider
#### 2-1 ChildViewModelProvider

需要手动刷新通常用于列表刷新Item区域，在ViewModelProvider已有回调基础上添加了

- changeViewModel ，在子 ViewModel 被替换后可重新执行绑定流程

```dart
/// [ChildViewModelProvider] 获取子 ViewModel 例子
class ChildViewModelProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChildViewModelProvider<ParentViewModel, ChildViewModel>(
      create: (_, parent) => parent.childViewModel,
      changeViewModel: (context, parent, viewModel, oldViewModel) {
        debugPrint(
            "ChildViewModelProvider changeViewModel $viewModel, $oldViewModel");
      },
      builder: (context, parent, viewModel, child) {
        debugPrint("ChildViewModelProvider builder $viewModel");
        return Row(
          children: [
            ValueListenableBuilder(
              valueListenable: viewModel.value,
              builder: (context, value, child) => Text("${viewModel.value}"),
            ),
            ElevatedButton(
              onPressed: () => viewModel.addValue(),
              child: Text("addValue"),
            )
          ],
        );
      },
    );
  }
}
```

#### 2-2 ValueViewModelProvider

作用和回调与 ChildViewModelProvider一样，接收数据类型为 `ValueListenable<ChangeNotifier>`

```dart
/// [ValueViewModelProvider] 获取子 ViewModel 例子
class ValueViewModelProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueViewModelProvider<ParentViewModel, ChildViewModel>(
      create: (_, parent) => parent.valueViewModel,
      changeViewModel: (context, parent, viewModel, oldViewModel) {
        debugPrint(
            "ValueViewModelProvider changeViewModel $viewModel, $oldViewModel");
      },
      builder: (context, parent, viewModel, child) {
        debugPrint("ValueViewModelProvider builder $viewModel");
        return Row(
          children: [
            ValueListenableBuilder(
              valueListenable: viewModel.value,
              builder: (context, value, child) => Text("${viewModel.value}"),
            ),
            ElevatedButton(
              onPressed: () => viewModel.addValue(),
              child: Text("addValue"),
            )
          ],
        );
      },
    );
  }
```



## 获取ViewModel

### 1 扩展函数

通过`context.viewModel<ViewModel>()` 可以快速取出`ViewModelProvider` `ChildViewModelProvider`和 `ValueViewModelProvider`的ViewModel
### 2 ViewModelBuilder

用于取出ViewModelProvider提供的ViewModel

## ValueListenableBuilder

 ValueListenableBuilder 只能监听当额数据刷新，同时监听多个数据刷新可采用**ValueTuple2WidgetBuilder**到**ValueListenableTuple7Builder** 和 **ValueListenableListBuilder**

```dart
  /// 外部传入 ViewModel，可采用[ValueListenableBuilder]系列监听数据变化
  Widget _buildValueListenable(ViewModel viewModel) {
    return Column(
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
```



## ViewModelValueBuilder

ViewModelBuilder 和 ValueListenableBuilder 组合，用于获取 ViewModel 和管理Widget刷新区域。

提供过个实现 **ViewModelValueListBuilder**，**ViewModelValueTuple2Builder** 到 **ViewModelValueTuple7WidgetBuilder**可同时监听多个ViewMode参数变化来刷新Widget

```dart
  /// 不通过外部传入 ViewModel，可采用[ViewModelValueBuilder]系列获取 ViewModel 并监听数据变化
  Widget _buildViewModelValue() {
    return Column(
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
```


