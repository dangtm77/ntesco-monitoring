import 'dart:math';

class StringHelper {
  static String toShortName(String val) {
    var value = val.trim();
    if (value != "" && value.length > 0) {
      var arr = value.trim().split(' ');
      if (arr.length <= 2)
        return value;
      else if (arr.length > 2)
        return arr[arr.length - 2] + ' ' + arr[arr.length - 1];
      else
        return value;
    } else
      return value;
  }

  static String autoGenCode(int lengthChar, int lengthNum, String char) {
    final charactersList = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numberList = '0123456789';
    final random = Random();
    var result = '';

    for (var i = 0; i < lengthChar; i++) {
      result += charactersList[random.nextInt(charactersList.length)];
    }
    if (char.length > 0) result += char;

    for (var i = 0; i < lengthNum; i++) {
      result += numberList[random.nextInt(numberList.length)];
    }

    return result;
  }
}
