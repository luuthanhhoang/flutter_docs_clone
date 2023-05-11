import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository {
  void setToken(String token) async {
    SharedPreferences preferendes = await SharedPreferences.getInstance();
    preferendes.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    SharedPreferences preferendes = await SharedPreferences.getInstance();
    String? token = preferendes.getString('x-auth-token');

    return token;
  }
}
