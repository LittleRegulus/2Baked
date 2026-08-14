import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mobile web shell keeps rendering and touch coordinates aligned', () {
    final index = File('web/index.html').readAsStringSync();

    expect(index, contains('maximum-scale=1.0'));
    expect(index, contains('user-scalable=no'));
    expect(index, contains('viewport-fit=contain'));
    expect(index, contains('interactive-widget=resizes-content'));
    expect(index, contains('overscroll-behavior: none'));
    expect(index, contains('touch-action: none'));
    expect(
      index,
      contains(
        '<meta name="apple-mobile-web-app-status-bar-style" content="black">',
      ),
    );
  });
}
