import 'dart:developer';

import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/views/screens.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/utils/notification_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const String pageKey = '/settings_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NotificationManager notiManager = NotificationManager();
    CustomAppBar customAppBar = CustomAppBar();
    CustomSnackbar customSnackbar = CustomSnackbar();
    CustomButton customButton = CustomButton();

    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;
    var iconSize = deviceWidth * 0.08;

    TextStyle textStyle = TextStyle(fontSize: deviceWidth * 0.040);
    TextStyle dropDownTextStyle = TextStyle(
      color: Colors.black,
      fontSize: deviceWidth * 0.040,
    );

    var languages = ref.watch(notiProvLanguages);
    var index = ref.watch(notiProvLanguageIndex);
    var dropdown = ref.watch(notiProvLanguageDropDown);
    var password = ref.watch(notiProvPasswordSetting);
    var reminder = ref.watch(notiProvReminderSetting);

    var indexValue = 0;
    var passwordValue = false;
    var reminderValue = false;

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

    password.when(
      data: (passwordSettingValue) {
        passwordValue = passwordSettingValue;
      },
      loading: () {
        log('Loading');
      },
      error: (error, stackTrace) {
        log('Error: $error');
      },
    );

    reminder.when(
      data: (reminderSettingValue) {
        reminderValue = reminderSettingValue;
      },
      loading: () {
        log('Loading');
      },
      error: (error, stackTrace) {
        log('Error: $error');
      },
    );

    String language = languages[indexValue]![Constants.languageText]!;
    String removedPassText = languages[indexValue]![Constants.removedPassText]!;
    String passwordText = languages[indexValue]![Constants.passText]!;
    String reminderText = languages[indexValue]![Constants.reminderText]!;
    String exitText = languages[indexValue]![Constants.exitText]!;
    String monthlyReminderText =
        languages[indexValue]![Constants.monthlyReminderText]!;
    String createBudgetReminderText =
        languages[indexValue]![Constants.createBudgetReminderText]!;
    String reminderOnText = languages[indexValue]![Constants.reminderOnText]!;
    String reminderOffText = languages[indexValue]![Constants.reminderOffText]!;

    return Scaffold(
      appBar: customAppBar.showAppBar(
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_sharp),
          iconSize: iconSize,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 50,
            ),
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          language,
                          style: textStyle,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DropdownButton<String>(
                          alignment: Alignment.center,
                          isExpanded: true,
                          value: dropdown[indexValue],
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: dropDownTextStyle,
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (String? value) {
                            //* This is called when the user selects an item.
                            if (value == 'EN') {
                              ref
                                  .read(notiProvLanguageIndex.notifier)
                                  .setLanguagePref(preferredLanguageValue: 0);
                            } else {
                              ref
                                  .read(notiProvLanguageIndex.notifier)
                                  .setLanguagePref(preferredLanguageValue: 1);
                            }
                          },
                          items: dropdown.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        passwordText,
                        style: textStyle,
                      ),
                      Switch(
                        activeColor: Colors.black,
                        activeTrackColor: const Color(0xff33b6e7),
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.grey.shade400,
                        splashRadius: 20.0,
                        value: passwordValue,
                        onChanged: (value) async {
                          if (value == true) {
                            if (context.mounted) {
                              Navigator.of(context).pushNamed(
                                PassCreatePage.pageKey,
                              );
                            }
                          }

                          if (value == false) {
                            ref
                                .read(notiProvPasswordSetting.notifier)
                                .setPasswordSetting(value);
                            await Hive.openBox(Constants.passName);
                            Hive.box(Constants.passName)
                                .delete(Constants.passName);
                            if (context.mounted) {
                              customSnackbar.showSnackBar(
                                  context, removedPassText, 800);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reminderText,
                        style: textStyle,
                      ),
                      Switch(
                        activeColor: Colors.black,
                        activeTrackColor: const Color(0xff33b6e7),
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.grey.shade400,
                        splashRadius: 20.0,
                        value: reminderValue,
                        onChanged: (value) async {
                          if (value == true) {
                            final androidInfo =
                                await DeviceInfoPlugin().androidInfo;
                            var allAccepted = false;

                            if (androidInfo.version.sdkInt > 32) {
                              final Map<Permission, PermissionStatus>
                                  permsStatus =
                                  await [Permission.notification].request();

                              permsStatus.forEach(
                                (permission, status) {
                                  if (status == PermissionStatus.granted) {
                                    allAccepted = true;
                                  }
                                },
                              );

                              if (await Permission.notification.isDenied) {
                                openAppSettings();
                              }
                            } else {
                              allAccepted = true;
                            }

                            if (allAccepted) {
                              allAccepted = false;
                              ref
                                  .read(notiProvReminderSetting.notifier)
                                  .setReminderSetting(value);

                              await notiManager.scheduleReminderNotification(
                                title: monthlyReminderText,
                                body: createBudgetReminderText,
                              );
                              if (context.mounted) {
                                customSnackbar.showSnackBar(
                                    context, reminderOnText, 1000);
                              }
                            }
                          }
                          if (value == false) {
                            ref
                                .read(notiProvReminderSetting.notifier)
                                .setReminderSetting(value);
                            await notiManager.cancelScheduledNotification();
                            if (context.mounted) {
                              customSnackbar.showSnackBar(
                                  context, reminderOffText, 1000);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: customButton.showButton(
                  context: context,
                  text: exitText,
                  onPress: () {
                    SystemNavigator.pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
