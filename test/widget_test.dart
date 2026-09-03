import 'package:flutter_test/flutter_test.dart';

import 'package:to_do_app/main.dart';

void main() {
  testWidgets('Welcome page shows Register and Log In buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(initialRoute: "welcome"));
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
