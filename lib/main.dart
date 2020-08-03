import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/providers/providers.dart';
import 'package:tasker/widgets/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialization for local notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = AndroidInitializationSettings("app_icon");
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DateProvider>.value(value: DateProvider()),
        ChangeNotifierProvider<PriorityProvider>.value(
          value: PriorityProvider(),
        ),
        ChangeNotifierProvider<TasksProvider>.value(value: TasksProvider()),
        ChangeNotifierProvider<DeletedTaskProvider>.value(
            value: DeletedTaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff1D3557),
          accentColor: Color(0xffA8DADC),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Tasker"),
          ),
          body: Column(
            children: <Widget>[
              Calendar(),
              Priorities(),
              Expanded(child: Tasks()),
            ],
          ),
          floatingActionButton: AddTaskBtn(),
        ),
      ),
    ),
  );
}

class Tasker extends StatefulWidget {
  @override
  _TaskerState createState() => _TaskerState();
}

class _TaskerState extends State<Tasker> {
  @override
  Widget build(BuildContext context) {
    return Tasks();
  }
}
