import 'dart:async';
import 'dart:convert';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as SP_;
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SP_.Supabase supabase;
  late final StreamSubscription<SP_.AuthState> _authStateSubscription;
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();
  static const String _sessionKey = 'supabase_session';

  AuthBloc({required this.supabase}) : super(AuthInitial()) {
    // Event-Handler registrieren
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthMagicLinkRequested>(_onMagicLinkRequested);

    // Auth-Zustands-Listener initialisieren

    _authStateSubscription = supabase.client.auth.onAuthStateChange.listen(
      (data) async {
        final SP_.AuthChangeEvent event = data.event;
        final SP_.Session? session = data.session;

        debugPrint("Auth Event: ${data.event}");
        debugPrint("Session: ${data.session}");

        debugPrint("Auth State Changed: $event");

        if (session != null) {
          await _saveSession(session);
          add(AuthCheckStatusRequested());
        } else if (event == SP_.AuthChangeEvent.signedOut) {
          add(AuthLogoutRequested());
        }
      },
      onError: (error) {
        if (error is SP_.AuthException) {
          add(AuthErrorOccurred(error.message));
        } else {
          add(AuthErrorOccurred('Unexpected error occurred'));
        }
      },
    );

    // Initiale Überprüfung des Auth-Status
    add(AuthCheckStatusRequested());
  }

  // Session speichern
  Future<void> _saveSession(SP_.Session session) async {
    try {
      final sessionData = session.toJson();
      await _prefs.setString(_sessionKey, sessionData.toString());
      print("Session gespeichert.");
    } catch (e) {
      print("Fehler beim Speichern der Session: $e");
    }
  }

  // Session laden
  Future<SP_.Session?> _loadSession() async {
    try {
      final sessionData = await _prefs.getString(_sessionKey);
      if (sessionData.isNotEmpty) {
        debugPrint("Session Data: $sessionData");
        return SP_.Session.fromJson(
            Map<String, dynamic>.from(jsonDecode(sessionData)));
      } else {
        print("Keine Session gefunden!");
      }
    } catch (e) {
      print("Fehler beim Laden der Session: $e");
    }
    return null;
  }

  // Authentifizierungsstatus prüfen
  Future<void> _onCheckStatusRequested(
      AuthCheckStatusRequested event, Emitter<AuthState> emit) async {
    try {
      final user = supabase.client.auth.currentUser;
      if (user != null) {
        emit(AuthAuthenticated());
      } else {
        final session = await _loadSession();
        if (session != null) {
          supabase.client.auth.recoverSession(_sessionKey);
          emit(AuthAuthenticated());
        } else {
          emit(AuthUnauthenticated());
        }
      }
    } catch (e) {
      emit(AuthError("Error checking authentication: $e"));
    }
  }

  // Magic Link anfordern
  Future<void> _onMagicLinkRequested(
      AuthMagicLinkRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await supabase.client.auth.signInWithOtp(
        email: event.email.trim(),
        emailRedirectTo: kIsWeb ? null : 'voltshare://logincallback',
      );
      emit(AuthMagicLinkSent());
    } catch (e) {
      emit(AuthError("Magic Link error: ${e.toString()}"));
    }
  }

  // Benutzer abmelden
  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await supabase.client.auth.signOut();
      await _prefs.remove(_sessionKey);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError("Logout failed: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}
