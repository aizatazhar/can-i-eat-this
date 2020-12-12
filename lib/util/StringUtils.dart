class StringUtils {
  static String withoutFirstAndLastChars(String str) {
    return str == "" ? "" : str.substring(1, str.length - 1);
  }

  static String formattedAsListView<T>(List<T> list) {
    StringBuffer stringBuffer = StringBuffer();
    for (T item in list) {
      stringBuffer.write(item.toString() + "\n");
    }
    if (stringBuffer.toString().isEmpty) {
      return "-";
    }
    // remove last \n
    return stringBuffer.toString()
        .substring(0, stringBuffer.toString().length - 1);
  }
}