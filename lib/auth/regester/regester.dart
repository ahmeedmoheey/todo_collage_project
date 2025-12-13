import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/colors_manager.dart';
import '../../core/utils/constant_manager.dart';
import '../../core/utils/email_validation.dart';
import '../../core/utils/images_manager.dart';
import '../../core/utils/my_text_style.dart';
import '../../core/utils/route_managers.dart';
import '../../core/utils/strings_manager.dart';
import '../../data_base_manager/user_DM.dart';
import '../../dialog/dialog.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/custom_text_fields.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController fullNameController;

  late TextEditingController userNameController;

  late TextEditingController emailController;

  late TextEditingController passwordController;

  late TextEditingController rePasswordController;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fullNameController = TextEditingController();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fullNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  ImagesManager.route,
                  width: 237.w,
                  height: 71.h,
                ),
                Text(
                  AppLocalizations.of(context)!.fullName,
                  style: MyTextStyle.title,
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomTextField(
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return AppLocalizations.of(context)!.fullName;
                    }
                    return null;
                  },
                  controller: fullNameController,
                  hintText: AppLocalizations.of(context)!.fullName,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  AppLocalizations.of(context)!.userName,
                  style: MyTextStyle.title,
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomTextField(
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return AppLocalizations.of(context)!.userName;
                    }
                    return null;
                  },
                  controller: userNameController,
                  hintText: AppLocalizations.of(context)!.userName,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  AppLocalizations.of(context)!.email,
                  style: MyTextStyle.title,
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomTextField(
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return AppLocalizations.of(context)!.plzEnterYourEmail;
                    }
                    if (!isValidEmail(input)) {
                      // email is not Valid
                      return AppLocalizations.of(context)!.emailBadFormat;
                    }
                    return null;
                  },
                  controller: emailController,
                  hintText: AppLocalizations.of(context)!.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  AppLocalizations.of(context)!.password,
                  style: MyTextStyle.title,
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomTextField(
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return AppLocalizations.of(context)!.password;
                    }
                    return null;
                  },
                  controller: passwordController,
                  hintText: AppLocalizations.of(context)!.password,
                  keyboardType: TextInputType.visiblePassword,
                  isSecureText: true,
                ), // password
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  AppLocalizations.of(context)!.passwordConfirmation,
                  style: MyTextStyle.title,
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomTextField(
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return AppLocalizations.of(context)!.passwordConfirmation;
                    }
                    if (input != passwordController.text) {
                      return AppLocalizations.of(context)!.passNotMatch;
                    }
                    return null;
                  },
                  controller: rePasswordController,
                  hintText: AppLocalizations.of(context)!.passwordConfirmation,
                  keyboardType: TextInputType.visiblePassword,
                  isSecureText: true,
                ),
                SizedBox(
                  height: 12.h,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r)),
                        padding: REdgeInsets.symmetric(vertical: 11)),
                    onPressed: () {
                      register();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.signUp,
                      style: MyTextStyle.buttonText,
                    )),
               const SizedBox(height: 10,),
                Container(

                  alignment: Alignment.center,
                  child: InkWell(
                    onTap:() {
                      Navigator.pop(context);
                      },
                    child: Text(AppLocalizations.of(context)!.alreadyHaveAnAccount,style:
                    GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,fontSize: 15,color: ColorsManager.white,
                        decoration: TextDecoration.underline
                    ),
                    ),
                  ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == false) return;

    try {
      // show Loading
      MyDialog.showLoading(context,
          loadingMessage: AppLocalizations.of(context)!.waiting, isDismissible: false);
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      addUserToFireStore(credential.user!.uid);
      //hide loading
      if (mounted) {
        MyDialog.hide(context);
      }
      // show success message
      if (mounted) {
        MyDialog.showMessage(context,
            body: AppLocalizations.of(context)!.userLoggedInSuccess,
            posActionTitle: AppLocalizations.of(context)!.ok, posAction: () {
              Navigator.pushReplacementNamed(context, RoutesManager.login);
            });
      }
    } on FirebaseAuthException catch (authError) {
      if (mounted) {
        MyDialog.hide(context);
      }
      late String message;
      if (authError.code == AppLocalizations.of(context)!.weakPassword) {
        message = AppLocalizations.of(context)!.weakPasswordMessage;
      } else if (authError.code == ConstantManager.emailInUse) {
        message = AppLocalizations.of(context)!.emailInUseMessage;
      }
      if (mounted) {
        MyDialog.showMessage(
          context,
          title: AppLocalizations.of(context)!.error,
          body: message,
          posActionTitle: AppLocalizations.of(context)!.ok,
        );
      }
    } catch (error) {
      if (mounted) {
        MyDialog.hide(context);
        MyDialog.showMessage(context,
            title: AppLocalizations.of(context)!.error,
            body: error.toString(),
            posActionTitle: AppLocalizations.of(context)!.tryAgain);
      }
    }
  }

  void addUserToFireStore(String uid) async {
    UserDM userDM = UserDM(
      id: uid,
      fullName: fullNameController.text,
      userName: userNameController.text,
      email: emailController.text,
    );
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection(UserDM.collectionName);
    DocumentReference userDocument = usersCollection.doc(uid);
    await userDocument.set(userDM.toFireStore());
  }


}
