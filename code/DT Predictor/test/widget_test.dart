// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:newtest/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(MyApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newtest/predModel.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  testWidgets('PredModel Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PredModel()));

    // Enter values in text fields
    await tester.enterText(find.byKey(ValueKey('rh_text_field')), '10');
    await tester.enterText(find.byKey(ValueKey('upv_text_field')), '20');
    await tester.enterText(find.byKey(ValueKey('stype_text_field')), '30');
    await tester.enterText(find.byKey(ValueKey('ctype_text_field')), '40');

    // Tap the 'Predict' button
    // await tester.tap(find.text('PREDICT'));
    // await tester.pumpAndSettle();

    // Verify the predicted value is displayed
    // expect(find.text('Predicted Value :'), findsOneWidget);

    // Tap the 'Clear' button
    // await tester.tap(find.text('CLEAR'));
    // await tester.pumpAndSettle();

    // // Verify the text fields are cleared
    expect(find.text('10'), findsNothing);
    expect(find.text('20'), findsNothing);
    expect(find.text('30'), findsNothing);
    expect(find.text('40'), findsNothing);
  });
}
