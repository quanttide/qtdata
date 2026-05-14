import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:qtdata_studio/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app loads data board from provider', (tester) async {
    await tester.pumpWidget(const app.HomePage());
    await tester.pumpAndSettle();

    expect(find.text('需求探索'), findsOneWidget);
    expect(find.text('约定启动'), findsOneWidget);
    expect(find.text('执行监控'), findsOneWidget);
    expect(find.text('验收交付'), findsOneWidget);
  });
}
