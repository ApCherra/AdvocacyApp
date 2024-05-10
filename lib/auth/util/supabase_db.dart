import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:email_validator/email_validator.dart';

final class SupabaseDB {

  // Initialize the DB.
  Future initDB() async {
    const supabaseUrl = 'https://vrwsprvknxgypgqvnsne.supabase.co';
    const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyd3NwcnZrbnhneXBncXZuc25lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDIwNjk2NzQsImV4cCI6MjAxNzY0NTY3NH0.qsO0f7V8KC-qWvWTBD0j0dUz4LqBEQHVxWC8T1CdngE';

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey
    );

    user = sbClient.auth.currentUser;
    session = sbClient.auth.currentSession;
  }

  // Validate an email address for account purposes.
  bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  // Get the User's name from the metadata.
  String getName() {
    String first = instance.user?.userMetadata?["firstName"] ?? "";
    String last = instance.user?.userMetadata?["lastName"] ?? "";

    // If both first and last name exist, greet user
    if (first.isNotEmpty && last.isNotEmpty) {
      return "$first $last";
    }

    // If first name exists, greet with first name
    if (first.isNotEmpty) {
      return first;
    }

    // If last name exists, greet with last name
    if (last.isNotEmpty) {
      return last;
    }

    return "Unknown User";
  }

  // Update metadata about the user.
  Future<void> updateUser(String key, dynamic value) async {
    final UserResponse res = await sbClient.auth.updateUser(
      UserAttributes(
        data: { key : value },
      ),
    );

    // Update the user.
    instance.user = res.user;
  }

  User? user;
  Session? session;

  static SupabaseDB instance = SupabaseDB();
}

final sbClient = Supabase.instance.client;
