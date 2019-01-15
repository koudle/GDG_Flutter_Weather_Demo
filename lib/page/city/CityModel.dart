import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:gdg_weather/page/city/CityData.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;


class CityModel extends Model{

  List<CityData> cityList = new List<CityData>();

  CityModel(){

  }
  
  static CityModel of(BuildContext context) => ScopedModel.of<CityModel>(context,rebuildOnChange: true);

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

    cityList = list;      
    notifyListeners();
  }
}