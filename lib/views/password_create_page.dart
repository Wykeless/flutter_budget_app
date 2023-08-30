import 'dart:developer';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/password_notifier.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/models/password_model.dart';
import 'package:budget_app/views/screens.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/utils/password_manager.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PassCreatePage extends ConsumerStatefulWidget {
  const PassCreatePage({super.key});

  static const String pageKey = '/password_create';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePasscodePageState();
}

class _CreatePasscodePageState extends ConsumerState<PassCreatePage> {
  final TextEditingController passwordField = TextEditingController();
  final TextEditingController confirmPasswordField = TextEditingController();
  final TextEditingController emailField = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    passwordField.dispose();
    confirmPasswordField.dispose();
    emailField.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomAppBar customAppBar = CustomAppBar();
    CustomSnackbar customSnackbar = CustomSnackbar();
    PasswordManager passwordManager = PasswordManager();
    CustomButton customButton = CustomButton();

    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    var space = deviceHeight * 0.05;
    TextStyle textStyle = TextStyle(fontSize: deviceWidth * 0.040);
    TextStyle mainTextStyle = TextStyle(
      fontSize: deviceWidth * 0.07,
      fontWeight: FontWeight.bold,
    );

    var language = ref.watch(notiProvLanguages);
    var index = ref.watch(notiProvLanguageIndex);
    var isPasswordObscure = ref.watch(passwordObscureValueProvider);
    var isEmailObscure = ref.watch(emailObscureValueProvider);

    var indexValue = 0;

    index.when(
      data: (data) {
        indexValue = data;
      },
      loading: () {
        log('Loading');
      },
      error: (error, stackTrace) {
        log('Error: $error');
      },
    );

    //* IndexValue determines what language to show to the user.
    var createPassword = language[indexValue]![Constants.createPasswordText]!;
    var newPass = language[indexValue]![Constants.newPassText]!;
    var conPass = language[indexValue]![Constants.conPassText]!;
    var passMismatch = language[indexValue]![Constants.passMismatchText]!;
    var email = language[indexValue]![Constants.emailAddyText]!;
    var invalidEmail = language[indexValue]![Constants.invalidEmailText]!;
    var save = language[indexValue]![Constants.saveText]!;
    var emptyFields = language[indexValue]![Constants.emptyFieldsText]!;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppBar.showAppBar(
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    createPassword,
                    style: mainTextStyle,
                  ),
                ),
              ),
              SizedBox(
                height: space + 25,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text(
                        newPass,
                        style: textStyle,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        obscureText: isPasswordObscure,
                        controller: passwordField,
                        onChanged: (value) {
                          passwordField.text = value;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              ref
                                  .read(passwordObscureValueProvider.notifier)
                                  .state = !isPasswordObscure;
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: space,
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        conPass,
                        style: textStyle,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        obscureText: isPasswordObscure,
                        controller: confirmPasswordField,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              ref
                                  .read(passwordObscureValueProvider.notifier)
                                  .state = !isPasswordObscure;
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: space,
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        email,
                        style: textStyle,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        obscureText: isEmailObscure,
                        controller: emailField,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              isEmailObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              ref
                                  .read(emailObscureValueProvider.notifier)
                                  .state = !isEmailObscure;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: customButton.showButton(
                    width: double.infinity,
                    context: context,
                    text: save,
                    onPress: () async {
                      if (passwordField.text.trim().isEmpty ||
                          confirmPasswordField.text.trim().isEmpty ||
                          emailField.text.trim().isEmpty) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        customSnackbar.showSnackBar(
                          context,
                          emptyFields,
                          null,
                        );
                      } else {
                        if (EmailValidator.validate(
                            emailField.text.toLowerCase().trim())) {
                          if (passwordField.text.trim() ==
                              confirmPasswordField.text.trim()) {
                            final salt = passwordManager.generateSecureSalt(32);
                            final hashedPass = passwordManager.hashValue(
                                passwordField.text.trim(), salt);
                            final hashedEmail = passwordManager.hashValue(
                                emailField.text.toLowerCase().trim(), salt);

                            var newPassword = Password(
                              password: "$hashedPass",
                              email: "$hashedEmail",
                              salt: "$salt",
                            );

                            await ref
                                .read(asyncPasswordProvider.notifier)
                                .writeDataToPassword(
                                  dataToWrite: newPassword,
                                  fileName: Constants.filePassword,
                                );

                            ref
                                .read(notiProvPasswordSetting.notifier)
                                .setPasswordSetting(true);

                            //* Takes user to password screen to enter password
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil<void>(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const PassLoginPage()),
                                ModalRoute.withName(PassLoginPage.pageKey),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              customSnackbar.showSnackBar(
                                context,
                                passMismatch,
                                null,
                              );
                            }
                          }
                        } else {
                          FocusManager.instance.primaryFocus?.unfocus();
                          customSnackbar.showSnackBar(
                              context, invalidEmail, null);
                        }
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
