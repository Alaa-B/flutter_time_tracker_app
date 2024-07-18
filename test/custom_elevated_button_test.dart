import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker_app/widgets/custom_elevated_button.dart';

void main() {
  testWidgets('elevated button', (WidgetTester tester) async {
    var pressed = false;
    await tester.pumpWidget(MaterialApp(
      home: CustomElevatedButton(
        backgroundColor: Colors.black38,
        onPressed: () => pressed = true,
        radius: 12,
        child: const Text('hmm'),
      ),
    ));
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
    expect(find.text('hmm'), findsOneWidget);
    await tester.tap(button);
    expect(pressed, true);
  });
}
