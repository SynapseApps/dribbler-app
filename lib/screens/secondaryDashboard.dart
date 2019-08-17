import 'package:dribbler_app/models/Assignment.dart';
import 'package:dribbler_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:dribbler_app/models/Module.dart' as mod;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

class DashboardModule extends StatefulWidget {
  final String title;
  final Assignment assignment;
  final int id;
  final mod.Module module;
  DashboardModule({Key key, this.title, this.assignment, this.module, this.id})
      : super(key: key);

  @override
  _DashboardModuleState createState() => _DashboardModuleState();
}

class _DashboardModuleState extends State<DashboardModule>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> data = new List();
  TabController _controller;
  Set index = new Set();

  GlobalKey<ScaffoldState> scaffold = new GlobalKey<ScaffoldState>();

  String pathOfStorage;

  void fetchAssignment() async {
    for (var i in widget.assignment.results) {
      if (i.subjectAssignment.perSubject.name == widget.title) {
        data.add({
          "id": i.subjectAssignment.id,
          "description": i.description,
          "link": i.link,
          "uploaded_on": i.uploadedOn,
          "module": i.subjectAssignment.number
        });
      }
    }

    for (var i in widget.module.results) {
      if (i.perSubject == widget.id) {
        index.add(i.number);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAssignment();
    setState(() {
      _controller =
          new TabController(length: index.length, vsync: this, initialIndex: 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: new Text(widget.title),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: widget.assignment == null
              ? new SpinKitFadingCube(
                  size: 40,
                  itemBuilder: (context, int index) {
                    return DecoratedBox(
                        decoration: BoxDecoration(
                      color: index.isEven ? Colors.white : Colors.grey,
                    ));
                  })
              : ListView(
                  children: index.map((eachModule) {
                  return ExpansionTile(
                    title: new Text("Module $eachModule"),
                    children: data.map((eachAssignment) {
                      if (eachAssignment["module"] == eachModule) {
                        return BuildModuleList(
                          eachAssignment: eachAssignment,
                        );
                      }
                      return SizedBox();
                    }).toList(),
                  );
                }).toList()),
        ),
      ),
    );
  }
}

class BuildModuleList extends StatefulWidget {
  final Map<String, dynamic> eachAssignment;

  BuildModuleList({Key key, this.eachAssignment}) : super(key: key);

  @override
  _BuildModuleListState createState() => _BuildModuleListState();
}

class _BuildModuleListState extends State<BuildModuleList> {
  CustomCacheManager cacheManager = CustomCacheManager();

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  bool isDownloaded = false;

  void getStatus() async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance();
    isDownloaded = await mmkv
        .getBool(widget.eachAssignment["description"] + 'isDownloaded');
    print(isDownloaded);
    setState(() {});
  }

  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            isDownloading == true
                ? new Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: new LinearProgressIndicator())
                : new SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: new Text(
                    widget.eachAssignment["description"],
                    style: assignmentCard,
                  ),
                ),

                // Open a file button
                isDownloaded
                    ? IconButton(
                        icon: Icon(FontAwesomeIcons.filePdf),
                        onPressed: () async {
                          MmkvFlutter mmkv = await MmkvFlutter.getInstance();
                          String pathOfFile = await mmkv
                              .getString(widget.eachAssignment["description"]);
                          print(pathOfFile);
                          OpenFile.open(pathOfFile);
                        },
                      )
                    : SizedBox(),

                // Download the file button
                IconButton(
                  icon: new Icon(FontAwesomeIcons.download),
                  onPressed: () async {
                    setState(() {
                      isDownloading = true;
                    });
                    MmkvFlutter mmkv = await MmkvFlutter.getInstance();
                    var fetchedFile =
                        cacheManager.getFile(widget.eachAssignment["link"]);
                    fetchedFile.listen((data) async {
                      await mmkv.setString(widget.eachAssignment["description"],
                          data.file.path.toString());
                      await mmkv.setBool(
                          widget.eachAssignment["description"] + 'isDownloaded',
                          true);
                      getStatus();
                      setState(() {
                        isDownloading = false;
                      });
                    });
                  },
                ),
              ],
            ),
            new Text(
              widget.eachAssignment["uploaded_on"],
              style: TextStyle(fontSize: 10, color: Color(0x90FFFFFF)),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCacheManager extends BaseCacheManager {
  static const key = "documents";

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._()
      : super(key,
            maxAgeCacheObject: Duration(days: 365),
            maxNrOfCacheObjects: 20,
            fileFetcher: _customHttpGetter);

  Future<String> getFilePath() async {
    var directory = await getExternalStorageDirectory();
    //return join(directory.path, key);
    return join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url,
      {Map<String, String> headers}) async {
    // Do things with headers, the url or whatever.
    return HttpFileFetcherResponse(await http.get(url, headers: headers));
  }
}
