import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_rsud_arifin_achmad/business_logic/login_bloc.dart';
import 'package:test_rsud_arifin_achmad/business_logic/register_mcu_bloc.dart';
import 'package:test_rsud_arifin_achmad/pages/login/login_page.dart';

void main() {
  runApp(const MCUApp());
}

class MCUApp extends StatelessWidget {
  const MCUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => RegistrationBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginPage(),
      ),
    );
  }
}
