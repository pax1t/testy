

import 'package:flutter_test/flutter_test.dart';
import 'package:testy/counter.dart';

void main() {

  test('Initial Counter value', () {
    final counter = Counter();

    expect(counter.value, 0);
  });

  test('Counter value increment', () {
    final counter = Counter();

    counter.increment();

    expect(counter.value, 1);
  });

  test('Counter value decrement', () {
    final counter = Counter();

    counter.decrement();

    expect(counter.value, -1);

  });

}