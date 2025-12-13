import 'package:flutter/material.dart';
import '../../../core/utils/colors_manager.dart';
import '../../../l10n/app_localizations.dart';
import '../add_task_bottom_sheet/Add_task_bottom_sheet.dart';
import '../tabs/settings_tab/settings_tab.dart';
import '../tabs/task_tab/task_tab.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<TasksTabState> tasksTabKey = GlobalKey();
  int currentIndex = 0;
  List<Widget> tabs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs = [
      TasksTab(
        key: tasksTabKey,
      ),
      SettingsTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(  AppLocalizations.of(context)!.todoList,style:TextStyle(
          color: ColorsManager.white

        ),),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildFab(),
      bottomNavigationBar: buildBottomNavBar(),
      body: tabs[currentIndex],
    );
  }

  Widget buildBottomNavBar() => ClipRRect(
    clipBehavior: Clip.antiAlias,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
    ),
    child: BottomAppBar(
      notchMargin: 8,
      child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (tappedIndex) {
            currentIndex = tappedIndex;
            setState(() {});
          },
          items:  [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: AppLocalizations.of(context)!.tasks),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: AppLocalizations.of(context)!.settings),
          ]),
    ),
  );

  Widget buildFab() => FloatingActionButton(
    onPressed: () async {
      await AddTaskBottomSheet.show(context); // 2
      // access reading data from firestore
      tasksTabKey.currentState?.getTodosFromFireStore();
    },
    child: Icon(Icons.add),
  );
}