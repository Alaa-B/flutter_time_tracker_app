import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/app/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold(
      {super.key,
      required this.currentTab,
      required this.tabChange,
      required this.widgetBuilder,
      required this.navigatorKeys});

  final TabItem currentTab;
  final ValueChanged<TabItem> tabChange;
  final Map<TabItem, WidgetBuilder> widgetBuilder;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildNavigationBarItem(TabItem.jobs),
          _buildNavigationBarItem(TabItem.entries),
          _buildNavigationBarItem(TabItem.account),
        ],
        onTap: (index) => tabChange(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilder[item]!(context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(TabItem tabItem) {
    final tabItemData = TabItemData.allTabs[tabItem]!;
    final color = currentTab == tabItem ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        tabItemData.icon,
        color: color,
      ),
      label: tabItemData.label,
    );
  }
}
