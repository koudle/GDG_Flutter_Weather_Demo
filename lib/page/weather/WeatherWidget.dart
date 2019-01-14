import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdg_weather/page/state/WeatherController.dart';
import 'package:gdg_weather/page/weather/WeatherData.dart';
import 'package:http/http.dart' as http;

class WeatherWidget extends StatefulWidget{

  WeatherWidget();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new WeatherState();
  }

}

class WeatherState extends State<WeatherWidget>{

  WeatherState(){
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final weatherState = WeatherControllerWidget.of(context);
    weatherState.getCityWeather();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset("images/weather_bg.jpg",fit: BoxFit.fitHeight,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 40.0),
                child: new Text(
                  weatherState.curCityName,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 100.0),
                child: Column(
                  children: <Widget>[
                    Text(
                        weatherState.weather?.tmp,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 80.0
                        )),
                    Text(
                        weatherState.weather?.cond,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 45.0
                        )),
                    Text(
                      weatherState.weather?.hum,
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 30.0
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}