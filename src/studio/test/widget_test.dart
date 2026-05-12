import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_studio/main.dart';

void main() {
  testWidgets('app renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const QtDataStudio());
    expect(find.text('量潮数据'), findsWidgets);
  });
}
