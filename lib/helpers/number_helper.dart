String prettyPercentage(num number) {
  var doublen = number.toDouble();
  var intn = number.toInt();
  if (doublen - intn == 0) {
    return intn.toString();
  }

  return doublen.toStringAsFixed(2);
}
