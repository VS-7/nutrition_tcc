class DateFormatter {
  DateFormatter();

  String getMonthName(int monthNumber) {
    List<String> monthNames = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return monthNames[monthNumber - 1];
  }

  String formatDate(DateTime dateTime) {
    int day = dateTime.day;
    int month = dateTime.month;
    int year = dateTime.year;

    return '${getMonthName(month)} ${day.toString()}, ${year.toString()}';
  }

  String formatTime(DateTime dateTime) {
    return dateTime.toString().substring(11, 16);
  }
}
