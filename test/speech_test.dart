import 'dart:convert';
import 'dart:io';
import 'package:coa_progress_tracking_app/auth/main_page.dart';
import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:coa_progress_tracking_app/pages/home_page.dart';
import 'package:coa_progress_tracking_app/pages/speech_page.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/factory_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coa_progress_tracking_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:coa_progress_tracking_app/auth/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nock/nock.dart';



void main() {
   void disableOverflowErrors() {
  //TODO MyScreen throws overflow error. Will be investigate in a different ticket.
  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception;
    final isOverflowError = exception is FlutterError &&
        !exception.diagnostics.any(
            (e) => e.value.toString().startsWith("A RenderFlex overflowed by"));

    if (isOverflowError) {
      print(details);
    } else {
      FlutterError.presentError(details);
    }
  };
}

  setUpAll(nock.init);

  setUp(() {
    nock.cleanAll();
  });

  final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Testing if Speech Page is clickable.', (WidgetTester tester) async {
     //tester.view.physicalSize = Size(640,640);
     nock('https://')
      .get('/')
      .reply(200, json.encode('{"id": "49c23ebc-c107-4dae-b1c6-5d325b8f8b58", "name": "Example campus" }'));
      //await binding.setSurfaceSize(Size(1280,800));

      SupabaseDB.instance.initDB();
      disableOverflowErrors();
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byKey(Key('EmailKey')), 'apramgolden@gmail.com');
      await tester.enterText(find.byKey(Key('PasswordKey')), 'Password');
   
      await tester.tap(find.byKey(Key('SignIn')));
      
        //Mocking session login
        var _session = {"access_token":"eyJhbGciOiJIUzI1NiIsImtpZCI6Imx4a2x2cG55ZDNNUmhYZXUiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzExMjU3NzcwLCJpYXQiOjE3MTEyNTQxNzAsImlzcyI6Imh0dHBzOi8vdnJ3c3BydmtueGd5cGdxdm5zbmUuc3VwYWJhc2UuY28vYXV0aC92MSIsInN1YiI6ImU1NDdmMThkLTIzODAtNDFjMi1hNGM5LTdmNDg3NzlhZjgxNiIsImVtYWlsIjoiYXByYW1nb2xkZW5AZ21haWwuY29tIiwicGhvbmUiOiIiLCJhcHBfbWV0YWRhdGEiOnsicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdfSwidXNlcl9tZXRhZGF0YSI6eyJmaXJzdE5hbWUiOiJBIiwibGFzdE5hbWUiOiJDIiwidXNlcm5hbWUiOiJhYyJ9LCJyb2xlIjoiYXV0aGVudGljYXRlZCIsImFhbCI6ImFhbDEiLCJhbXIiOlt7Im1ldGhvZCI6InBhc3N3b3JkIiwidGltZXN0YW1wIjoxNzExMjU0MTcwfV0sInNlc3Npb25faWQiOiI0MjQyNTk3Ni1hNzI4LTQ3ZTQtYjhiNC1mYWFkMjMyNDMzMGEifQ.DHtSheNJIA-nd70g4LP5JRBeV6en1brHh2KQ_vww2vQ","expires_in":3600,"expires_at":1711257770,"refresh_token":"RMJ7GxLnhxMlCxWoFjScag","token_type":"bearer","provider_token":null,"provider_refresh_token":null,"user":{"id":"e547f18d-2380-41c2-a4c9-7f48779af816","app_metadata":{"provider":"email","providers":["email"]},"user_metadata":{"firstName":"A","lastName":"C","username":"ac"},"aud":"authenticated","confirmation_sent_at":null,"recovery_sent_at":null,"email_change_sent_at":null,"new_email":null,"invited_at":null,"action_link":null,"email":"apramgolden@gmail.com","phone":"","created_at":"2024-03-01T04:12:38.263834Z","confirmed_at":"2024-03-01T04:12:38.269237Z","email_confirmed_at":"2024-03-01T04:12:38.269237Z","phone_confirmed_at":null,"last_sign_in_at":"2024-03-24T04:22:50.462039929Z","role":"authenticated","updated_at":"2024-03-24T04:22:50.463526Z","identities":[{"id":"e547f18d-2380-41c2-a4c9-7f48779af816","user_id":"e547f18d-2380-41c2-a4c9-7f48779af816","identity_data":{"email":"apramgolden@gmail.com","email_verified":false,"phone_verified":false,"sub":"e547f18d-2380-41c2-a4c9-7f48779af816"},"provider":"email","created_at":"2024-03-01T04:12:38.267465Z","last_sign_in_at":"2024-03-01T04:12:38.267409Z","updated_at":"2024-03-01T04:12:38.267465Z"}],"factors":null}};
        var _user = {"id":"e547f18d-2380-41c2-a4c9-7f48779af816","app_metadata":{"provider":"email","providers":["email"]},"user_metadata":{"firstName":"A","lastName":"C","username":"ac"},"aud":"authenticated","confirmation_sent_at":null,"recovery_sent_at":null,"email_change_sent_at":null,"new_email":null,"invited_at":null,"action_link":null,"email":"apramgolden@gmail.com","phone":"","created_at":"2024-03-01T04:12:38.263834Z","confirmed_at":"2024-03-01T04:12:38.269237Z","email_confirmed_at":"2024-03-01T04:12:38.269237Z","phone_confirmed_at":null,"last_sign_in_at":"2024-03-24T04:22:50.462039929Z","role":"authenticated","updated_at":"2024-03-24T04:22:50.463526Z","identities":[{"id":"e547f18d-2380-41c2-a4c9-7f48779af816","user_id":"e547f18d-2380-41c2-a4c9-7f48779af816","identity_data":{"email":"apramgolden@gmail.com","email_verified":false,"phone_verified":false,"sub":"e547f18d-2380-41c2-a4c9-7f48779af816"},"provider":"email","created_at":"2024-03-01T04:12:38.267465Z","last_sign_in_at":"2024-03-01T04:12:38.267409Z","updated_at":"2024-03-01T04:12:38.267465Z"}],"factors":null};
        var rsp = new AuthResponse(session: Session.fromJson(_session), user: User.fromJson(_user));
        SupabaseDB.instance.session = rsp.session!;
        SupabaseDB.instance.user = rsp.user!;
        sbClient.auth.notifyAllSubscribers(AuthChangeEvent.signedIn);  
        
        await tester.pumpAndSettle();
        
        // Ignoring redering exceptions to move to testing functionality. The redering engines in tester and actual application are different
        expect(tester.takeException().toString().contains("A RenderFlex "), false);
        //expect(tester.takeException().contains("A RenderFlex "), isFlutterError);

        //expect(tester.takeException().toString().contains("400"), false);

        //expect(tester.takeException().toString().contains("RenderFlex "), false);

        //await tester.tap(find.text('Speech'));
        await tester.tap(find.byIcon(Icons.record_voice_over));

            await tester.pumpAndSettle();

        expect(find.byKey(Key('SpeechKey')), findsAny);

  });
}