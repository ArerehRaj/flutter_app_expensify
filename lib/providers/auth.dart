import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:async';

class Auth with ChangeNotifier {
  String _token = '';
  String _userId = '';
  DateTime _expiryDate = DateTime.now();
  // Timer? _authTimer;

  // get method to verify if the user is authenticated or not
  bool get isAuthenticated {
    return (this._token != '') && (this._token != 'null');
  }

  // get method to get the value of token
  String get token {
    if (this._token != '' &&
        this._expiryDate != '' &&
        this._expiryDate.isAfter(DateTime.now())) {
      return this._token;
    }
    return 'null';
  }

  // get method to get the userId of the authenticated user
  String get userID {
    return this._userId;
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
        // error throw kar
      }

      // setting up the token, userID and expiryDate of the token
      // for the authenticated user
      this._token = extractedResponse['idToken'];
      this._userId = extractedResponse['localId'];
      this._expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            extractedResponse['expiresIn'],
          ),
        ),
      );
      notifyListeners();
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
}
