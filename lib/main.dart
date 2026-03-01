import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/features/Auth/view/login_page.dart';
import 'package:to_do_app/features/Auth/view/signin_page.dart';
import 'Settings/App_Colors.dart';
import 'features/Auth/view/welcome.dart';
import 'features/Auth/viewmodel/authProvider.dart';
import 'features/tasks/model/task_model.dart';
import 'features/tasks/repository/task_RemoteDataSource.dart';
import 'features/tasks/repository/task_api_service.dart';
import 'features/tasks/repository/task_localDataSource.dart';
import 'features/tasks/repository/task_repository.dart';
import 'features/tasks/view/HomePage.dart';
import 'features/tasks/viewmodel/prov.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  final taskBox = Hive.box<Task>('tasks');

  final localDataSource = TaskLocalDataSource(taskBox);
  final remoteDataSource = TaskRemoteDataSource(TaskApiService());

  final repository = TaskRepository(
    local: localDataSource,
    remote: remoteDataSource,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider(repository)),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColors.bodyColor),
      initialRoute: "welcome",
      routes: {
        "home": (context) => Homepage(),
        "login": (context) => LoginPage(),
        "register": (context) => SigninPage(),
        "welcome": (context) => Welcome(),
      },
    );
  }
}
