import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_collage_project/core/utils/date_utils.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../data_base_manager/todo_dm.dart';
import '../../../../data_base_manager/user_DM.dart';
import '../../../../l10n/app_localizations.dart';

class TaskEdit extends StatefulWidget {
  final String? taskId;

  const TaskEdit({
    Key? key,
    this.taskId,
  }) : super(key: key);

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _loadTaskData();
    }
  }

  void _loadTaskData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName)
        .doc(widget.taskId)
        .get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
      TodoDM todo = TodoDM.fromFireStore(data);
      setState(() {
        titleController.text = todo.title;
        descriptionController.text = todo.description;
        selectedDate = todo.dateTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.todoList,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: ColorsManager.white,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: ColorsManager.blue,
                  height: 90.h,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(25),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.all(29),
                  width: 352,
                  height: 617,
                  child: Column(
                    children: [
                      Text(
                        widget.taskId == null ? AppLocalizations.of(context)!.addTask : AppLocalizations.of(context)!.edit,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextFormField(
                        controller: titleController,
                        validator: (input) {
                          if (input == null || input.trim().isEmpty) {
                            return AppLocalizations.of(context)!.plzEnterTaskTitle;
                          }
                          if (input.length < 4) {
                            return 'Title should be at least 4 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterTaskTitle,
                          hintStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: descriptionController,
                        validator: (input) {
                          if (input == null || input.trim().isEmpty) {
                            return AppLocalizations.of(context)!.plzEnterYourDescription;
                          }
                          if (input.length < 6) {
                            return AppLocalizations.of(context)!.sorryDescription;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterDescriptionTask,
                          hintStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        AppLocalizations.of(context)!.selectDate,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: const Color(0XFF383838),
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          showTaskDate(context);
                        },
                        child: Text(
                          selectedDate.toFormattedDate,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFA9A9A99C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (widget.taskId == null) {
                            addTaskToFirestore();
                          } else {
                            updateTaskInFirestore(widget.taskId!);
                            ();
                          }
                        },
                        child:  Text(AppLocalizations.of(context)!.saveChanges),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showTaskDate(BuildContext context) async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ) ??
        selectedDate;
  }

  void addTaskToFirestore() {
    if (!formKey.currentState!.validate()) return;

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName)
        .doc();

    TodoDM todo = TodoDM(
      id: documentReference.id,
      title: titleController.text,
      description: descriptionController.text,
      dateTime: selectedDate.copyWith(
        second: 0,
        millisecond: 0,
        minute: 0,
        microsecond: 0,
        hour: 0,
      ),
      isDone: false,
    );

    documentReference
        .set(todo.toFireStore())
        .then((_) => Navigator.pop(context))
        .catchError((error) => print('Failed to add task: $error'));
  }

  void updateTaskInFirestore(String taskId) {
    if (!formKey.currentState!.validate()) return;

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName)
        .doc(taskId);

    TodoDM todo = TodoDM(
      id: taskId,
      title: titleController.text,
      description: descriptionController.text,
      dateTime: selectedDate.copyWith(
        second: 0,
        millisecond: 0,
        minute: 0,
        microsecond: 0,
        hour: 0,
      ),
      isDone: false,
    );

    documentReference
        .update(todo.toFireStore())
        .then((_) => Navigator.pop(context))
        .catchError((error) => print('Failed to update task: $error'));
  }
}
