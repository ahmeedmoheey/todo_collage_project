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
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName)
        .doc(widget.taskId)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      TodoDM todo = TodoDM.fromFireStore(data);

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
                          widget.taskId == null
                              ? AppLocalizations.of(context)!.addTask
                              : AppLocalizations.of(context)!.edit,
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
                              return AppLocalizations.of(context)!
                                  .plzEnterTaskTitle;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!
                                .enterTaskTitle,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: descriptionController,
                          validator: (input) {
                            if (input == null || input.trim().isEmpty) {
                              return AppLocalizations.of(context)!
                                  .plzEnterYourDescription;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!
                                .enterDescriptionTask,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          AppLocalizations.of(context)!.selectDate,
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
                          child:
                          Text(AppLocalizations.of(context)!.saveChanges),
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

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateUtils.dateOnly(pickedDate);
      });
    }
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
      dateTime: selectedDate,
      isDone: false,
    );

    documentReference
        .set(todo.toFireStore())
        .then((_) => Navigator.pop(context));
  }

  void updateTaskInFirestore(String taskId) async {
    if (!formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName)
        .doc(taskId)
        .update({
      'title': titleController.text,
      'description': descriptionController.text,
      'dateTime': Timestamp.fromDate(selectedDate),
      'isDone': isDone,
    });

    Navigator.pop(context);
  }
}
