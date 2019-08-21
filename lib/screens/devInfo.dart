import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DevInfo extends StatefulWidget {
  @override
  _DevInfoState createState() => _DevInfoState();
}

class _DevInfoState extends State<DevInfo> {
  instagramLaunch() async {
    const url = 'https://www.instagram.com/ajjusingh._/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  twitterLaunch() async {
    const url = 'https://www.twitter.com/cloudmaxio';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  linkedinLaunch() async {
    const url = 'https://www.linkedin.com/in/ajay-kumar-singh-737182154/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: new Text("Developer"),
        ),
        body: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                FontAwesomeIcons.dashcube,
                size: 100,
              ),
              SizedBox(
                height: 20,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                                      child: new Image(
                      image: AssetImage('assets/dropbox.png'),
                      height: 100,
                    ),
                  ),
                  Expanded(
                                      child: new Image(
                      color: Colors.white,
                      image: AssetImage('assets/django.png'),
                      height: 100,
                    ),
                  ),
                ],
              ),
              FlutterLogo(
                size: 80
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          color: Colors.black,
          height: 70,
          child: Column(children: [
            new Text(
              "Developed By - Ajay Kumar Singh",
              style: TextStyle(fontSize: 15),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.twitter),
                  onPressed: () {
                    twitterLaunch();
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.instagram),
                  onPressed: () {
                    instagramLaunch();
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.linkedin),
                  onPressed: () {
                    linkedinLaunch();
                  },
                ),
              ],
            )
          ]),
        ));
  }
}
