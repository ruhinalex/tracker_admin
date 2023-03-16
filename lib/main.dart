import 'package:flutter/material.dart';
import 'package:tracker_admin/services/auth/firebase_auth_provider.dart';
import 'constants/routes.dart';
import 'services/auth/auth_service.dart';
import 'views/login_view.dart';
import 'views/main_view.dart';
import 'views/register_view.dart';
import 'views/verify_email_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseAuthProvider().initialize();
  runApp(
    MaterialApp(
      title: 'Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        mainRoute: (context) => const MainView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const MainView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// git config --global user.email "mohammad.ataullah.bd@gmail.com"
// git config --global user.name "MD Ataullah"
// git config --global user.password "zyQson-dapkap-2wytqi"