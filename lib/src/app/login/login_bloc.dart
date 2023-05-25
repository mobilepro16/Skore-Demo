import 'dart:async';

import 'package:flutter_app_flavor/src/config/flavor_config.dart';
import 'package:flutter_app_flavor/src/data/response/login_response.dart';
import 'package:flutter_app_flavor/src/repos/user/user_repository.dart';
import 'package:flutter_app_flavor/src/utils/api_constants.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter_app_flavor/src/app/authentication/authentication.dart';
import 'package:flutter_app_flavor/src/app/login/login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  final FlavorConfig flavorConfig = FlavorConfig.instance;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final LoginResponse loginResponse = await userRepository.authenticate(
            username: event.email.trim(),
            password: event.password,
            companyId: flavorConfig.values.companyId);

        if (loginResponse != null && loginResponse.status == null) {
          authenticationBloc.dispatch(LoggedIn(token: loginResponse.token));
          yield LoginInitial();
        } else {
          yield LoginFailure(error: loginResponse.message);
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
