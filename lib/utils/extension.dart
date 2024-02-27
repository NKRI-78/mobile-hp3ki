extension StringExtension on String {
  String capitalize() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.capitalize()).join(' ');
  String firstFewWords() {
    int? startIndex = 0, indexOfSpace;

    for (int i = 0; i < 2; i++) {
      indexOfSpace = indexOf(' ', startIndex!);
      if (indexOfSpace == -1) {
        //-1 is when character is not found
        return this;
      }
      startIndex = indexOfSpace + 1;
    }

    return substring(0, indexOfSpace);
  }
  String smallSentence() {
    if (length > 15) {
      return substring(0, 15) + '...';
    } else {
      return this;
    }
  }
  String midSentence() {
    if (length > 25) {
      return substring(0, 25) + '...';
    } else {
      return this;
    }
  }
  String customSentence(int inputLength) {
    if (length > inputLength) {
      return substring(0, inputLength) + '...';
    } else {
      return this;
    }
  }
}