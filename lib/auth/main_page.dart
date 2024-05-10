import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:coa_progress_tracking_app/auth/auth_page.dart';
import 'package:coa_progress_tracking_app/pages/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    IMPORTANT NOTE WHEN RUNNING ON APPLE DEVICES:
      IF THE SYSTEM RETURNS AN OS ERROR OF CODE 1,
      THE ENTITLEMENTS MUST BE CHANGED. ENSURE THE
      NETWORK CLIENT AND SERVER CAPABILITIES ARE
      ENABLED.

      (IN INTELLIJ)
      1. NAVIGATE TO MACOS OR IOS
      2. RIGHT CLICK ON RUNNER.XCWORKSPACE TO REVEAL IN FINDER
      (IN FINDER)
      3. OPEN RUNNER.XCWORKSPACE WITH XCODE
      (IN XCODE)
      4. CLICK ON THE RUNNER PROJECT IN THE LEFT PANE
      5. CLICK ON THE SIGNING & CAPABILITIES TAB ON THE MAIN SCREEN
      6. SCROLL DOWN TO "APP SANDBOX (DEBUG AND PROFILE)"
      6.1 IF YOU WANT TO EXPORT IT TO APP STORE, GO TO "... (RELEASE)"
      7. FIND NETWORK AND ENSURE THE TWO CHECKBOXES ARE BLUE.
          "INCOMING CONNECTIONS (SERVER)" AND  "OUTGOING CONNECTIONS (CLIENT)"
          SHOULD BE ENABLED.
      8. RUN THE PROJECT IN XCODE TO VERIFY YOU CONFIGURED THIS CORRECTLY.
      9. ONCE THE PROJECT RUNS CORRECTLY, YOU CAN RETURN TO INTELLIJ.

      THESE SETTINGS WILL BE PRESERVED UNTIL THE PROJECT IS REBUILT.
     */

    return Scaffold(
        body: StreamBuilder<AuthState>(
            stream: sbClient.auth.onAuthStateChange,
            builder: (context, snapshot) {
              if (SupabaseDB.instance.session != null &&
                  SupabaseDB.instance.user != null) {
                return const HomePage();
              }
              else
              {
                return const AuthPage();
              }
            }
        )
    );
  }
}
