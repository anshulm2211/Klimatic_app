import 'package:flutter/material.dart';

final apiId = "your api id";
final defaultCity='Bangalore';
final defaultUnit='metric';

class search_city extends StatelessWidget {

  var _city=new TextEditingController();
  int flag=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
            'Klimatic',
            style: new TextStyle(color: Colors.black,fontSize: 25, fontStyle: FontStyle.normal),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),

          new Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 200)),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter the city',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _city,
                ),
              ),

              new ListTile(
                title: new FlatButton(
                    onPressed: (){flag=0;},
                    child: new Text(
                      'Celcius',
                      style: new TextStyle(fontStyle: FontStyle.italic),
                    )
                ),
              ),

              new ListTile(
                title: new FlatButton(
                    onPressed: (){flag=1;},
                    child: new Text(
                        'Fahrenheit',
                        style: new TextStyle(fontStyle: FontStyle.italic),
                    )
                ),
              ),

              new ListTile(
                title: new FlatButton(
                  onPressed: (){
                    Navigator.pop(context,
                        {'enter':_city.text, 'units':flag==0?'metric':'imperial'}
                    );
                    print('Searched');
                  },
                  child: new Text(
                    'Enter',
                    style: new TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  color: Colors.black12,
                  textColor: Colors.black87,
                ),

              )

            ],
          )
        ],
      ),
    );
  }
}


