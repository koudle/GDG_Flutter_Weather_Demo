# gdg_weather

 写一个查询天气的demo.

## 1.创建工程

在Android Studio中，`File` -> `New` ->`New Flutter Project` -> `Flutter Application`

创建完工程后，有三个目录

`android`：Android工程的目录

`ios`：iOS工程的目录

`lib`： Flutter工程的目录

其中android、ios下的文件我们都不动，我们只改动lib目录下的dart文件。



然后按`Run` 在手机上把程序跑起来。

## 2.天气API接口申请

注册地址[https://console.heweather.com/register](https://console.heweather.com/register) 

注册完后，再看API文档 https://www.heweather.com/documents

demo这里用的是，获取当天天气情况的API：[https://www.heweather.com/documents/api/s6/weather-now](https://www.heweather.com/documents/api/s6/weather-now)

用的请求URL如下:

```
https://free-api.heweather.com/s6/weather/now?location=广州&key=******
```

## 3.界面编写

在创建的工程里，有个`main.dart`里面有一段显示界面的代码如下:

```dart
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
```

其中`home` 就是要显示的界面，这里我们要把`MyHomePage`换成我们自己的。



### 3.1 创建WeatherWidget

通过 `new` -> `Dart File` 在lib目录下创建WeatherWidget

```dart
class WeatherWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new WeatherState();
  }
}

class WeatherState extends State<WeatherWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
    );
  }            
}
```

创建完后，在`main.dart`中将`home`改为`WeatherWidget`,如下:

```dart
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherWidget(),
    );
  }
```

在写UI的工程中，我们可以用到Flutter的hot reload的特性,写布局的时候，按`ctrl+s`或`cmd+s`就可以在手机上实时看到界面的变化。

### 3.2 写WeatherWidget的UI布局

在`Scaffold`中添加`body`的属性，来写UI的布局，如下：

```dart
class WeatherState extends State<WeatherWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image.asset("images/weather_bg.jpg",fit: BoxFit.fitHeight,),
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 40.0),
                child: new Text(
                  "广州市",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
              ),
              new Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 100.0),
                child: new Column(
                  children: <Widget>[
                    new Text(
                        "20 °",
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 80.0
                        )),
                    new Text(
                        "晴",
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 45.0
                        )),
                    new Text(
                      "湿度  80%",
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
```

按`ctrl+s`，在手机上就可以看到写好的UI，但这时候的数据是写死的，下来看如何通过http获取数据。

## 4.通过http获取数据

要通过http数据，我们首先要添加http的依赖库，在`pubspec.yaml`中的`dependencies`添加如下:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^0.1.2
  http: ^0.12.0
```

然后在当前工程目录下运行以下命令行：

```shell
$ flutter packages get
```

或者在Android Stuido 打开`pubspec.yaml` 文件，点击上面的`packages get`

这里操作的意义是，拉取http的库。

### 4.1 创建WeatherData类

通过 `new` -> `Dart File` 在lib目录下创建WeatherData

```dart
class WeatherData{
  String cond; //天气
  String tmp; //温度
  String hum; //湿度

  WeatherData({this.cond, this.tmp, this.hum});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cond: json['HeWeather6'][0]['now']['cond_txt'],
      tmp: json['HeWeather6'][0]['now']['tmp']+"°",
      hum: "湿度  "+json['HeWeather6'][0]['now']['hum']+"%",
    );
  }

  factory WeatherData.empty() {
    return WeatherData(
      cond: "",
      tmp: "",
      hum: "",
    );
  }
}
```

### 4.2 数据获取

```dart
class WeatherState extends State<WeatherWidget>{

  WeatherData weather = WeatherData.empty();

  WeatherState(){
    _getWeather();
  }

  void _getWeather() async{
    WeatherData data = await _fetchWeather();
    setState((){
      weather = data;
    });
  }

  Future<WeatherData> _fetchWeather() async{
    final response = await http.get('https://free-api.heweather.com/s6/weather/now?location=广州&key=ebb698e9bb6844199e6fd23cbb9a77c5');
    if(response.statusCode == 200){
      return WeatherData.fromJson(json.decode(response.body));
    }else{
      return WeatherData.empty();
    }
  }



  @override
  Widget build(BuildContext context) {
    ...
  }
}  
```

### 4.3 将之前写死的数据换成WeatherData

```dart
				...                
                child: new Column(
                  children: <Widget>[
                    new Text(
                        weather?.tmp,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 80.0
                        )),
                    new Text(
                        weather?.cond,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 45.0
                        )),
                    new Text(
                      weather?.hum,
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 30.0
                      ),
                    )
                  ],
                ),
                ...
```



