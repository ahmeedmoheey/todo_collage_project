import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../data_base_manager/todo_dm.dart';
import '../../data_base_manager/user_DM.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/screens/tabs/task_edit/task_edit.dart';
import '../utils/colors_manager.dart';
import '../utils/my_text_style.dart';

class TaskItem extends StatelessWidget {
  TaskItem({super.key, required this.todo, required this.onDeletedTask});

  TodoDM todo;

  Function onDeletedTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.onPrimary),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: .3,
          motion: BehindMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              flex: 2,
              onPressed: (context) {
                deleteTodoFromFireStore(todo);
                onDeletedTask();
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: AppLocalizations.of(context)!.delete,
            ),
          ],
        ),
        endActionPane:
        ActionPane(extentRatio: 0.3, motion: DrawerMotion(), children: [
          SlidableAction(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            flex: 2,
            onPressed: (context) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TaskEdit()));
            },
            backgroundColor: ColorsManager.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: AppLocalizations.of(context)!.edit,
          ),
        ]),
        child: Container(
          //padding: EdgeInsets.all(18),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Container(
                height: 62,
                width: 4,
                decoration: BoxDecoration(
                  color: ColorsManager.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    todo.title,
                    style: MyTextStyle.todoTitle,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    todo.description,
                    style: MyTextStyle.todoDesc,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                      color: ColorsManager.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child:InkWell(
                    onTap: () {
                    },
                    child: const Icon(
                      Icons.check,
                      color: ColorsManager.white,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void deleteTodoFromFireStore(TodoDM todo) async {
    CollectionReference todoCollection = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName); // todo
    DocumentReference todoDoc = todoCollection.doc(todo.id);
    await todoDoc.delete();
  }


}