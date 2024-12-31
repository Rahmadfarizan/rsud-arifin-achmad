import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}


abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String role;

  LoginSuccess(this.role);

  @override
  List<Object?> get props => [role];
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      await Future.delayed(const Duration(seconds: 1)); 

      if (event.username.isEmpty || event.password.isEmpty) {
        emit(LoginFailure("Username and Password cannot be empty"));
      } else if (event.username == 'pasien') {
        emit(LoginSuccess("patient"));
      } else if (event.username == 'pendaftaran') {
        emit(LoginSuccess("admin"));
      } else {
        emit(LoginFailure("Invalid Username"));
      }
    });
  }
}
