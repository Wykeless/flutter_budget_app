import 'dart:developer';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/password_notifier.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/views/screens.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/utils/password_manager.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PassForgotPage extends ConsumerStatefulWidget {
  const PassForgotPage({super.key});

  static const String pageKey = '/password_forgot';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PassForgotPageState();
}

class _PassForgotPageState extends ConsumerState<PassForgotPage> {
  final TextEditingController _emailController = TextEditingController();
  final CustomAppBar _customAppBar = CustomAppBar();
  final CustomSnackbar _customSnackbar = CustomSnackbar();
  final PasswordManager _passwordManager = PasswordManager();
  final CustomButton _customButton = CustomButton();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //* Gets the devices screen width and returns it
    double deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    var space = deviceHeight * 0.05;

    TextStyle textStyle = TextStyle(fontSize: deviceWidth * 0.040);

    TextStyle mainTextStyle = TextStyle(
      fontSize: deviceWidth * 0.07,
      fontWeight: FontWeight.bold,
    );

    var language = ref.watch(notiProvLanguages);
    var index = ref.watch(notiProvLanguageIndex);
    var isObscure = ref.watch(emailObscureValueProvider);
    var password = ref.watch(asyncPasswordProvider);
    int indexValue = 0;

    String storedhashedEmail = '';
    String storedSalt = '';

    password.when(
      data: (passwordData) {
        if (passwordData.isNotEmpty) {
          storedhashedEmail = passwordData[0].email;
          storedSalt = passwordData[0].salt;
        }
      },
      loading: () => const Text('Loading'),
      error: (error, stackTrace) => Text('error: $error'),
    );

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
    String forgotPassword =
        language[indexValue]![Constants.forgotPasswordText]!;
    String email = language[indexValue]![Constants.emailAddyText]!;
    String confirm = language[indexValue]![Constants.confirmText]!;
    String emptyFields = language[indexValue]![Constants.emptyFieldsText]!;
    String emailMismatch = language[indexValue]![Constants.emailMismatchText]!;
    String invalidEmail = language[indexValue]![Constants.invalidEmailText]!;
    String removedPass = language[indexValue]![Constants.removedPassText]!;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _customAppBar.showAppBar(
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
                    forgotPassword,
                    style: mainTextStyle,
                  ),
                ),
              ),
              SizedBox(
                height: space + 25,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      email,
                      style: textStyle,
                    ),
                    TextFormField(
                      obscureText: isObscure,
                      controller: _emailController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            ref.read(emailObscureValueProvider.notifier).state =
                                !isObscure;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: _customButton.showButton(
                    width: double.infinity,
                    context: context,
                    text: confirm,
                    onPress: () async {
                      if (_emailController.text.isEmpty) {
                        _customSnackbar.showSnackBar(
                            context, emptyFields, null);
                      } else {
                        if (EmailValidator.validate(
                            _emailController.text.toLowerCase().trim())) {
                          var isMatch = _passwordManager.isValueMatching(
                            givenHashValue:
                                _emailController.text.toLowerCase().trim(),
                            storedHashValue: storedhashedEmail,
                            hashSalt: storedSalt,
                          );

                          if (isMatch) {
                            if (context.mounted) {
                              await ref
                                  .read(notiProvPasswordSetting.notifier)
                                  .setPasswordSetting(false);

                              await ref
                                  .read(asyncPasswordProvider.notifier)
                                  .deleteFile(fileName: Constants.filePassword);
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const HomePage()),
                                  ModalRoute.withName(HomePage.pageKey),
                                );
                                _customSnackbar.showSnackBar(
                                    context, removedPass, null);
                              }
                            }
                          } else {
                            if (context.mounted) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _customSnackbar.showSnackBar(
                                  context, emailMismatch, null);
                            }
                          }
                        } else {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _customSnackbar.showSnackBar(
                              context, invalidEmail, null);
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
