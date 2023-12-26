String addZeroToNumber(int number) {
    if (number < 10) {
      return "0$number";
    } else if (number == 0) {
      return "00";
    } else {
      return "$number";
    }
  }