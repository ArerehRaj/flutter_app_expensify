import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:async';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token = '';
  String _userId = '';
  DateTime _expiryDate = DateTime.now();
  Timer? _authTimer;

  // get method to verify if the user is authenticated or not
  bool get isAuthenticated {
    return (_token != '') && (_token != 'null');
  }

  // get method to get the value of token
  String get token {
    if (_token != '' &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return 'null';
  }

  // get method to get the userId of the authenticated user
  String get userID {
    return _userId;
  }

  // Function for authenticating the user if signing up or login using firebase rest api
  Future<void> _authenticateUser(
      String email, String password, String segment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=AIzaSyDtqG9a1iD0NdkP356WsPsMQsdVZ-vlQc8');

    try {
      // sending the post request to firebase with email, password of the user
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      // extracting the response of the post url recieved from firebase
      final extractedResponse = json.decode(response.body);
      if (extractedResponse['error'] != null) {
        throw HttpException(extractedResponse['error']['message'].toString());
      }

      // setting up the token, userID and expiryDate of the token
      // for the authenticated user
      _token = extractedResponse['idToken'];
      _userId = extractedResponse['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            extractedResponse['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();

      // Storing the user auth data in shared prefs
      // for auto login and auto logout
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString(
        'userData',
        userData,
      );
    } catch (error) {
      throw error;
    }
  }

  // Sign up method
  Future<void> signUp(String email, String password) async {
    return _authenticateUser(email, password, 'signUp');
  }

  // Login method
  Future<void> signIn(String email, String password) async {
    return _authenticateUser(email, password, 'signInWithPassword');
  }

  // logout function
  Future<void> logout() async {
    // setting the auth data to empty string and values
    _token = '';
    _userId = '';
    _expiryDate = DateTime.now();
    if (_authTimer != null) {
      // cancelling the auth timer for auto logout as the user
      // is logging out before expiry date or time
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // removing the user data from the shared prefs when the
    // user logs out
    prefs.remove('userData');
  }

  // function to set the auto logout functionality
  void _autoLogout() {
    if (_authTimer != null) {
      // cancelling the previous timer and then
      // updating with new time below
      _authTimer?.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }

  // function to auto login the user
  Future<bool> tryAutoLogin() async {
    // getting the shared prefs
    final prefs = await SharedPreferences.getInstance();
    // checking if the shared prefs contains the auth data of user
    if (!prefs.containsKey('userData')) {
      return false;
    }

    // extracting the auth data of the
    // user from shared prefs
    final extractedUserData = json
        .decode(prefs.getString('userData').toString()) as Map<String, Object>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);
    // if the expiry date is passed then return false
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    // updating the auth data of the user
    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'].toString();
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}
