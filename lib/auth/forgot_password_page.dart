import 'package:flutter/material.dart';
import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';

import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    // TODO: Send the password reset.

    UserResponse res = await sbClient.auth.updateUser(
        UserAttributes(
            password: 'new password'
        )
    );
    
    await sbClient.auth.reauthenticate();

    // try {
    //   await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
    //
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return const AlertDialog(
    //           content: Text('Password reset link sent!'),
    //         );
    //       });
    //
    // } on FirebaseAuthException catch (e) {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           content: Text(e.message.toString()),
    //         );
    //       });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      /// ***** App Bar ***** ///
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarWrapper(
          title: "Forgot Password",
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
                'Enter Your Email below.\nWe will send you a password reset link.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Inter', color: Colors.white, fontSize: 16)),
          ),

          const SizedBox(height: 10),

          // Email TextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amber),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Email',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),

          const SizedBox(height: 10),

          MaterialButton(
            onPressed: passwordReset,
            color: Colors.green[700],
            child: const Text('Reset Password'),
          )
        ],
      ),
    );
  }
}
