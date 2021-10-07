import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AuthMode { signUp, login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    // Getting the size of the device
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Expensify'),
            Image.asset(
              'assets/images/budget.png',
              fit: BoxFit.cover,
              height: 28,
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 25,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: const [
                        Text(
                          'Hello',
                          style: TextStyle(
                            fontSize: 60,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Sign in to your account!',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Flexible(child: AuthForm()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // Global key for managing the form data throughout the screen
  final GlobalKey<FormState> _formKey = GlobalKey();

  // By-defualt we will land the user on Login screen hence the mode is login
  AuthMode _authMode = AuthMode.login;

  // Map for storing the auth credentials
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  // var for showing the loading state, default value is false
  // hence not loading
  var _isLoading = false;

  // controller for managing the password
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      // height: 350,
      width: deviceSize.width * 0.9,
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Container(
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.email,
                      ),
                      label: Text(
                        'E-Mail',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lato',
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => _authData['email'] = value!,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Container(
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.password,
                      ),
                      label: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lato',
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    onSaved: (value) => _authData['password'] = value!,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
