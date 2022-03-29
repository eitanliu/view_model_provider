import 'package:flutter/material.dart';
import 'package:view_model_provider/view_model_provider.dart';

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

class ChildProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ParentViewModel>(
      create: (context) => ParentViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

/// [ValueViewModelProvider] 获取子 ViewModel 例子
class ValueViewModelProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueViewModelProvider<ParentViewModel, ChildViewModel>(
      create: (_, parent) => parent.valueViewModel,
      initViewModel: (context, parent, viewModel) {
        debugPrint("ValueViewModelProvider initViewModel $viewModel");
      },
      bindViewModel: (context, parent, viewModel) {
        debugPrint("ValueViewModelProvider bindViewModel $viewModel");
      },
      disposeViewModel: (context, parent, viewModel) {
        debugPrint("ValueViewModelProvider disposeViewModel $viewModel");
      },
      changeViewModel: (context, parent, viewModel, oldViewModel) {
        debugPrint(
            "ValueViewModelProvider changeViewModel $viewModel, $oldViewModel");
      },
      builder: (context, parent, viewModel, child) {
        debugPrint("ValueViewModelProvider builder $viewModel");
        return Row(
          children: [
            ElevatedButton(
              onPressed: () => viewModel.addValue(),
              child: Text("addValue"),
            ),
            ValueListenableBuilder(
              valueListenable: viewModel.value,
              builder: (context, value, child) => Text("${viewModel.value}"),
            ),
          ],
        );
      },
    );
  }
}

/// [ChildViewModelProvider] 获取子 ViewModel 例子
class ChildViewModelProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChildViewModelProvider<ParentViewModel, ChildViewModel>(
      create: (_, parent) => parent.childViewModel,
      initViewModel: (context, parent, viewModel) {
        debugPrint("ChildViewModelProvider initViewModel $viewModel");
      },
      bindViewModel: (context, parent, viewModel) {
        debugPrint("ChildViewModelProvider bindViewModel $viewModel");
      },
      disposeViewModel: (context, parent, viewModel) {
        debugPrint("ChildViewModelProvider disposeViewModel $viewModel");
      },
      changeViewModel: (context, parent, viewModel, oldViewModel) {
        debugPrint(
            "ChildViewModelProvider changeViewModel $viewModel, $oldViewModel");
      },
      builder: (context, parent, viewModel, child) {
        debugPrint("ChildViewModelProvider builder $viewModel");
        return Row(
          children: [
            ElevatedButton(
              onPressed: () => viewModel.addValue(),
              child: Text("addValue"),
            ),
            ValueListenableBuilder(
              valueListenable: viewModel.value,
              builder: (context, value, child) => Text("${viewModel.value}"),
            ),
          ],
        );
      },
    );
  }
}
