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
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Flexible(child: AuthForm()),
              ],
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

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  // build method to return a sizedBox for variable height
  Widget _createSizedBox(double heightValue) {
    return SizedBox(
      height: heightValue,
    );
  }

  // build method to return Text widgets of variable message and font style
  Widget _createText(String message, double fontSize, FontWeight fontWeight) {
    return Text(
      message,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'Lato',
        fontWeight: fontWeight,
      ),
    );
  }

  // build method to return the input field widget
  Widget _createInputField(TextFormField formField) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
        child: formField,
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      // Invalid
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.login) {
      // Login code for firebase
    } else {
      // sign up code for firebase
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width * 0.9,
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _createSizedBox(50.0),
              _createText('Hello', 60.0, FontWeight.bold),
              _createSizedBox(20.0),
              if (_authMode == AuthMode.login)
                _createText('Login to your Account!', 25.0, FontWeight.normal)
              else
                _createText('Create a new account!', 25.0, FontWeight.normal),
              _createSizedBox(20.0),
              _createInputField(
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.email,
                    ),
                    hintText: 'E-Mail',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    // Checking here if the email is valid or not
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['email'] = value!,
                ),
              ),
              _createSizedBox(10.0),
              _createInputField(
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.password,
                    ),
                    hintText: 'Password',
                    border: InputBorder.none,
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    // Checking for password if its proper or not
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['password'] = value!,
                ),
              ),
              _createSizedBox(10.0),
              if (_authMode == AuthMode.signUp)
                _createInputField(
                  TextFormField(
                    enabled: _authMode == AuthMode.signUp,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.password,
                      ),
                      hintText: 'Confirm Password',
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.signUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                          }
                        : null,
                  ),
                ),
              _createSizedBox(10.0),
              if (_isLoading)
                CircularProgressIndicator()
              else
                Container(
                  width: deviceSize.width * 0.9,
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                  child: RaisedButton(
                    onPressed: _submitForm,
                    child: Text(
                      _authMode == AuthMode.login ? 'Login' : 'Sign Up',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button!.color,
                  ),
                ),
              _createSizedBox(10.0),
              FlatButton(
                onPressed: _switchAuthMode,
                child: Text(
                  '${_authMode == AuthMode.login ? 'Sign Up' : 'Login'} Instead',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Lato',
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                textColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
