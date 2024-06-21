import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class _CupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _CupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'de';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GermanCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(_CupertinoLocalizationsDelegate old) => false;

  @override
  String toString() => 'DefaultCupertinoLocalizations.delegate(de_DE)';
}

/// US English strings for the cupertino widgets.
class GermanCupertinoLocalizations implements CupertinoLocalizations {
  /// Constructs an object that defines the cupertino widgets' localized strings
  /// for US English (only).
  ///
  /// [LocalizationsDelegate] implementations typically call the static [load]
  /// function, rather than constructing this class directly.
  const GermanCupertinoLocalizations();

  static const List<String> _shortWeekdays = <String>[
    'Mo',
    'Di',
    'Mi',
    'Do',
    'Fr',
    'Sa',
    'So',
  ];

  static const List<String> _shortMonths = <String>[
    'Jan',
    'Feb',
    'Mär',
    'Apr',
    'Mai',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Okt',
    'Nov',
    'Dez',
  ];

  static const List<String> _months = <String>[
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];

  @override
  String datePickerYear(int yearIndex) => yearIndex.toString();

  @override
  String datePickerMonth(int monthIndex) => _months[monthIndex - 1];

  @override
  String datePickerDayOfMonth(int dayIndex, [int? year]) => dayIndex.toString();

  @override
  String datePickerHour(int hour) => hour.toString();

  @override
  String datePickerHourSemanticsLabel(int hour) => hour.toString() + " Uhr";

  @override
  String datePickerMinute(int minute) => minute.toString().padLeft(2, '0');

  @override
  String datePickerMinuteSemanticsLabel(int minute) {
    if (minute == 1) return '1 Minute';
    return minute.toString() + ' Minuten';
  }

  @override
  String datePickerMediumDate(DateTime date) {
    return '${_shortWeekdays[date.weekday - DateTime.monday]} '
        '${_shortMonths[date.month - DateTime.january]} '
        '${date.day.toString().padRight(2)}';
  }

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.mdy;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get alertDialogLabel => 'Info';

  @override
  String timerPickerHour(int hour) => hour.toString();

  @override
  String timerPickerMinute(int minute) => minute.toString();

  @override
  String timerPickerSecond(int second) => second.toString();

  @override
  String timerPickerHourLabel(int hour) => hour == 1 ? 'Stunde' : 'Stunden';

  @override
  String timerPickerMinuteLabel(int minute) => 'Min';

  @override
  String timerPickerSecondLabel(int second) => 'Sek';

  @override
  String get cutButtonLabel => 'Ausschneiden';

  @override
  String get copyButtonLabel => 'Kopieren';

  @override
  String get pasteButtonLabel => 'Einfügen';

  @override
  String get selectAllButtonLabel => 'Alles auswählen';

  /// Creates an object that provides US English resource values for the
  /// cupertino library widgets.
  ///
  /// The [locale] parameter is ignored.
  ///
  /// This method is typically used to create a [LocalizationsDelegate].
  static Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(
        const GermanCupertinoLocalizations());
  }

  /// A [LocalizationsDelegate] that uses [DefaultCupertinoLocalizations.load]
  /// to create an instance of this class.
  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _CupertinoLocalizationsDelegate();

  @override
  String datePickerStandaloneMonth(int monthIndex) {
    // TODO: implement datePickerStandaloneMonth
    throw UnimplementedError();
  }

  @override
  // TODO: implement lookUpButtonLabel
  String get lookUpButtonLabel => throw UnimplementedError();

  @override
  // TODO: implement menuDismissLabel
  String get menuDismissLabel => throw UnimplementedError();

  @override
  // TODO: implement modalBarrierDismissLabel
  String get modalBarrierDismissLabel => throw UnimplementedError();

  @override
  // TODO: implement noSpellCheckReplacementsLabel
  String get noSpellCheckReplacementsLabel => throw UnimplementedError();

  @override
  // TODO: implement searchTextFieldPlaceholderLabel
  String get searchTextFieldPlaceholderLabel => throw UnimplementedError();

  @override
  // TODO: implement searchWebButtonLabel
  String get searchWebButtonLabel => throw UnimplementedError();

  @override
  // TODO: implement shareButtonLabel
  String get shareButtonLabel => throw UnimplementedError();

  @override
  String tabSemanticsLabel({required int tabIndex, required int tabCount}) {
    // TODO: implement tabSemanticsLabel
    throw UnimplementedError();
  }

  @override
  // TODO: implement timerPickerHourLabels
  List<String> get timerPickerHourLabels => throw UnimplementedError();

  @override
  // TODO: implement timerPickerMinuteLabels
  List<String> get timerPickerMinuteLabels => throw UnimplementedError();

  @override
  // TODO: implement timerPickerSecondLabels
  List<String> get timerPickerSecondLabels => throw UnimplementedError();

  @override
  // TODO: implement todayLabel
  String get todayLabel => throw UnimplementedError();
}
