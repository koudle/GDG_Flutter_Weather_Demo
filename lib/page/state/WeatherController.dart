import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:gdg_weather/page/city/CityData.dart';
import 'package:gdg_weather/page/weather/WeatherData.dart';
import 'package:http/http.dart' as http;

//StatefulWidget 和 InheritedWidget配合使用
class WeatherControllerWidget extends StatefulWidget{
  Widget child;

  //这里需要传入child，这个参数，InheritedWidget初始化的时候需要用到
  WeatherControllerWidget({this.child});
  
  //这里和其他StatefulWidget一样，返回一个state
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WeatherControllerState();
  }

  //这里提供了一个static方法，是为了外面好获取
  static WeatherControllerState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(_WeatherInheritedWidget) as _WeatherInheritedWidget).state;
  }

}

//这个类是核心，用于状态管理，持有数据，并且功能都在这里实现
class WeatherControllerState extends State<WeatherControllerWidget>{

  //持有的数据
  List<CityData> cityList = new List<CityData>();
  String curCityName;
  WeatherData weather = WeatherData.empty();

  //获取城市列表的方法
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

  //获取当前城市的实时天气
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

  //表示选择了哪个城市
  void selectCity(String city){
    curCityName = city;
  }

  //这里返回了_WeatherInheritedWidget
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _WeatherInheritedWidget(
      state: this,
      child: widget.child,
    );
  }

}

//_WeatherInheritedWidget
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