import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../../../secrets.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  late final Supabase _client;
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();
  bool _initialized = false;
  factory SupabaseService() => _instance;

  SupabaseService._internal();

  // Supabase initialisieren
  Future<void> initialize() async {
    await Supabase.initialize(
      url: supabase_url,
      anonKey: supabase_key,
      debug: true,
    );
    _client = Supabase.instance;
    _initialized = true;
  }

  Supabase get client {
    if (!_initialized) {
      throw Exception("SupabaseClient ist noch nicht initialisiert.");
    }
    return _client;
  }

  // Session wiederherstellen
  Future<void> restoreSession() async {
    try {
      final sessionData = await _prefs.getString('supabase_session');
      if (sessionData.isNotEmpty) {
        await _client.client.auth.recoverSession(sessionData);
        print("Session erfolgreich wiederhergestellt.");
      } else {
        print("Keine gespeicherte Session gefunden.");
      }
    } catch (e) {
      print("Fehler beim Wiederherstellen der Session: $e");
    }
  }

  // Authentifizierungsstatus prüfen
  Future<bool> isAuthenticated() async {
    await restoreSession();
    return _client.client.auth.currentUser != null;
  }

  // Auth-Zustandsänderungen abonnieren
  Stream<AuthState> get authStateChanges =>
      _client.client.auth.onAuthStateChange;
}
