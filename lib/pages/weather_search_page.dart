import 'package:bloc_demo/blocs/weather_cubit.dart';
import 'package:bloc_demo/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherSearchPage extends StatelessWidget {

  const WeatherSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Search"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state is WeatherError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is WeatherInitial) {
              return buildInitialInput();
            } else if (state is WeatherLoading) {
              return buildLoading();
            } else if (state is WeatherLoaded) {
              return buildColumnWithData(state.weather);
            } else {
              // (state is WeatherError)
              return buildInitialInput();
            }
          },
        ),
      ),
    );
  }
  Widget buildInitialInput(){
    return const Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  Column buildColumnWithData(Weather weather){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(weather.cityName,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),),
        Text(
          "${weather.temperatureCelsius.toStringAsFixed(1)} C",
          style: const TextStyle(
            fontSize: 80,
          ),
        ),
        const CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  const CityInputField({super.key});

  void submitCityName(BuildContext context, String cityName) {
    final weatherCubit = BlocProvider.of<WeatherCubit>(context);
    weatherCubit.getWeather(cityName);
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a City",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)
          ),
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
