import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdg_weather/page/weather/WeatherData.dart';
import 'package:http/http.dart' as http;

class WeatherWidget extends StatefulWidget{
  String cityName;

  WeatherWidget(this.cityName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new WeatherState(this.cityName);
  }

}

class WeatherState extends State<WeatherWidget>{

  String cityName;

  WeatherData weather = WeatherData.empty();

  WeatherState(String cityName){
    this.cityName = cityName;
    _getWeather();
  }

  void _getWeather() async{
    WeatherData data = await _fetchWeather();
    setState((){
      weather = data;
    });
  }

  Future<WeatherData> _fetchWeather() async{
    final response = await http.get('https://free-api.heweather.com/s6/weather/now?location='+this.cityName+'&key=ebb698e9bb6844199e6fd23cbb9a77c5');
    if(response.statusCode == 200){
      return WeatherData.fromJson(json.decode(response.body));
    }else{
      return WeatherData.empty();
    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  this.cityName,
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
                        weather?.tmp,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 80.0
                        )),
                    Text(
                        weather?.cond,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 45.0
                        )),
                    Text(
                      weather?.hum,
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