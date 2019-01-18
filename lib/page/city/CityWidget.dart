import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdg_weather/page/city/CityData.dart';
import 'package:gdg_weather/page/city/CityModel.dart';
import 'package:gdg_weather/page/weather/WeatherModel.dart';
import 'package:gdg_weather/page/weather/WeatherWidget.dart';
import 'package:scoped_model/scoped_model.dart';

class CityWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CityState();
  }
}

class CityState extends State<CityWidget> {
  CityState() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<CityModel>(
      builder: (context, child, model) {
        return ListView.builder(
            itemCount: model.cityList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: GestureDetector(
                  child: Text(model.cityList[index].cityName),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScopedModel<WeatherModel>(
                                  model: WeatherModel(
                                      model.cityList[index].cityName),
                                  child: WeatherWidget(
                                      model.cityList[index].cityName),
                                )));
                  },
                ),
              );
            });
      },
    );
  }
}
