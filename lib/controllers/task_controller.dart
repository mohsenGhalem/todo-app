import 'package:get/get.dart';
import 'package:to_do_app_v2/db/db_helper.dart';
import 'package:to_do_app_v2/models/task.dart';

import '../services/notification_services.dart';

class TaskController extends GetxController {
  RxList taskList = <Task>[].obs;
  DBHelper dbHelper = DBHelper();

  Future<void> getTasks() async {
    final tasks = await dbHelper.query();

    taskList.assignAll(tasks.map((e) => Task.fromMap(e)).toList());

    update();
  }

  void addTask({required Task? task}) async {
    await dbHelper.insert(task);
    getTasks();
  }

  void deleteask({required Task task}) async {
    await dbHelper.delete(task.id!);
    getTasks();
  }

  void markTaskAsCompleted({required Task task}) async {
    var value = await dbHelper.update(task.id!);
    getTasks();
  }

  void deleteAllTask() async {
    await NotifyHelper.cancelAllNotififcation();
    await dbHelper.deleteAll();
    taskList.clear();
    update();
  }
}
