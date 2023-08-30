import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/models/password_model.dart';
import 'package:budget_app/utils/file_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordObscureValueProvider = StateProvider<bool>((ref) => true);
final emailObscureValueProvider = StateProvider<bool>((ref) => true);

final FileManager fileManager = FileManager();

//*Provides a way to watch the data
final asyncPasswordProvider =
    AsyncNotifierProvider.autoDispose<PasswordNotifier, List<Password>>(
  () => PasswordNotifier(),
);

class PasswordNotifier extends AutoDisposeAsyncNotifier<List<Password>> {
  //* loads initial data if there is any
  Future<List<Password>> _readPasswordData() async {
    final passwordFileData =
        await fileManager.readDataFromPasswordFile(Constants.filePassword);

    return passwordFileData;
  }

  //* Uses the initial data to build the state
  @override
  Future<List<Password>> build() {
    return _readPasswordData();
  }

  //* add a new line of data
  Future<void> writeDataToPassword({
    required Password dataToWrite,
    required String fileName,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () {
        fileManager.writeDataToPasswordFile(
          passwordData: dataToWrite,
          fileName: fileName,
        );
        return _readPasswordData();
      },
    );
  }

  //* Deletes the budget from the device
  Future<void> deleteFile({
    required String fileName,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () {
        fileManager.deleteFile(fileName: fileName);
        return _readPasswordData();
      },
    );
  }
}
