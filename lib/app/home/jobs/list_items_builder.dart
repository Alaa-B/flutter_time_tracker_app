import 'package:flutter/material.dart';

import 'empty_job_page.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder(
      {super.key, required this.snapshot, required this.itemBuilder});

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items != null && items.isNotEmpty) {
        return _buildList(items);
      } else {
        return const EmptyJobPage();
      }
    } else if (snapshot.hasError) {
      debugPrint(snapshot.error.toString());
      return const EmptyJobPage(
          tittle: 'Something went wrong',
          message: "Can't load items right now");
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
        itemCount: items.length + 2,
        separatorBuilder: (context, index) => const Divider(thickness: .5,),
        itemBuilder: (context, index) {
          if (index == 0 || index == items.length + 1) {
            return const SizedBox.shrink();
          }
          return itemBuilder(context, items[index - 1]);
        });
  }
}
