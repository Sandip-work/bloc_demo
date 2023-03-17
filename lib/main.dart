import 'package:bloc_demo/pages/weather_search_page.dart';
import 'package:bloc_demo/repository/weather_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_demo/blocs/weather_cubit.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: BlocProvider(
        create: (context) => WeatherCubit(FakeWeatherRepository()),
        child:  WeatherSearchPage(),
      ),
    );
  }
}
