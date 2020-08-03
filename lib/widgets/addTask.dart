import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:tasker/models/db.dart';
import 'package:tasker/models/task.dart';
import 'package:date_format/date_format.dart';
import 'package:tasker/providers/dateProvider.dart';

class AddTask extends StatefulWidget {
  Task task;
  AddTask([this.task]);
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _priority = 0;
  var db;
  DateTime _remainderTime;

  @override
  void initState() {
    super.initState();
    db = DB();
    if (widget.task != null) {
      _titleController.text = widget.task.title;
      _descriptionController.text = widget.task.description;
      _priority = widget.task.priority;
      _remainderTime = widget.task != null ? widget.task.remainder : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateProvider dateProvider = Provider.of<DateProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title of the task",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value.isEmpty ? "This field is required" : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Small note about task",
                  border: OutlineInputBorder(),
                ),
                maxLength: 100,
                maxLines: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Priority",
                    style: TextStyle(
                      fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    avatar: Icon(
                      FlutterIcons.fire_sli,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Top",
                      style: TextStyle(color: Colors.white),
                    ),
                    selected: _priority == 0,
                    onSelected: (value) => setState(() {
                      _priority = 0;
                    }),
                    backgroundColor: Theme.of(context).primaryColor,
                    selectedColor: Color(0xff457B9D),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    avatar: Icon(
                      FlutterIcons.weather_windy_mco,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Medium",
                      style: TextStyle(color: Colors.white),
                    ),
                    selected: _priority == 1,
                    onSelected: (value) => setState(() {
                      _priority = 1;
                    }),
                    backgroundColor: Theme.of(context).primaryColor,
                    selectedColor: Color(0xff457B9D),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    avatar: Icon(
                      FlutterIcons.cloud_drizzle_fea,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Low",
                      style: TextStyle(color: Colors.white),
                    ),
                    selected: _priority == 2,
                    onSelected: (value) => setState(() {
                      _priority = 2;
                    }),
                    backgroundColor: Theme.of(context).primaryColor,
                    selectedColor: Color(0xff457B9D),
                  ),
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.alarm),
                        SizedBox(width: 10),
                        Text(
                          _remainderTime != null
                              ? formatDate(
                                  _remainderTime,
                                  [
                                    'h',
                                    ' : ',
                                    'n',
                                    ' ',
                                    'am',
                                    ', ',
                                    'd',
                                    ' ',
                                    'MM',
                                    ' ',
                                    'yyyy'
                                  ],
                                )
                              : "Tap here to choose remainder",
                          style: TextStyle(
                            fontSize:
                                16 * MediaQuery.of(context).textScaleFactor,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: _remainderTime != null
                            ? TimeOfDay(
                                hour: _remainderTime.hour,
                                minute: _remainderTime.minute,
                              )
                            : TimeOfDay.now(),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            _remainderTime = DateTime(
                              dateProvider.time.year,
                              dateProvider.time.month,
                              dateProvider.time.day,
                              value.hour,
                              value.minute,
                            );
                          });
                        }
                      });
                    },
                  ),
                  _remainderTime != null
                      ? IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _remainderTime = null;
                            });
                          },
                        )
                      : SizedBox(width: 0, height: 0),
                ]),
            SizedBox(
              height: 10,
            ),
            RaisedButton.icon(
              icon: widget.task == null ? Icon(Icons.add) : Icon(Icons.update),
              label: Text(widget.task == null ? "Add Task" : "Update"),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (widget.task == null) {
                    Task task = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      priority: _priority,
                      createdOn: formatDate(
                        dateProvider.time,
                        ['d', ' ', 'M', ' ', 'yyyy'],
                      ),
                      remainder: _remainderTime,
                    );
                    task = await db.save(task);
                    if (task.remainder != null) {
                      await scheduleNotification(task.remainder, task);
                    }
                  } else {
                    widget.task.title = _titleController.text;
                    widget.task.description = _descriptionController.text;
                    widget.task.priority = _priority;
                    if (widget.task.remainder != _remainderTime &&
                        widget.task.remainder != null) {
                      await cancelScheduleNotification(widget.task.id);
                    }
                    widget.task.remainder = _remainderTime;

                    await db.update(widget.task.id, widget.task);
                    if (widget.task.remainder != null) {
                      await scheduleNotification(
                          widget.task.remainder, widget.task);
                    }
                  }
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
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

  Future cancelScheduleNotification(int id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
