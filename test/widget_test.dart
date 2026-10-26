import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:connectworld/main.dart';

void main() {
  testWidgets('ConnectWorld App smoke test', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    try {
      await tester.pumpWidget(const ConnectWorldApp());
      await tester.pump();
      expect(find.text('ConnectWorld'), findsOneWidget);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
