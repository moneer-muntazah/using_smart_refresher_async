import 'package:flutter/material.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  final items = <String>[];

  final _refreshController =
      RefreshController(initialRefresh: true);

  void loadData() async {
    String x = await Future<String>.delayed(
        Duration(seconds: 2), () => (++counter).toString());
    items.add(x);
    setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        // header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            print(mode);
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            }
            // else if(mode==LoadStatus.loading){
            //   body =  CupertinoActivityIndicator();
            // }
            else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: loadData,
        onLoading: loadData,
        child: GridView.builder(
          itemBuilder: (c, i) {
            return Card(child: Center(child: Text(items[i])));
          },
          // itemExtent: 100.0,
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 2.12,
          ),
        ),
      ),
    );
  }
}
