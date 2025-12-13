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
import '../regester/regester.dart';
import '../widgets/custom_text_fields.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController;

  late TextEditingController passwordController;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
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
                      return AppLocalizations.of(context)!.plzEnterYourEmail;
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
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r)),
                        padding: REdgeInsets.symmetric(vertical: 11)),
                    onPressed: () {
                      login();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.signIn,
                      style: MyTextStyle.buttonText,
                    )),
                 const SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => const Register()));                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(AppLocalizations.of(context)!.notHaveAcc,style: GoogleFonts.poppins(
                      fontSize:15 ,
                      fontWeight:FontWeight.w500 ,
                      decoration: TextDecoration.underline,
                      color: ColorsManager.white,

                    ),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    if (formKey.currentState?.validate() == false) return;

    try {
      // show Loading
      MyDialog.showLoading(context,
          loadingMessage: AppLocalizations.of(context)!.waiting, isDismissible: false);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      UserDM.currentUser = await readUserFromFireStore(credential.user!.uid);

      //hide loading
      if (mounted) {
        MyDialog.hide(context);
      }
      // show success message
      if (mounted) {
        MyDialog.showMessage(context,
            body: AppLocalizations.of(context)!.userLoggedInSuccess,
            posActionTitle: AppLocalizations.of(context)!.ok, posAction: () {
              Navigator.pushReplacementNamed(
                context,
                RoutesManager.home,
              );
            });
      }
    } on FirebaseAuthException catch (authError) {
      if (mounted) {
        MyDialog.hide(context);
      }

      String message = AppLocalizations.of(context)!.anErrorPlzTryAgain;

      if (authError.code == AppLocalizations.of(context)!.invalidCredential) {
        message = AppLocalizations.of(context)!.wrongEmailOrPasswordMessage;
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
            posActionTitle:AppLocalizations.of(context)!.tryAgain);
      }
    }
  }


  Future<UserDM> readUserFromFireStore(String uid) async {
    final users = FirebaseFirestore.instance.collection(UserDM.collectionName);
    final doc = await users.doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      final newUser = UserDM(
        id: uid,
        fullName: '',
        userName: '',
        email: FirebaseAuth.instance.currentUser?.email ?? '',
      );

      await users.doc(uid).set(newUser.toFireStore());
      return newUser;
    }

    return UserDM.fromFireStore(doc.data()!);
  }
}