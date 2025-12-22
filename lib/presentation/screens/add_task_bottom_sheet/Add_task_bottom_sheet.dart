import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data_base_manager/todo_dm.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final VoidCallback? onTaskAdded;

  const AddTaskBottomSheet({super.key, this.onTaskAdded});

  static Future show(BuildContext context, {VoidCallback? onTaskAdded}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AddTaskBottomSheet(onTaskAdded: onTaskAdded),
      ),
    );
  }

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add Task',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Task title'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Task description'),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => selectedDate = picked);
            },
            child: Text(
              selectedDate.toFormattedDate,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: addTaskToFirestore,
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  void addTaskToFirestore() async {
    CollectionReference todoCollection =
    FirebaseFirestore.instance.collection(TodoDM.collectionName);

    DocumentReference docRef = todoCollection.doc();

    TodoDM todo = TodoDM(
      id: docRef.id,
      title: titleController.text,
      description: descriptionController.text,
      dateTime: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      ),
      isDone: false,
    );

    await docRef.set(todo.toFireStore());

    if (widget.onTaskAdded != null) widget.onTaskAdded!();
    if (mounted) Navigator.pop(context);
  }
}
