import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tasker/providers/providers.dart';

class Priorities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateProvider dateProvider = Provider.of<DateProvider>(context);
    final PriorityProvider priorityProvider =
        Provider.of<PriorityProvider>(context);
    final TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    return ChipsChoice<int>.multiple(
      value: priorityProvider.selectedPriorities,
      options: ChipsChoiceOption.listFrom<int, String>(
        source: priorityProvider.priorityTags,
        value: (i, v) => i,
        label: (i, v) => v,
      ),
      onChanged: (val) => priorityProvider.updatePriorities = val,
      itemBuilder: (item, selected, select) => GestureDetector(
        onTap: () {
          select(!selected);
          tasksProvider.refresh(
              dateProvider.time, priorityProvider.selectedPriorities);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Chip(
            label: Text(item.label),
            avatar: item.value == 0
                ? Icon(
                    FlutterIcons.fire_sli,
                    size: 16,
                    color: Colors.white,
                  )
                : item.value == 1
                    ? Icon(
                        FlutterIcons.weather_windy_mco,
                        size: 16,
                        color: Colors.white,
                      )
                    : Icon(
                        FlutterIcons.cloud_drizzle_fea,
                        size: 16,
                        color: Colors.white,
                      ),
            backgroundColor:
                selected ? Color(0xff457B9D) : Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
