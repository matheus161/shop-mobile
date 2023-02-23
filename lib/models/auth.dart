import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_expection.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expireDate;
  Timer? _logoutTimer;

  bool get isAuth {
    //Data depois de agora
    final isValid = _expireDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  //Retorne o token se ele tiver autenticado
  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyBsGVba9_Q6ERXMTJttHCqgzNlZ4qMJkWE";
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body["error"] != null) {
      throw AuthException(body["error"]["message"]);
    } else {
      //Salvando os parâmetros recebidos
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      // Persistir os dados na memória do Celular
      Store.saveMap("userData", {
        "token": _token,
        "email": _email,
        "userId": _userId,
        "expireDate": _expireDate!.toIso8601String(),
      });

      // Espera o tempo de expiração
      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> tryAutoLogin() async {
    // Checar se está autenticado
    if (isAuth) return;

    // Checar se ele possui os dados salvos
    final userData = await Store.getMap("userData");
    if (userData.isEmpty) return;

    // Checar se o token está expirado
    final expireDate = DateTime.parse(userData["expireDate"]);
    if (expireDate.isBefore(DateTime.now())) return;

    _token = userData["token"];
    _email = userData["email"];
    _userId = userData["userId"];
    _expireDate = expireDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expireDate = null;
    _clearLogoutTimer();
    // Remove os dados no logout
    Store.remove("userData").then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  // Desloga automaticamente de acordo com o tempo de expiração
  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expireDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}
