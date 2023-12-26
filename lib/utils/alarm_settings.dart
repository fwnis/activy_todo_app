import 'package:alarm/model/alarm_settings.dart';

AlarmSettings alarmSettings(String taskName, int time, DateTime date, int id) {
  return AlarmSettings(
    id: id,
    dateTime: date,
    assetAudioPath: 'assets/alarm.mp3',
    loopAudio: false,
    vibrate: true,
    volumeMax: true,
    fadeDuration: 3.0,
    notificationTitle: "ACTIVY Reminder",
    notificationBody: "Task $taskName is ${time == 0 ? 'now!' : 'in $time minutes!'}",
    enableNotificationOnKill: true,
  );
}
