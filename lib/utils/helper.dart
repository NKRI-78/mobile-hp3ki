import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/date_symbol_data_local.dart';

class Helper {
  
  static String formatCurrency(int number, {bool useSymbol = true}) {
    final NumberFormat fmt = NumberFormat.currency(locale: 'id', symbol: useSymbol ? 'Rp ' : '');
    String s = fmt.format(number);
    String format = s.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return format;
  }

  static String gramsToKilograms(double grams) {
    return "${grams / 1000} Kg";
  }

  static String censorName(String name) {
    if (name.length <= 2) {
      return name;
    }

    String start = name.substring(0, 2);
    String end = name.substring(name.length - 1);
    
    String censoredPart = '*' * (name.length - 3);

    return start + censoredPart + end;
  }
  
  static String getFormatedDate(_date) {
    var inputFormat = DateFormat('yyyy/MM/dd');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('yyyy-MM-dd');
    return outputFormat.format(inputDate);
  }

  static String getFormatedDateTwo(_date) {
    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('yyyy-MM-dd');
    return outputFormat.format(inputDate);
  }
  
  static String formatDate(DateTime dateTime) {
    initializeDateFormatting("id");
    // return DateFormat.yMMMMEEEEd("id").format(dateTime);
    // return DateFormat('dd-MM-yyyy').format(dateTime);
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String formatDateWithTime(DateTime dateTime) {
    initializeDateFormatting("id");
    
    return DateFormat('dd MMMM yyyy hh:mm').format(dateTime);
  }

  static createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static createUniqueV4Id() {
    var id = const Uuid();
    return id.v4();
  }

  static Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
  
  static Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse('0x$alphaChannel$hexString'));
  }

  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

}