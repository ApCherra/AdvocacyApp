import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coa_progress_tracking_app/main.dart';

void main() {
  testWidgets('Testing Register Page', (WidgetTester tester) async {
  //print('testing this out statementn 1');

  //await tester.pumpWidget(const MainPage());
  //WidgetsFlutterBinding.ensureInitialized();
  SupabaseDB.instance.initDB();
 // print('testing this out statement 2');
  await tester.pumpWidget(const MyApp());

  // Enter text code...
  // Tap the add button.
   //print('testing this out statement 3');

  await tester.tap(find.byKey(Key('RegKey')));
  // Rebuild the widget after the state has changed.
  await tester.pump();

  // Expect to find the item on screen.
   // print('testing this out statement 4');

  expect(find.text('Please Register Below'), findsAny);

   // print('testing this out statement 5');

});
}
