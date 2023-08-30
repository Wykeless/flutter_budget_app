import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/password_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  //* Methods for interacting with the files stored on the device

  Future<void> writeDataToBudgetManagerFile({
    required Budget budgetData,
    required String fileName,
  }) async {
    try {
      final io.Directory directory = await getApplicationDocumentsDirectory();
      final String fullPath = '${directory.path}/$fileName';
      final io.File file = io.File(fullPath);
      String data = '';

      //* Formats data to be written to file.
      data =
          "${budgetData.year} ${Constants.keySeparator} ${budgetData.month} ${Constants.keySeparator} ${budgetData.budgetName}\n";

      var isExist = await file.exists();

      if (isExist) {
        await file.writeAsString(data, mode: io.FileMode.append);
        log("Saved successfully: \n$data", name: 'Budget Manager File');
      } else {
        await file.writeAsString(data);
        log("Saved successfully: \n$data", name: 'Budget Manager File');
      }
    } on Exception catch (e) {
      log("Couldn't write to file: $e", name: 'Budget Manager File');
    }
  }

  //* Reads from the main budget file
  Future<List<Budget>> readDataFromBudgetManagerFile(String filename) async {
    late String text;
    List<Budget> mainBudgetFileData = [];

    try {
      final io.Directory directory = await getApplicationDocumentsDirectory();
      final String fullPath = '${directory.path}/$filename';
      final io.File file = io.File(fullPath);

      file.readAsLinesSync().forEach((line) {
        // Split the line using the defined separator
        List<String> data = line.split(Constants.keySeparator);

        mainBudgetFileData.add(
          Budget(
            year: data[0].trim(),
            month: data[1].trim(),
            budgetName: data[2].trim(),
          ),
        );
      });

      text = await file.readAsString();
      log("Read from main Budget File successfully: \n$text",
          name: 'Budget Manager File');
    } catch (e) {
      text = '';
      log("Couldn't read file: $e", name: 'Budget Manager File');
    }
    return mainBudgetFileData;
  }

  Future<void> writeDataToTxnsFile({
    required Transaction txnData,
    required String fileName,
  }) async {
    try {
      final io.Directory directory = await getApplicationDocumentsDirectory();
      final String fullPath = '${directory.path}/$fileName';
      final io.File file = io.File(fullPath);
      String data =
          "${txnData.transactionType} ${Constants.keySeparator} ${txnData.date} ${Constants.keySeparator} ${txnData.amount} ${Constants.keySeparator} ${txnData.note}\n";

      var isExist = await file.exists();

      if (isExist) {
        await file.writeAsString(data, mode: io.FileMode.append);
        log("Saved successfully: \n$data", name: 'Transaction write');
      } else {
        await file.writeAsString(data);
        log("Saved successfully: \n$data", name: 'Transaction write');
      }
    } on Exception catch (e) {
      log("$e", name: 'Transaction write');
    }
  }

  //* read from a budget file
  Future<List<Transaction>> readDataFromTxnsFile(String fileName) async {
    late String text;
    List<Transaction> transactionFileData = [];

    try {
      final io.Directory directory = await getApplicationDocumentsDirectory();
      final String fullPath = '${directory.path}/$fileName';
      final io.File file = io.File(fullPath);

      file.readAsLinesSync().forEach(
        (line) {
          // Split the line using the "||" separator
          List<String> data = line.split(Constants.keySeparator);

          transactionFileData.add(
            Transaction(
              transactionType: data[0].trim(),
              date: data[1].trim(),
              amount: double.parse(data[2].trim()),
              note: data[3].trim(),
            ),
          );
        },
      );

      text = await file.readAsString();
      log(
        "Read from transaction file: \n$text",
        name: 'Transaction read',
      );
    } catch (e) {
      log("Error: $e", name: 'Transaction read');
    }
    return transactionFileData;
  }

  Future<void> writeDataToPasswordFile({
    required Password passwordData,
    required String fileName,
  }) async {
    try {
      final io.Directory directory = await getApplicationDocumentsDirectory();
      final String fullPath = '${directory.path}/$fileName';
      final io.File file = io.File(fullPath);
      String data =
          "${passwordData.password} ${Constants.keySeparator} ${passwordData.email} ${Constants.keySeparator} ${passwordData.salt}\n";

      await file.writeAsString(data);
      log("Saved successfully: \n$data", name: 'Password write');
    } on Exception catch (e) {
      log("$e", name: 'Password write');
    }
  }

  //* read from the password file
  Future<List<Password>> readDataFromPasswordFile(String fileName) async {
    late String text;
    List<Password> passwordFileData = [];

    try {
      final io.Directory directory = await getApplicationDocumentsDirectory();
      final String fullPath = '${directory.path}/$fileName';
      final io.File file = io.File(fullPath);

      file.readAsLinesSync().forEach(
        (line) {
          // Split the line using the "||" separator
          List<String> data = line.split(Constants.keySeparator);

          passwordFileData.add(
            Password(
              password: data[0].trim(),
              email: data[1].trim(),
              salt: data[2].trim(),
            ),
          );
        },
      );

      text = await file.readAsString();
      log(
        "Read from Password file: \n$text",
        name: 'Password read',
      );
    } catch (e) {
      log("Error: $e", name: 'Password read');
    }
    return passwordFileData;
  }

  //* Editing an existing line in the file
  void editLineInFile({
    required String fileName,
    required int lineNumber,
    required Transaction newData,
  }) async {
    final io.Directory directory = await getApplicationDocumentsDirectory();
    final String fullPath = '${directory.path}/$fileName';
    final io.File file = io.File(fullPath);
    final lines = file.readAsLinesSync();

    // Make sure the line number is valid
    if (lineNumber >= 0 && lineNumber < lines.length) {
      String data =
          "${newData.transactionType} ${Constants.keySeparator} ${newData.date} ${Constants.keySeparator} ${newData.amount} ${Constants.keySeparator} ${newData.note}";
      lines[lineNumber] = data;
      file.writeAsStringSync(lines.join('\n'));
      file.writeAsStringSync('\n', mode: io.FileMode.append);
      var text = await file.readAsString();
      log("Read successfully: \n$text", name: 'File Manager');
    } else {
      log('Invalid line number', name: 'File Manager');
    }
  }

  //* Delete a specific line from textfile
  Future<void> deleteLineFromFile({
    required String fileName,
    required int lineNumber,
  }) async {
    final io.Directory directory = await getApplicationDocumentsDirectory();
    final String fullPath = '${directory.path}/$fileName';
    final io.File file = io.File(fullPath);

    try {
      List<String> textfileData = await file.readAsLines();

      if (lineNumber >= 0 && lineNumber < textfileData.length) {
        textfileData.removeAt(lineNumber);

        String newContent = textfileData.join('\n');

        await file.writeAsString(newContent);
        file.writeAsStringSync('\n', mode: io.FileMode.append);

        log('Line at index $lineNumber removed successfully.',
            name: 'File Manager');
      } else {
        log('Line index is out of range.', name: 'File Manager');
      }
    } catch (e) {
      log('Error removing line: $e');
    }
  }

  //* Deleting an existing file
  Future<void> deleteFile({required fileName}) async {
    final io.Directory directory = await getApplicationDocumentsDirectory();
    final String fullPath = '${directory.path}/$fileName';
    final io.File file = io.File(fullPath);
    try {
      await file.delete();
      log('File was deleted successfully.', name: 'File Manager');
    } catch (e) {
      log('Failed to delete the file.', name: 'File Manager');
      log("reason: ${e.toString()}", name: 'File Manager');
    }
  }
}
