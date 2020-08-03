import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:tasker/models/task.dart';
import 'package:tasker/providers/providers.dart';
import 'package:tasker/widgets/addTask.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    final DateProvider dateProvider = Provider.of<DateProvider>(context);
    final PriorityProvider priorityProvider =
        Provider.of<PriorityProvider>(context);
    final TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    final DeletedTaskProvider deletedTaskProvider =
        Provider.of<DeletedTaskProvider>(context);
    return FutureBuilder(
      future: tasksProvider.tasks,
      builder: (context, snapshot) => snapshot.hasData
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: snapshot.data.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Task _task = snapshot.data[index];
                        return Dismissible(
                          key: UniqueKey(),
                          child: Card(
                            color: _task.isDone
                                ? Colors.greenAccent
                                : Theme.of(context).accentColor,
                            child: ListTile(
                                trailing: _task.remainder != null
                                    ? Icon(Icons.alarm)
                                    : null,
                                leading: _task.priority == 0
                                    ? Icon(FlutterIcons.fire_sli)
                                    : _task.priority == 1
                                        ? Icon(FlutterIcons.weather_windy_mco)
                                        : Icon(FlutterIcons.cloud_drizzle_fea),
                                title: Text(_task.title),
                                subtitle: _task.description.isEmpty
                                    ? null
                                    : Text(_task.description),
                                onTap: () async {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: AddTask(_task),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                  ).then((value) {
                                    tasksProvider.refresh(dateProvider.time,
                                        priorityProvider.selectedPriorities);
                                  });
                                }),
                          ),
                          background: Container(
                            color: _task.isDone
                                ? Colors.amberAccent
                                : Colors.greenAccent,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Icon(
                                  _task.isDone ? Icons.refresh : Icons.check),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          secondaryBackground: Container(
                            color: Colors.redAccent,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.delete),
                            ),
                            alignment: Alignment.centerRight,
                          ),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              _task.isDone = !_task.isDone;
                              tasksProvider.update(_task.id, _task);
                              tasksProvider.refresh(dateProvider.time,
                                  priorityProvider.selectedPriorities);
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              deletedTaskProvider.updateDeletedTask = _task;
                              tasksProvider.delete(_task.id);
                              if (_task.remainder != null) {
                                await removeScheduleNotification(_task.id);
                              }
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("${_task.title} is deleted"),
                                action: SnackBarAction(
                                    label: "Undo",
                                    onPressed: () {
                                      if (deletedTaskProvider
                                              .deletedTask.remainder !=
                                          null) {
                                        scheduleNotification(
                                          deletedTaskProvider
                                              .deletedTask.remainder,
                                          deletedTaskProvider.deletedTask,
                                        );
                                      }
                                      tasksProvider.saveagain(
                                        deletedTaskProvider.deletedTask,
                                      );
                                      tasksProvider.refresh(
                                        dateProvider.time,
                                        priorityProvider.selectedPriorities,
                                      );
                                    }),
                              ));
                              tasksProvider.refresh(dateProvider.time,
                                  priorityProvider.selectedPriorities);
                            }
                          },
                        );
                      })
                  : Center(
                      child: Text(
                        "No tasks!",
                        style: TextStyle(
                          fontSize: 20 * MediaQuery.of(context).textScaleFactor,
                        ),
                      ),
                    ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future scheduleNotification(DateTime notificationTime, Task task) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'tasker_v2',
      'tasker',
      'tasker notifications',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      task.id,
      task.title,
      task.description,
      notificationTime,
      platformChannelSpecifics,
    );
  }

  Future removeScheduleNotification(int id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
