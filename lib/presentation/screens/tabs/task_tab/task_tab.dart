import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resuable_components/task_item.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../data_base_manager/todo_dm.dart';
import '../../../../data_base_manager/user_DM.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => TasksTabState();
}

class TasksTabState extends State<TasksTab> {
  DateTime calenderSelectedDate = DateTime.now(); //
  List<TodoDM> todosList = [];

  /// empty state

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodosFromFireStore(); //
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              color: ColorsManager.blue,
              height: 90.h,
            ),
            buildCalender(),
          ],
        ),
        Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                print(todosList.length);
                return TaskItem(
                  todo: todosList[index],
                  onDeletedTask: () {
                    getTodosFromFireStore();
                  },
                );
              },
              itemCount: todosList.length,
            ))
      ],
    );
  }

  Widget buildCalender() {
    "SELECT * FROM Customer";
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        //`selectedDate` the new date selected.
      },
      headerProps: const EasyHeaderProps(

        monthPickerType: MonthPickerType.switcher,
        dateFormatter: DateFormatter.fullDateDMY(),
      ),
      dayProps: const EasyDayProps(
        inactiveDayStyle: DayStyle(
          monthStrStyle: TextStyle(
            color: Colors.black
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))
          )
        ),
        disabledDayStyle: DayStyle(
          decoration: BoxDecoration(
            color: Colors.black
          )
        ),
        dayStructure: DayStructure.dayStrDayNum,
        activeDayStyle: DayStyle(
          decoration: BoxDecoration(
       borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff3371FF),
                Color(0xff8426D6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getTodosFromFireStore() async {
    DateTime startOfDay = DateTime(
      calenderSelectedDate.year,
      calenderSelectedDate.month,
      calenderSelectedDate.day,
    );

    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    CollectionReference todoCollection = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName);

    QuerySnapshot snapshot = await todoCollection
        .where(
      'dateTime',
      isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
    )
        .where(
      'dateTime',
      isLessThan: Timestamp.fromDate(endOfDay),
    )
        .get();

    todosList = snapshot.docs.map((doc) {
      return TodoDM.fromFireStore(
        doc.data() as Map<String, dynamic>,
      );
    }).toList();

    setState(() {});
  }

}