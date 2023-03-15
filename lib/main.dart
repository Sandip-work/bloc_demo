import 'package:bloc_demo/blocs/auth_cubit.dart';
import 'package:bloc_demo/blocs/bloc_observer.dart';
import 'package:bloc_demo/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {

  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => AuthCubit(),

    child:
    MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(

    primarySwatch: Colors.blue,
    ),
    home: const LoginPage(),
    ),
    );
  }
}

