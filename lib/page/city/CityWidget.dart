import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdg_weather/page/city/CityData.dart';
import 'package:gdg_weather/page/state/WeatherController.dart';
import 'package:gdg_weather/page/weather/WeatherWidget.dart';
import 'package:http/http.dart' as http;

class CityWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CityState();
  }

}

class CityState extends State<CityWidget>{

  CityState(){
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final weatherState = WeatherControllerWidget.of(context);
    weatherState.getCityList();
    return ListView.builder(
        itemCount: weatherState.cityList.length,
        itemBuilder: (context,index){
          return ListTile(
            title: GestureDetector(
              child:  Text(weatherState.cityList[index].cityName),
              onTap:(){
                weatherState.selectCity(weatherState.cityList[index].cityName);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeatherWidget())
                );
              },
            ),
          );
        });
  }

}
