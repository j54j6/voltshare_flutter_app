import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/auth_event.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String targetRoute;
  LoginScreen({required this.targetRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Wenn der Benutzer erfolgreich authentifiziert wurde
          debugPrint("Derzeitiger State: $state");
          if (state is AuthAuthenticated) {
            // Weiterleitung zur Home-Seite nach erfolgreichem Login
            context.go(targetRoute);
          }
          // Wenn ein Fehler bei der Authentifizierung auftritt
          else if (state is AuthError) {
            // Zeigt eine Snackbar mit der Fehlernachricht
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          } else if (state is AuthMagicLinkSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Magic Link sent!")),
            );
            emailController.clear();
          }
        },
        builder: (context, state) {
          // Wenn der Zustand "laden" ist, zeige einen Ladeindikator an
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // Ansonsten zeige das Login-Formular
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // E-Mail Textfeld
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16),
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // AuthLoginRequested Event an den BLoC senden
                    if (state is AuthMagicLinkSent) {
                      null;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Magic Link already sent - Please wait!")),
                      );
                    } else {
                      if (EmailValidator.validate(emailController.text)) {
                        context.read<AuthBloc>().add(AuthMagicLinkRequested(
                              email: emailController.text,
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Bitte gebe eine gültige E-Mail Adresse an!")),
                        );
                      }
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
