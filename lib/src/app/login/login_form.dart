import 'package:flutter/material.dart';
import 'package:flutter_app_flavor/src/config/flavor_config.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_app_flavor/src/app/authentication/authentication.dart';
import 'package:flutter_app_flavor/src/app/login/login.dart';

class LoginForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;

  LoginForm({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  FlavorConfig config = FlavorConfig.instance;
  String _email;
  String _password;
  bool _isObscure = true;
  Color _eyeColor;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc get _loginBloc => widget.loginBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginEvent, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22.0),
            children: <Widget>[
              SizedBox(
                height: kToolbarHeight,
              ),
              _buildTitle(config),
              _buildTitleLine(),
              SizedBox(height: 150.0),
              _buildEmailTextField(),
              SizedBox(height: 30.0),
              _buildPasswordTextField(context),
              SizedBox(height: 60.0),
              _buildLoginButton(context, state),
            ],
          ),
        );
      },
    );
  }

  Padding _buildTitle(FlavorConfig config) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 22.0),
      ),
    );
  }

  Padding _buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width / 4 - 16,
          height: 2.0,
        ),
      ),
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          filled: true,
          hintText: 'Email Address',
          hintStyle: TextStyle(color: Colors.grey),
          errorStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          isDense: true,
          fillColor: Colors.white),
      validator: (String value) {
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(value)) {
          return 'Please enter the correct email address';
        }
      },
      onSaved: (String value) => _email = value,
    );
  }

  TextFormField _buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      style: TextStyle(color: Colors.black),
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is not empty';
        }
      },
      decoration: InputDecoration(
          filled: true,
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.grey),
          errorStyle: TextStyle(color: Colors.black),
          isDense: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor ?? Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure ? Colors.grey : config.backgroundColor;
                });
              })),
    );
  }

  _buildLoginButton(BuildContext context, LoginState state) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          onPressed: () {
            if (state is! LoginLoading && _formKey.currentState.validate()) {
              _formKey.currentState.save();
              _onLoginButtonPressed();
            }
          },
          color: Colors.white,
          shape: StadiumBorder(side: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    _loginBloc.dispatch(LoginButtonPressed(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
