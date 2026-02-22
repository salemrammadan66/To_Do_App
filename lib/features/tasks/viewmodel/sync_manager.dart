import 'package:hive/hive.dart';

import '../model/task_model.dart';

class SyncManager {
  final Box<Task> box;

  SyncManager(this.box);

  Future<void> sync() async {
    final unsyncedTasks =
    box.values.where((task) => task.isSynced == false);

    for (var task in unsyncedTasks) {
      if (task.isDeleted) {
        // هنا تعمل API delete
        // await api.delete(task.id);

        await task.delete();
      } else if (task.id == null) {
        // هنا تعمل API create
        // final response = await api.create(task);

        // بعد ما السيرفر يرجع id
        // task.id = response.id;

        task.isSynced = true;
        await task.save();
      } else {
        // هنا تعمل API update
        // await api.update(task);

        task.isSynced = true;
        await task.save();
      }
    }
  }
}