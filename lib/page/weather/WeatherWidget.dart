import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdg_weather/page/weather/WeatherData.dart';
import 'package:gdg_weather/page/weather/WeatherModel.dart';
import 'package:scoped_model/scoped_model.dart';

class WeatherWidget extends StatefulWidget {
  String cityName;

  WeatherWidget(this.cityName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new WeatherState(this.cityName);
  }
}

class WeatherState extends State<WeatherWidget> {
  String cityName;

  WeatherState(String cityName) {
    this.cityName = cityName;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "images/weather_bg.jpg",
            fit: BoxFit.fitHeight,
          ),
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
                child: ScopedModelDescendant<WeatherModel>(
                  builder: (context, child, model) {
                    return Column(
                      children: <Widget>[
                        Text(model.weather?.tmp,
                            style: new TextStyle(
                                color: Colors.white, fontSize: 80.0)),
                        Text(model.weather?.cond,
                            style: new TextStyle(
                                color: Colors.white, fontSize: 45.0)),
                        Text(
                          model.weather?.hum,
                          style: new TextStyle(
                              color: Colors.white, fontSize: 30.0),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
