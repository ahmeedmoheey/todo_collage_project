import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_collage_project/core/utils/date_utils.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../data_base_manager/todo_dm.dart';

class TaskEdit extends StatefulWidget {
  final String? taskId;

  const TaskEdit({Key? key, this.taskId}) : super(key: key);

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _loadTaskData();
    }
  }

  void _loadTaskData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(TodoDM.collectionName)
        .doc(widget.taskId)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      TodoDM todo = TodoDM.fromFireStore(data);

      if (!mounted) return;

      setState(() {
        titleController.text = todo.title;
        descriptionController.text = todo.description;
        selectedDate = DateUtils.dateOnly(todo.dateTime);
        isDone = todo.isDone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ToDo List',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: ColorsManager.white,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: ColorsManager.blue,
                    height: 90.h,
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.all(29),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.taskId == null ? 'Add Task' : 'Edit Task',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: titleController,
                          validator: (input) {
                            if (input == null || input.trim().isEmpty) {
                              return 'Please enter task title';
                            }
                            return null;
                          },
                          decoration:
                          const InputDecoration(hintText: 'Enter task title'),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: descriptionController,
                          validator: (input) {
                            if (input == null || input.trim().isEmpty) {
                              return 'Please enter task description';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter task description'),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Select Date',
                          style: GoogleFonts.inter(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () => showTaskDate(context),
                          child: Text(
                            selectedDate.toFormattedDate,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFA9A9A9),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (widget.taskId == null) {
                              addTaskToFirestore();
                            } else {
                              updateTaskInFirestore(widget.taskId!);
                            }
                          },
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTaskDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        selectedDate = DateUtils.dateOnly(pickedDate);
      });
    }
  }

  void addTaskToFirestore() async {
    if (!formKey.currentState!.validate()) return;

    DocumentReference docRef =
    FirebaseFirestore.instance.collection(TodoDM.collectionName).doc();

    TodoDM todo = TodoDM(
      id: docRef.id,
      title: titleController.text,
      description: descriptionController.text,
      dateTime: selectedDate,
      isDone: false,
    );

    try {
      await docRef.set(todo.toFireStore());
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void updateTaskInFirestore(String taskId) async {
    if (!formKey.currentState!.validate()) return;

    try {
      await FirebaseFirestore.instance
          .collection(TodoDM.collectionName)
          .doc(taskId)
          .update({
        'title': titleController.text,
        'description': descriptionController.text,
        'dateTime': Timestamp.fromDate(selectedDate),
        'isDone': isDone,
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
