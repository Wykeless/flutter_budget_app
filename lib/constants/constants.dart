class Constants {
  //* Language Keys
  static const String startText = "startText";
  static const String incomeText = "incomeText";
  static const String expenseText = "expenseText";
  static const String balanceText = "balanceText";
  static const String homeText = "homeText";
  static const String transactionText = "transactionText";
  static const String fileText = "fileText";
  static const String dateText = "dateText";
  static const String amountText = "amountText";
  static const String noteText = "noteText";
  static const String saveText = "saveText";
  static const String newPassText = "newPassText";
  static const String conPassText = "conPassText";
  static const String forgotPassText = "forgotPassText";
  static const String enterPassText = "enterPassText";
  static const String emailAddyText = "emailAddyText";
  static const String confirmText = "confirmText";
  static const String loginText = "loginText";
  static const String languageText = "languageText";
  static const String createPasswordText = "createPasswordText";
  static const String loginPasswordText = "loginPasswordText";
  static const String forgotPasswordText = "forgotPasswordText";
  static const String passText = "passText";
  static const String reminderText = "reminderText";
  static const String deleteText = "deleteText";
  static const String exitText = "exitText";
  static const String passMismatchText = "passMismatch";
  static const String emptyFieldsText = "emptyFields";
  static const String emailMismatchText = "emailMismatch";
  static const String getStartedHomeText = "getStartedHome";
  static const String getStartedTwoText = "getStartedTransaction";
  static const String noTransactionText = "noTransaction";
  static const String invalidEmailText = "validEmailText";
  static const String removedPassText = "removedPassText";
  static const String dialogConfirmText = "dialogConfirmText";
  static const String dialogDenyText = "dialogDenyText";
  static const String dialogFileDeleteText = "dialogFileDeleteText";
  static const String dialogTransDeleteText = "dialogDeleteText";
  static const String nextBudgetText = "nextBudgetText";
  static const String createdBudgetText = "createdBudgetText";
  static const String budgetFileDeletedText = "budgetFileDeletedText";
  static const String monthlyReminderText = "monthlyReminderText";
  static const String createBudgetReminderText = "createBudgetReminderText";
  static const String reminderOnText = "reminderOnText";
  static const String reminderOffText = "reminderOffText";

  //* Month Keys
  static const String january = "january";
  static const String february = "february";
  static const String march = "march";
  static const String april = "april";
  static const String may = "may";
  static const String june = "june";
  static const String july = "july";
  static const String august = "august";
  static const String september = "september";
  static const String october = "october";
  static const String november = "november";
  static const String december = "december";

  //* English language constants
  static const Map<String, String> enLanguage = {
    startText: "Start",
    incomeText: "Income",
    expenseText: "Expense",
    balanceText: "Balance",
    homeText: "Home",
    transactionText: "Transaction",
    fileText: "File",
    dateText: "Date:",
    amountText: "Amount:",
    noteText: "Note:",
    saveText: "Save",
    newPassText: "New Password:",
    conPassText: "Confirm Password:",
    forgotPassText: "Forgot Password?",
    enterPassText: "Enter Password:",
    emailAddyText: "Email Address:",
    confirmText: "Confirm",
    loginText: "Login",
    languageText: "Language:",
    passText: "Password:",
    reminderText: "Monthly reminder:",
    deleteText: "Delete",
    exitText: "Exit",
    createPasswordText: "Create Password",
    loginPasswordText: "Password Login",
    forgotPasswordText: "Forgot Password",
    passMismatchText: "Password do not match.",
    emptyFieldsText: "Empty Fields",
    emailMismatchText: "Email do not match.",
    getStartedHomeText: "Click one of the add buttons to get started.",
    getStartedTwoText: "Add transactions from the home tab.",
    noTransactionText: "No transactions for this budget.",
    invalidEmailText: "Please enter a valid email.",
    removedPassText: "Password removed.",
    dialogConfirmText: "Yes",
    dialogDenyText: "No",
    dialogFileDeleteText: "Do you want to delete the budget?",
    dialogTransDeleteText: "Do you want to delete the transaction?",
    nextBudgetText: "Create next month's budget",
    createdBudgetText: "Next month's budget has been created.",
    budgetFileDeletedText: "Budget File Deleted.",
    monthlyReminderText: "Monthly Reminder",
    createBudgetReminderText:
        "It's time to create your budget for the next month.",
    reminderOnText: "Reminder on",
    reminderOffText: "Reminder turned off",
  };

  static const Map<int, String> enMonths = {
    0: "January",
    1: "February",
    2: "March",
    3: "April",
    4: "May",
    5: "June",
    6: "July",
    7: "August",
    8: "September",
    9: "October",
    10: "November",
    11: "December",
  };

  //* Page types
  static const List<String> enAddPageTypes = [
    'Add Income',
    'Add Expense',
  ];
  static const List<String> enEditPageTypes = [
    'Edit Income',
    'Edit Expense',
  ];

//!-----------------------------------------------------------------------------------!\\

  //* Swahili language constants
  static const Map<String, String> swLanguage = {
    startText: "Anza",
    incomeText: "Mapato",
    expenseText: "Gharama",
    balanceText: "Salio",
    homeText: "Nyumbani",
    transactionText: "Hesabu",
    fileText: "Faili",
    dateText: "Tarehe:",
    amountText: "Kiasi:",
    noteText: "Maelezo:",
    saveText: "Hifadhi",
    newPassText: "Nambari Mpya ya Siri:",
    conPassText: "Thibitisha Nambari ya Siri:",
    forgotPassText: "Umesahau Nambari ya Siri?",
    enterPassText: "Ingiza Nambari ya Siri:",
    emailAddyText: "Anwani ya Barua pepe:",
    confirmText: "Thibitisha",
    loginText: "Ingia",
    languageText: "Lugha:",
    passText: "Nambari ya Siri:",
    reminderText: "Kumbusho la Mwezi:",
    deleteText: "Futa",
    exitText: "Toka",
    createPasswordText: "Tengeneza Nambari ya Siri",
    loginPasswordText: "Ingia kwa Nenosiri",
    forgotPasswordText: "Umesahau Nenosiri",
    passMismatchText: "Nambari ya Siri hazifanani.",
    emptyFieldsText: "Nyanja Zilizo Wazi",
    emailMismatchText: "Barua pepe hazifanani.",
    getStartedHomeText: "Bonyeza moja ya vifungo vya kuongeza ili kuanza.",
    getStartedTwoText: "Ongeza shughuli kutoka kwenye kichupo cha nyumbani.",
    noTransactionText: "Hakuna shughuli kwa bajeti hii.",
    invalidEmailText: "Tafadhali ingiza barua pepe halali.",
    removedPassText: "Imeondoa nambari ya siri.",
    dialogConfirmText: "Ndiyo",
    dialogDenyText: "Hapana",
    dialogFileDeleteText: "Unataka kufuta bajeti?",
    dialogTransDeleteText: "Unataka kufuta shughuli?",
    nextBudgetText: "Tengeneza bajeti ya mwezi ujao",
    createdBudgetText: "Bajeti ya mwezi ujao imeundwa.",
    budgetFileDeletedText: "Faili ya Bajeti Imefutwa.",
    monthlyReminderText: "Kumbusho la Kila Mwezi",
    createBudgetReminderText: "Ni wakati wa kuunda bajeti yako kwa mwezi ujao.",
    reminderOnText: "Kumbusho wazi",
    reminderOffText: "Kumbusho imezimwa",
  };

  //* Swahili months constants
  static const Map<int, String> swMonths = {
    0: "Januari",
    1: "Februari",
    2: "Machi",
    3: "Aprili",
    4: "Mei",
    5: "Juni",
    6: "Julai",
    7: "Agosti",
    8: "Septemba",
    9: "Oktoba",
    10: "Novemba",
    11: "Desemba",
  };

  //* Page types
  static const List<String> swAddPageTypes = [
    'Ongeza Mapato',
    'Ongeza Gharama',
  ];

  static const List<String> swEditPageTypes = [
    'Hariri Mapato',
    'Hariri Gharama',
  ];

//!-----------------------------------------------------------------------------------!\\

  //*Maps of constants
  static const Map<int, Map<String, String>> languages = {
    0: enLanguage,
    1: swLanguage,
  };

  static final Map<int, Map<int, String>> months = {
    0: enMonths,
    1: swMonths,
  };

  static final Map<int, List<String>> addPageType = {
    0: enAddPageTypes,
    1: swAddPageTypes,
  };
  static final Map<int, List<String>> editPageType = {
    0: enEditPageTypes,
    1: swEditPageTypes,
  };

//!-----------------------------------------------------------------------------------!\\

  //* Key Constants used through out the app
  static const String keyCurrency = 'KSh';
  static const String keySeparator = '||';

  //* Transaction type key constant
  static const List<String> transactionType = [
    'Income',
    'Expense',
  ];

  //* Budget filename and data map keys
  static const String fileBudgetManager = 'BudgetManager.txt';
  static const String filePassword = 'Password.txt';

  //* App settings constants
  static const String appSettings = 'appSettings';
  static const String appReminder = 'hasReminderOn';
  static const String appPassword = 'hasPasswordOn';
  static const String appShowStart = 'hasSeenStart';
  static const String appLanguage = 'preferredLanguage';

  //* key constant for checking if nexts months budgets
  static const String hasNewBudgetBeenCreated = 'hasNewBudgetBeenCreated';

  //* Password key constants
  static const String passName = 'passwordKeeper';

//!-----------------------------------------------------------------------------------!\\

/* date formats values and its returns

  'yyyy': Year with 4 digits.
  'MM': Month with 2 digits.
  'dd': Day of the month with 2 digits.
  'EEE': Abbreviated day of the week.
  'MMMM': Full month name.
  'hh': Hour (12-hour clock) with 2 digits.
  'mm': Minutes with 2 digits.
  'ss': Seconds with 2 digits.

  Example:
  'dd-MMMM-yyyy' = 1-January-2023 

*/
//!-----------------------------------------------------------------------------------!\\
}
