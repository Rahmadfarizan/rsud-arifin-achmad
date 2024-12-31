import 'dart:async';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_rsud_arifin_achmad/models/registration_mcu_model.dart';

abstract class RegistrationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRegistrationsEvent extends RegistrationEvent {}

class AddRegistrationEvent extends RegistrationEvent {
  final RegisterMCUModel registration;
  AddRegistrationEvent(this.registration);

  @override
  List<Object?> get props => [registration];
}

class UpdateRegistrationStatusEvent extends RegistrationEvent {
  final RegisterMCUModel registration;
  final String newStatus;

  UpdateRegistrationStatusEvent(this.registration, this.newStatus);

  @override
  List<Object?> get props => [registration, newStatus];
}

abstract class RegistrationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationLoaded extends RegistrationState {
  final List<RegisterMCUModel> registrations;
  RegistrationLoaded(this.registrations);

  @override
  List<Object?> get props => [registrations];
}

class RegistrationError extends RegistrationState {
  final String message;
  RegistrationError(this.message);

  @override
  List<Object?> get props => [message];
}

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final List<RegisterMCUModel> _registrations = [
    RegisterMCUModel(
      name: 'Rahmad',
      phone: '082286968275',
      type: 'General Check-Up',
      date: '2024-12-30',
      status: 'Pending',
    ),
    RegisterMCUModel(
      name: 'Farizan',
      phone: '08012340123',
      type: 'General Check-Up',
      date: '2024-12-30',
      status: 'Pending',
    ),
    RegisterMCUModel(
      name: 'Lucas',
      phone: '08123456789',
      type: 'General Check-Up',
      date: '2024-12-30',
      status: 'Approved',
    ),
    RegisterMCUModel(
      name: 'Andres',
      phone: '08987654321',
      type: 'General Check-Up',
      date: '2024-12-30',
      status: 'Rejected',
    ),
  ];

  RegistrationBloc() : super(RegistrationInitial()) {
    on<LoadRegistrationsEvent>((event, emit) async {
      emit(RegistrationLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        emit(RegistrationLoaded(_registrations));
      } catch (error) {
        emit(RegistrationError(error.toString()));
      }
    });

    on<AddRegistrationEvent>((event, emit) async {
      emit(RegistrationLoading());
      try {
        _registrations.add(event.registration);
        log('New Registration Added: ${event.registration.toJson()}');
        await Future.delayed(const Duration(seconds: 1));
        emit(RegistrationLoaded(List.unmodifiable(_registrations)));
      } catch (error) {
        emit(RegistrationError(error.toString()));
      }
    });

    on<UpdateRegistrationStatusEvent>((event, emit) {
      if (state is RegistrationLoaded) {
        final updatedRegistrations = (state as RegistrationLoaded)
            .registrations
            .map((r) => r == event.registration
                ? r.copyWith(status: event.newStatus)
                : r)
            .toList();

        emit(RegistrationLoaded(List.unmodifiable(updatedRegistrations)));
      }
    });
  }
}
