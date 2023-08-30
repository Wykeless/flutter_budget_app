import 'dart:async';

import 'package:budget_app/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

//* languages
final notiProvLanguages =
    NotifierProvider.autoDispose<LanguagesState, Map<int, Map<String, String>>>(
  () => LanguagesState(),
);

class LanguagesState
    extends AutoDisposeNotifier<Map<int, Map<String, String>>> {
  Map<int, Map<String, String>> _readLanguage() {
    return Constants.languages;
  }

  @override
  Map<int, Map<String, String>> build() {
    return _readLanguage();
  }
}

//* Add page type languages
final notiProvAddPageTypeLanguage =
    NotifierProvider.autoDispose<AddPageTypeState, Map<int, List<String>>>(
  () => AddPageTypeState(),
);

class AddPageTypeState extends AutoDisposeNotifier<Map<int, List<String>>> {
  Map<int, List<String>> _readLanguage() {
    return Constants.addPageType;
  }

  @override
  Map<int, List<String>> build() {
    return _readLanguage();
  }
}

//* Edit page type languages
final notiProvEditPageTypeLanguage =
    NotifierProvider.autoDispose<EditPageTypeState, Map<int, List<String>>>(
  () => EditPageTypeState(),
);

class EditPageTypeState extends AutoDisposeNotifier<Map<int, List<String>>> {
  Map<int, List<String>> _readLanguage() {
    return Constants.editPageType;
  }

  @override
  Map<int, List<String>> build() {
    return _readLanguage();
  }
}

//* Months
final notiProvMonths =
    NotifierProvider.autoDispose<MonthState, Map<int, Map<int, String>>>(
  () => MonthState(),
);

class MonthState extends AutoDisposeNotifier<Map<int, Map<int, String>>> {
  Map<int, Map<int, String>> _readMonths() {
    return Constants.months;
  }

  @override
  Map<int, Map<int, String>> build() {
    return _readMonths();
  }
}

//* Dropdown value
final notiProvLanguageDropDown =
    NotifierProvider.autoDispose<LanguageDropDownPrefState, List<String>>(
  () => LanguageDropDownPrefState(),
);

class LanguageDropDownPrefState extends AutoDisposeNotifier<List<String>> {
  List<String> _readLanguagePref() {
    return ['EN', 'SW'];
  }

  @override
  List<String> build() {
    return _readLanguagePref();
  }
}

//* Index for the drop down
final notiProvLanguageIndex =
    AsyncNotifierProvider.autoDispose<LanguagePrefState, int>(
  () => LanguagePrefState(),
);

class LanguagePrefState extends AutoDisposeAsyncNotifier<int> {
  Future<int> _readLanguageSetting() async {
    await Hive.openBox(Constants.appSettings);
    final box = Hive.box(Constants.appSettings);
    final perferredLanguageValue = box.get(Constants.appLanguage)!;
    return perferredLanguageValue;
  }

  @override
  FutureOr<int> build() {
    return _readLanguageSetting();
  }

  Future<void> setLanguagePref({required int preferredLanguageValue}) async {
    state = const AsyncValue.loading();

    final box = Hive.box(Constants.appSettings);
    state = await AsyncValue.guard(() {
      box.put(Constants.appLanguage, preferredLanguageValue);
      return _readLanguageSetting();
    });
  }
}

//* Whether the user wants a passcode or not
final notiProvPasswordSetting = AsyncNotifierProvider<PasswordPrefState, bool>(
  () => PasswordPrefState(),
);

class PasswordPrefState extends AsyncNotifier<bool> {
  Future<bool> _readPasswordSetting() async {
    await Hive.openBox(Constants.appSettings);
    final box = Hive.box(Constants.appSettings);
    final hasPasswordOnValue = box.get(Constants.appPassword)!;
    return hasPasswordOnValue;
  }

  @override
  FutureOr<bool> build() {
    return _readPasswordSetting();
  }

  Future<void> setPasswordSetting(bool hasPasswordOnValue) async {
    state = const AsyncValue.loading();

    final box = Hive.box(Constants.appSettings);
    state = await AsyncValue.guard(() {
      box.put(Constants.appPassword, hasPasswordOnValue);
      return _readPasswordSetting();
    });
  }
}

//* Whether the user wants a reminder or not
final notiProvReminderSetting =
    AsyncNotifierProvider<ReminderSettingState, bool>(
  () => ReminderSettingState(),
);

class ReminderSettingState extends AsyncNotifier<bool> {
  Future<bool> _readReminderSetting() async {
    await Hive.openBox(Constants.appSettings);
    final box = Hive.box(Constants.appSettings);
    final hasReminderValue = box.get(Constants.appReminder)!;
    return hasReminderValue;
  }

  @override
  FutureOr<bool> build() {
    return _readReminderSetting();
  }

  Future<void> setReminderSetting(bool hasReminderOnValue) async {
    state = const AsyncValue.loading();

    final box = Hive.box(Constants.appSettings);
    state = await AsyncValue.guard(() {
      box.put(Constants.appReminder, hasReminderOnValue);
      return _readReminderSetting();
    });
  }
}

//* retrieves whether the next budget has been created.
final notiProvIsNextBudgetCreated =
    AsyncNotifierProvider<IsNextBudgetCreatedState, bool>(
  () => IsNextBudgetCreatedState(),
);

class IsNextBudgetCreatedState extends AsyncNotifier<bool> {
  Future<bool> _readHasNewBudgetBeenCreatedValue() async {
    await Hive.openBox(Constants.appSettings);
    final box = Hive.box(Constants.appSettings);
    final beenCreatedvalue = box.get(Constants.hasNewBudgetBeenCreated)!;
    return beenCreatedvalue;
  }

  @override
  FutureOr<bool> build() {
    return _readHasNewBudgetBeenCreatedValue();
  }

  Future<void> setIsCreatedValue(bool hasBudgetBeenCreatedValue) async {
    state = const AsyncValue.loading();

    final box = Hive.box(Constants.appSettings);

    state = await AsyncValue.guard(() {
      box.put(Constants.hasNewBudgetBeenCreated, hasBudgetBeenCreatedValue);
      return _readHasNewBudgetBeenCreatedValue();
    });

    update((notifier) => _readHasNewBudgetBeenCreatedValue());
  }
}
