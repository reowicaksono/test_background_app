class Helper {
  Helper._();
  static int _counter = 1;
  static String next() {
    final id = _counter.toString().padLeft(3, '0');
    _counter++;
    return 'TRX-$id';
  }
}
