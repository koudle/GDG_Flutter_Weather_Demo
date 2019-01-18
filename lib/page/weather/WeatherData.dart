class WeatherData{
  String cond; //天气
  String tmp; //温度
  String hum; //湿度

  WeatherData({this.cond, this.tmp, this.hum});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    try{
      return WeatherData(
        cond: json['HeWeather6'][0]['now']['cond_txt'],
        tmp: json['HeWeather6'][0]['now']['tmp']+"°",
        hum: "湿度  "+json['HeWeather6'][0]['now']['hum']+"%",
      );
    }catch(e){
      return WeatherData.empty();
    }
  }

  factory WeatherData.empty() {
    return WeatherData(
      cond: "",
      tmp: "",
      hum: "",
    );
  }
}