import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../data_base_manager/todo_dm.dart';
import '../../presentation/screens/tabs/task_edit/task_edit.dart';
import '../utils/colors_manager.dart';
import '../utils/my_text_style.dart';

class TaskItem extends StatelessWidget {
  TaskItem({super.key, required this.todo, required this.onDeletedTask});

  final TodoDM todo;
  final VoidCallback onDeletedTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: .3,
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              flex: 2,
              onPressed: (context) async {
                await deleteTodoFromFireStore(todo);
                onDeletedTask();
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "delete",
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              flex: 2,
              onPressed: (context) async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskEdit(taskId: todo.id),
                  ),
                );

                if (result == true) {
                  onDeletedTask();
                }
              },
              backgroundColor: ColorsManager.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: "edit",
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(15),
          ),
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
              const SizedBox(width: 7),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: MyTextStyle.todoTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    todo.description,
                    style: MyTextStyle.todoDesc,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: ColorsManager.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    // ممكن تضيف هنا لتغيير حالة "Done" لو تحب
                  },
                  child: const Icon(
                    Icons.check,
                    color: ColorsManager.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteTodoFromFireStore(TodoDM todo) async {
    // حذف مباشر من collection 'todo' بدون مستخدم
    DocumentReference todoDoc =
    FirebaseFirestore.instance.collection(TodoDM.collectionName).doc(todo.id);
    await todoDoc.delete();
  }
}
