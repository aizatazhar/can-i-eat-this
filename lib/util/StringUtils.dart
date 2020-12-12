class StringUtils {
  static String withoutFirstAndLastChars(String str) {
    return str.substring(1, str.length - 1);
  }

  static String formattedAsListView<T>(List<T> list) {
    StringBuffer stringBuffer = StringBuffer();
    for (T item in list) {
      stringBuffer.write(item.toString() + "\n");
    }
    // remove last \n
    return stringBuffer.toString()
        .substring(0, stringBuffer.toString().length - 1);
  }
}