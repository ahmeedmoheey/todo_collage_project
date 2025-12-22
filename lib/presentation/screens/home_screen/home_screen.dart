import 'package:flutter/material.dart';
import '../../../core/utils/colors_manager.dart';
import '../add_task_bottom_sheet/Add_task_bottom_sheet.dart';
import '../tabs/settings_tab/settings_tab.dart';
import '../tabs/task_tab/task_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<TasksTabState> tasksTabKey = GlobalKey();
  int currentIndex = 0;
  late List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      TasksTab(key: tasksTabKey), // TasksTab مع الـ key عشان نعمل refresh
      const SettingsTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ToDo List',
          style: TextStyle(color: ColorsManager.white),
        ),
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
          setState(() {
            currentIndex = tappedIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    ),
  );

  Widget buildFab() => FloatingActionButton(
    onPressed: () async {
      // تمرير callback لتحديث TasksTab فور إضافة التاسك
      await AddTaskBottomSheet.show(
        context,
        onTaskAdded: () {
          tasksTabKey.currentState?.getTodosFromFireStore();
        },
      );
    },
    child: const Icon(Icons.add),
  );
}
