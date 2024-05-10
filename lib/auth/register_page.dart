import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:coa_progress_tracking_app/utilities/coa_text_field.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showWelcomePage;
  const RegisterPage({super.key, required this.showWelcomePage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future signUp() async {
    // Authenticate the user
    // TODO: Handle errors as needed

    if (!SupabaseDB.instance.validateEmail(_emailController.text.trim())) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Error: Bad Email Format. username@domain.com"),
            );
          });
      return;
    }

    try {
      if (await passwordConfirmed()) {
        var signup = await sbClient.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          data: getMetadata(),
        );

        if (signup.session != null) {
          SupabaseDB.instance.session = signup.session!;
        }

        if (signup.user != null) {
          SupabaseDB.instance.user = signup.user!;
        }
      }
    } on Exception catch (e) {
      debugPrint("Failed to signup. EXC:${e.toString()}");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.toString()),
          );
      });
    }

    /*try {
      if (passwordConfirmed()) {
        // create user

        // await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //   email: _emailController.text.trim(),
        //   password: _passwordController.text.trim(),
        // );

        addUserDetails(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _usernameController.text.trim(),
          _emailController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }*/
  }

  Map<String, dynamic>? getMetadata() {
      Map<String, String> metadata = {
        "firstName" : _firstNameController.text.trim(),
        "lastName" : _lastNameController.text.trim(),
        "username" : _usernameController.text.trim().toLowerCase(),
      };
      return metadata;
  }

  @Deprecated("Obsolete method of assigning data to user.")
  Future addUserDetails(String firstName, String lastName, String username, String email) async {
    // final docUser = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid);
    //
    // final json = {
    //   'firstName': firstName,
    //   'lastName': lastName,
    //   'username': username,
    //   'email': email,
    // };
    //
    // // Create document and write data to Firebase
    // await docUser.set(json);
  }

  Future<bool> passwordConfirmed() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      return await verifySpaces();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Passwords do not match.'),
            );
          });
      return false;
    }
  }

  Future<bool> verifySpaces() async {
    bool isValid = false;
    // Check if there are whitespaces before or after password.
    if (_passwordController.text == _passwordController.text.trim()) {
      return true;
    }
    // else
    // There is a space before or after the password. Verify the user wants this.
    await showDialog(context: context,
        builder: (context) => AlertDialog(
        content: const Text('Password ends or begin with a space. Is this ok?'),
        actions: [
          TextButton(
              onPressed: () => isValid = true,
              child: const Text("Yes")),
          TextButton(
              onPressed: () => isValid = false,
              child: const Text("No")),
        ],
      )
    );

    return isValid;
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
                const SizedBox(height: 10),
                // Hello Again!
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Please Register Below',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),

                // COA Logo Asset
                Image.asset("assets/coa-logo.JPG", height: size.height * 0.3, width: size.width * 0.5),

                // First Name TextField
                CoaTextField.generateDefault(_firstNameController, 'First Name'),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: TextField(
                //     controller: _firstNameController,
                //     decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.white),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.amber),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       hintText: 'First Name',
                //       fillColor: Colors.grey[200],
                //       filled: true,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),

                // Last Name TextField
                CoaTextField.generateDefault(_lastNameController, 'Last Name'),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: TextField(
                //     controller: _lastNameController,
                //     decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.white),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.amber),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       hintText: 'Last Name',
                //       fillColor: Colors.grey[200],
                //       filled: true,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),

                // Username TextField
                CoaTextField.generateDefault(_usernameController, 'Username'),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: TextField(
                //     controller: _usernameController,
                //     decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.white),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.amber),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       hintText: 'Username',
                //       fillColor: Colors.grey[200],
                //       filled: true,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),

                // Email TextField
                CoaTextField.generateDefault(_emailController, 'Email'),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: TextField(
                //     controller: _emailController,
                //     decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.white),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.amber),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       hintText: 'Email',
                //       fillColor: Colors.grey[200],
                //       filled: true,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),

                // Password TextField
                CoaTextField.generateSecure(_passwordController, 'Password'),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: TextField(
                //     obscureText: true,
                //     controller: _passwordController,
                //     decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.white),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.amber),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       hintText: 'Password',
                //       fillColor: Colors.grey[200],
                //       filled: true,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),

                // Confirm Password TextField
                CoaTextField.generateSecure(_confirmPasswordController, 'Confirm Password'),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: TextField(
                //     obscureText: true,
                //     controller: _confirmPasswordController,
                //     decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.white),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.amber),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       hintText: 'Confirm Password',
                //       fillColor: Colors.grey[200],
                //       filled: true,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),
                // Sign in Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
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

                // I already registered. Register Here!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'I already registered.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showWelcomePage,
                      child: Text(' Login now',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),

                    const SizedBox(height: 20),
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
