import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_collage_project/core/utils/date_utils.dart';
import '../../../core/utils/my_text_style.dart';
import '../../../data_base_manager/todo_dm.dart';
import '../../../data_base_manager/user_DM.dart';

import '../../../l10n/app_localizations.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
  static Future show(context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: AddTaskBottomSheet(),
          );
        });
  }
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {

  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  List<int> arr = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height * .5,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.addNewTask ,
              textAlign: TextAlign.center,
              style: MyTextStyle.bottomSheetTitle,
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              validator: (input) {
                if (input == null || input.trim().isEmpty) {
                  return AppLocalizations.of(context)!.plzEnterTaskTitle;
                }
                return null;
              },
              controller: titleController,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterTaskTitle,
                  hintStyle: MyTextStyle.hint),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              validator: (input) {
                if (input == null || input.trim().isEmpty) {
                  return AppLocalizations.of(context)!.plzEnterYourDescription;
                }
                if (input.length < 6) {
                  return AppLocalizations.of(context)!.sorryDescription;
                }
                return null;
              },
              controller: descriptionController,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterDescriptionTask,
                  hintStyle: MyTextStyle.hint),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context)!.selectDate,
              style: MyTextStyle.date,
            ),
            InkWell(
                onTap: () {
                  showTaskDate(context);
                },
                child: Text(
                  selectedDate.toFormattedDate,
                  textAlign: TextAlign.center,
                  style: MyTextStyle.hint,
                )),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  addTaskToFireStore();
                },
                child:  Text(AppLocalizations.of(context)!.addTask,style: TextStyle(
                    color: Colors.white
                ),))
          ],
        ),
      ),
    );
  }

  void showTaskDate(context) async {
    selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(
        days: 365,
      )),
    ) ??
        selectedDate;

    setState(() {});
  }

  void addTaskToFireStore() {
    // form is valid
    if (formKey.currentState!.validate() == false) return;
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection(UserDM.collectionName);
    CollectionReference todoCollection = usersCollection
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName);
    DocumentReference documentReference = todoCollection.doc(); // auto id

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
        isDone: false);
    documentReference
        .set(todo.toFireStore())
        .then(
          (_) {
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    )
        .onError(
          (error, stackTrace) {},
    )
        .timeout(
      const Duration(seconds: 4),
      onTimeout: () {
        print(AppLocalizations.of(context)!.enterTimeOut);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }
}