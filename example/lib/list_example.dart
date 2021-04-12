import 'package:flutter/material.dart';
import 'package:view_model_provider/list_notifier.dart';
import 'package:view_model_provider/view_model.dart';

class ParentViewModel extends ChangeNotifier {
  var _page = 0;
  final list = ListNotifier<ItemViewModel>();

  void refresh() {
    debugPrint("refresh");
    _page = 0;
    final newList = List<ItemViewModel>.empty(growable: true);
    for (int i = 0; i < 10; i++) {
      newList.add(ItemViewModel.value("title", i, _page, false));
    }
    list.value = newList;
  }

  void load() {
    debugPrint("load");
    for (int i = 0; i < 10; i++) {
      // 通过.value进行操作不触发刷新
      list.value.add(ItemViewModel.value("title", i, _page, false));
    }
    list.notifyChange();
    _page++;
  }

  void remove(int index) {
    debugPrint("remove $index");
    list.removeAt(index);
  }

  void replace(int index) {
    debugPrint("replace $index");
    list[index] = ItemViewModel.value("replace", index, _page, false);
  }
}

class ItemViewModel extends ChangeNotifier {
  final title = ValueNotifier("");
  final index = ValueNotifier(0);
  final page = ValueNotifier(0);
  final isChecked = ValueNotifier(false);

  static ItemViewModel value(
    String title,
    int index,
    int page,
    bool isChecked,
  ) =>
      ItemViewModel()
        ..title.value = title
        ..index.value = index
        ..page.value = page
        ..isChecked.value = isChecked;

  switchChecked() {
    isChecked.value = !isChecked.value;
  }
}

class ListProviderExapmle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ParentViewModel>(
      create: (context) => ParentViewModel(),
      initViewModel: (context, viewModel) => viewModel.load(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => viewModel.refresh(),
                      child: Text("Refresh"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => viewModel.load(),
                      child: Text("Load"),
                    ),
                  ],
                ),
                Expanded(
                  /// [ListListenableBuilder] 监听列表变化进行刷新
                  child: ListListenableBuilder<ItemViewModel>(
                    listListenable: viewModel.list,
                    builder: (context, value, child) => ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return ItemWidget(index: index);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ItemWidget extends StatelessWidget {
  final int index;

  const ItemWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// [ChildViewModelProvider]取出[ListNotifier]列表数据，管理Item刷新范围
    return ChildViewModelProvider<ParentViewModel, ItemViewModel>(
      create: (_, parent) => parent.list[index],
      initViewModel: (context, parent, viewModel) {
        debugPrint("ItemWidget initViewModel $index, $viewModel");
      },
      changeViewModel: (context, parent, viewModel, oldViewModel) {
        debugPrint(
            "ItemWidget changeViewModel $index, $viewModel, $oldViewModel");
      },
      bindViewModel: (context, parent, viewModel) {
        debugPrint("ItemWidget bindViewModel $index, $viewModel");
      },
      disposeViewModel: (context, parent, viewModel) {
        debugPrint("ItemWidget disposeViewModel $index, $viewModel");
      },
      builder: (context, parent, viewModel, child) {
        debugPrint("ItemWidget builder $index, $viewModel");
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: viewModel.isChecked,
                  builder: (context, value, child) => Checkbox(
                    value: value,
                    onChanged: (value) => viewModel.switchChecked(),
                  ),
                ),
                ValueListenableTuple3Builder<String, int, int>(
                  valueListenables: Tuple3(
                    viewModel.title,
                    viewModel.index,
                    viewModel.page,
                  ),
                  builder: (context, value, child) => Text(
                      "${value.item1} index ${value.item2}, page ${value.item3}"),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => parent.replace(index),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.refresh),
                  ),
                ),
                GestureDetector(
                  onTap: () => parent.remove(index),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
