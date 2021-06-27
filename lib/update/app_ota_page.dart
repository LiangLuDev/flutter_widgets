import 'package:flutter/material.dart';
// import 'package:ota_update/ota_update.dart';
import 'package:update_app/update_app.dart';

class AppOtaPage extends StatefulWidget {
  @override
  _AppOtaPageState createState() => _AppOtaPageState();
}

class _AppOtaPageState extends State<AppOtaPage> {
  // OtaEvent currentEvent;


  void download() async {
    var name = await UpdateApp.updateApp(
        url: "https://internal1.4q.sk/flutter_hello_world.apk", appleId: "375380948");
    print(name);

    setState(() {});
  }

  // Future<void> tryOtaUpdate() async {
  //   try {
  //     //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
  //     OtaUpdate()
  //         .execute(
  //       'https://internal1.4q.sk/flutter_hello_world.apk',
  //       destinationFilename: 'flutter_hello_world.apk',
  //       //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
  //       // sha256checksum:
  //       //     'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478',
  //     )
  //         .listen(
  //       (OtaEvent event) {
  //         setState(() => currentEvent = event);
  //       },
  //     );
  //     // ignore: avoid_catches_without_on_clauses
  //   } catch (e) {
  //     print('Failed to make OTA update. Details: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            FlatButton(
                onPressed: () {
                  download();
                },
                child: Text('start ota')),
            // Container(
            //   child: Text(
            //       'OTA status: ${currentEvent?.status} : ${currentEvent?.value} \n'),
            // ),
          ],
        ),
      ),
    );
  }
}
