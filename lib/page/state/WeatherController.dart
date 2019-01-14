import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:gdg_weather/page/city/CityData.dart';
import 'package:gdg_weather/page/weather/WeatherData.dart';
import 'package:http/http.dart' as http;

class WeatherControllerWidget extends StatefulWidget{
  Widget child;

  WeatherControllerWidget({this.child});
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WeatherControllerState();
  }

  static WeatherControllerState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(_WeatherInheritedWidget) as _WeatherInheritedWidget).state;
  }

}

class WeatherControllerState extends State<WeatherControllerWidget>{

  List<CityData> cityList = new List<CityData>();
  String curCityName;
  WeatherData weather = WeatherData.empty();

  void getCityList() async {
    final response = await http.get('https://search.heweather.net/top?group=cn&key=ebb698e9bb6844199e6fd23cbb9a77c5');

        List<CityData> list = new List<CityData>();

        if(response.statusCode == 200){
          //解析数据
          Map<String,dynamic> result = json.decode(response.body);
          for(dynamic data in result['HeWeather6'][0]['basic']){
            CityData cityData = CityData(data['location']);
            list.add(cityData);
          }
        }

        setState(() {
                  cityList = list;
                });
  }

  void getCityWeather() async{
    final response = await http.get('https://free-api.heweather.com/s6/weather/now?location='+curCityName+'&key=ebb698e9bb6844199e6fd23cbb9a77c5');
    if(response.statusCode == 200){
      setState(() {
              weather = WeatherData.fromJson(json.decode(response.body));
            });
    }else{
      setState(() {
              weather = WeatherData.empty();
            });
    }
  }

  void selectCity(String city){
    curCityName = city;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _WeatherInheritedWidget(
      state: this,
      child: widget.child,
    );
  }

}

class _WeatherInheritedWidget extends InheritedWidget{
  WeatherControllerState state;

  _WeatherInheritedWidget({
    Key key,
    @required this.state,
    @required Widget child
  }):super(key: key,child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

}