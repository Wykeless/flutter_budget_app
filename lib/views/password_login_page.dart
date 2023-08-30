import 'dart:developer';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/password_notifier.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/views/password_forgot_page.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/utils/password_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PassLoginPage extends ConsumerStatefulWidget {
  const PassLoginPage({super.key});

  static const String pageKey = '/password_login';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PassLoginPageState();
}

class _PassLoginPageState extends ConsumerState<PassLoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final CustomSnackbar _customSnackbar = CustomSnackbar();
  final PasswordManager _passwordManager = PasswordManager();
  final CustomButton _customButton = CustomButton();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    var isObscure = ref.watch(passwordObscureValueProvider);
    var password = ref.watch(asyncPasswordProvider);
    var indexValue = 0;

    String storedhashValue = '';
    String storedSalt = '';

    password.when(
      data: (passwordData) {
        if (passwordData.isNotEmpty) {
          storedhashValue = passwordData[0].password;
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
    var passwordLogin = language[indexValue]![Constants.loginPasswordText]!;
    var login = language[indexValue]![Constants.loginText]!;
    var forgotPass = language[indexValue]![Constants.forgotPassText]!;
    var enterPass = language[indexValue]![Constants.enterPassText]!;
    var emptyFields = language[indexValue]![Constants.emptyFieldsText]!;
    var passMismatch = language[indexValue]![Constants.passMismatchText]!;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                flex: 1,
                child: Text(''),
              ),
              Expanded(
                flex: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    passwordLogin,
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
                      enterPass,
                      style: textStyle,
                    ),
                    TextFormField(
                      obscureText: isObscure,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            ref
                                .read(passwordObscureValueProvider.notifier)
                                .state = !isObscure;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                          forgotPass,
                          style: textStyle,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(PassForgotPage.pageKey);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _customButton.showButton(
                    width: double.infinity,
                    context: context,
                    text: login,
                    onPress: () async {
                      if (_passwordController.text.trim().isEmpty) {
                        _customSnackbar.showSnackBar(
                            context, emptyFields, null);
                      } else {
                        var isMatch = _passwordManager.isValueMatching(
                          givenHashValue: _passwordController.text.trim(),
                          storedHashValue: storedhashValue,
                          hashSalt: storedSalt,
                        );
                        if (isMatch) {
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (Route<dynamic> route) => false,
                            );
                          }
                        } else {
                          if (context.mounted) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _customSnackbar.showSnackBar(
                                context, passMismatch, null);
                          }
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
