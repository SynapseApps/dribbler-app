import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'models/Assignment.dart';
import 'dart:convert';
import 'models/Subject.dart';
import 'styles.dart';
import 'screens/secondaryDashboard.dart';
import 'models/Module.dart' as mod;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/devInfo.dart';

void main() => runApp(MyApp());

class MyShape extends CustomPaint {

}

class MyApp extends StatelessWidget {
  static const String _title = 'Dribbler';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        cardColor: Color(0xFF202020),
      ),
      title: _title,
      home: MyStatelessWidget(),
    );
  }
}

class MyStatelessWidget extends StatefulWidget {
  MyStatelessWidget({Key key}) : super(key: key);

  @override
  _MyStatelessWidgetState createState() => _MyStatelessWidgetState();
}

class _MyStatelessWidgetState extends State<MyStatelessWidget>
    with TickerProviderStateMixin {
  final String urlAssignment =
      'https://dribbler.pythonanywhere.com/v1/assignment/';
  final String urlSubject = 'https://dribbler.pythonanywhere.com/v1/subject/';
  final String urlModule = 'https://dribbler.pythonanywhere.com/v1/module/';

  Assignment assignment;
  mod.Module module;
  SubjectEach newSubject;

  Future<String> fetchDataAssignment() async {
    var response = await http.get(urlAssignment);
    var jsonDecoded = jsonDecode(response.body);
    assignment = Assignment.fromJson(jsonDecoded);
    setState(() {});
    return "Success";
  }

  Future<String> fetchDataSubject() async {
    var response = await http.get(urlSubject);
    var jsonDecoded = jsonDecode(response.body);
    newSubject = SubjectEach.fromJson(jsonDecoded);
    setState(() {});
    return "Success";
  }

  Future<String> fetchDataModule() async {
    var response = await http.get(urlModule);
    //print(response.body);
    var jsonDecoded = jsonDecode(response.body);
    module = mod.Module.fromJson(jsonDecoded);
    setState(() {});
    return "Success";
  }

  void animationCard() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchDataSubject();
    fetchDataAssignment();
    fetchDataModule();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: new Icon(FontAwesomeIcons.dashcube),
          title: Text(
            'Dribbler',
          ),
          actions: <Widget>[
            new IconButton(
              icon: Icon(FontAwesomeIcons.dev),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => DevInfo()));
              },
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: newSubject == null
            ? Center(
                child: SpinKitFadingCube(
                  size: 40,
                  itemBuilder: (context, int index) {
                    return DecoratedBox(
                        decoration: BoxDecoration(
                      color: index.isEven ? Colors.white : Colors.grey,
                    ));
                  },
                ),
              )
            : ListView(
                scrollDirection: Axis.vertical,
                children: newSubject.results.map((eachResult) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    child: Container(
                        height: 100,
                        child: InkWell(
                          onTap: () {
                            // Pass the subject name and all its related items
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardModule(
                                          id: eachResult.id,
                                          title: eachResult.name,
                                          assignment: assignment,
                                          module: module,
                                        )));
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(0.0)),
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 4.0,
                                child: Center(
                                    child: new Text(
                                  eachResult.name,
                                  style: cardTitle,
                                ))),
                          ),
                        )),
                  );
                }).toList(),
              ),
        bottomSheet: new Container(
          height: 20,
          alignment: Alignment.bottomCenter,
          color: Colors.black,
          child: new Text(
            "Version 1.0.0",
            style: TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }
}
