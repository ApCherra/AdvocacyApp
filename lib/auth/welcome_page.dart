import 'package:flutter/material.dart';
import 'package:coa_progress_tracking_app/auth/forgot_password_page.dart';

import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WelcomePage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const WelcomePage({super.key, required this.showRegisterPage});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {

    if (!SupabaseDB.instance.validateEmail(_emailController.text.trim()))  {
      debugPrint("Error: User entered invalid email!");
      await showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Login failed."),
            content: Text("Failed to login. Check username and password, then try again."),
          )
      );
      return;
    }

    try {
      final AuthResponse resp = await sbClient.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text
      );

      if (resp.session == null || resp.user == null) {
        debugPrint("Error: Expected login session and user to be non-null.\nsession: ${resp.session}\nuser: ${resp.user}");
        await showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text("Login failed."),
              content: Text("Failed to login. Check username and password, then try again."),
            )
        );
      }

      // We know session and user are non-null at this point.
      SupabaseDB.instance.session = resp.session!;
      SupabaseDB.instance.user = resp.user!;
    } on AuthException catch (exc) {
       var title = Text("Error: ${exc.statusCode}");
       var message = Text("Message: ${exc.message}");
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: title,
            content: message,
          )
      );
    }

    /*
    try {
      throw FirebaseAuthException(code: "Manually Thrown", message: "FATAL");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }

     */
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gets height and width of screen
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //const SizedBox(height: 7),
                // COA Logo Asset
                Image.asset("assets/coa-logo.JPG", height: size.height * 0.35),
                const SizedBox(height: 7),

                // Email TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    key: Key('EmailKey'),

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

                // Password TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    key: Key('PasswordKey'),

                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const ForgotPasswordPage();
                              }));
                        },
                        child: Text('Forgot Password?',
                            style: TextStyle(
                              color: Colors.green[700],
                            )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Sign in Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          key: Key('SignIn'),

                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Need to Register? Register Here!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Need to Register?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                    key: Key('RegKey'),

                      onTap: widget.showRegisterPage,
                      child: Text(' Register now',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
