import 'package:flutter/material.dart';
import 'package:klimatic_app/util/util.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String _cityEntered;
  String _units;

  void showStuff() async{
    Map data= await getWeather(util.apiId, util.defaultCity,_units);
    print(data['main']);
    //return data['main'];
  }

  Future _goToNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context){
        return new util.search_city();
      })
    );

    setState(() {
      if(results != null && results.containsKey('enter')){
        _cityEntered=results['enter'];
        _units=results['units'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            'Klimatic',
            style: new TextStyle(color: Colors.black, fontSize: 25, fontStyle: FontStyle.normal),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.search),
            color: Colors.black,
            onPressed: (){
              _goToNextScreen(context);
            },
          )
        ],
      ),

      // we will have to put contents one top of another,
      // so stack widget can be used,
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',
              width: 490.0,
              fit: BoxFit.fill,
              height: 1200.0,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
                '${_cityEntered == null ? util.defaultCity.toUpperCase():_cityEntered.toUpperCase()}',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                ),
            ),
          ),
          
//          new Container(
//            alignment: Alignment.center,
//            child: new Image.asset('images/light_rain.png'),
//          ),

          // to have weather data
          new Container(
            margin: const EdgeInsets.fromLTRB(30, 395, 0, 0),
            child: updateTempWidget(_cityEntered,_units),
          )
        ],
      ),

    );
  }

  Future<Map> getWeather(String apiId, String city, String units) async{
    String apiUrl='http://api.openweathermap.org/data/2.5/weather?'
        'q=$city&appid=${util.apiId}&units=${units==null?util.defaultUnit:units}';
    http.Response response=await http.get(apiUrl);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city, String units){
    return new FutureBuilder(
        future: getWeather(util.apiId, city == null ? util.defaultCity:city,units),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
          // where we can get all json data
          //print(context);
          //print(snapshot);
          if(snapshot.hasData){
            Map content=snapshot.data;
            return new Container(
              child: new Column(
                children: <Widget>[
                  new Padding(padding: const EdgeInsets.all(5)),
                  new ListTile(
                    title: new Text("   " +content['main']['temp'].toString() + "${_units=='imperial'?' F':' C'}",
                      style: new TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),

                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        "     Feels Like: ${content['main']['feels_like'].toString() + "${_units=='imperial'?' F':' C'}"}\n"
                            "     Min: ${content['main']['temp_min'].toString() + "${_units=='imperial'?' F':' C'}"}\n"
                              "     Max: ${content['main']['temp_max'].toString() + "${_units=='imperial'?' F':' C'}"}\n"
                                "     Humidity: ${content['main']['humidity'].toString() }\n"
                                  "     Weather: ${content['weather'][0]['description'].toString() }\n"
                                    "     Country: ${content['sys']['country'].toString() }\n",
                        style: new TextStyle(color: Colors.white, fontStyle: FontStyle.italic,fontWeight: FontWeight.w400),

                      ),
                    ),
                  )
                ],
              )
            );
          }
          else{
            return new Container();
          }
        }
    );
  }
}


