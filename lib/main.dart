import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'core/notifications/notification_service.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/theme_provider.dart';
import 'features/Auth/view/login_page.dart';
import 'features/Auth/view/profile_page.dart';
import 'features/Auth/view/signin_page.dart';
import 'features/Auth/view/welcome.dart';
import 'features/Auth/viewmodel/auth_provider.dart';
import 'features/settings/view/settings_page.dart';
import 'features/tasks/view/root_shell.dart';
import 'features/tasks/model/task_model.dart';
import 'features/tasks/repository/task_remote_data_source.dart';
import 'features/tasks/repository/task_api_service.dart';
import 'features/tasks/repository/task_local_data_source.dart';
import 'features/tasks/repository/task_repository.dart';
import 'features/tasks/view/calendar_page.dart';
import 'features/tasks/view/home_page.dart';
import 'features/tasks/viewmodel/prov.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  final taskBox = Hive.box<Task>('tasks');

  final apiClient = ApiClient();

  final localDS = TaskLocalDataSource(taskBox);
  final apiService = TaskApiService(apiClient);
  final remoteDS = TaskRemoteDataSource(apiService);
  final repository = TaskRepository(local: localDS, remote: remoteDS);

  final authBox = await Hive.openBox('authBox');
  final savedToken = authBox.get('token');
  final bool isLoggedIn = savedToken != null;

  if (isLoggedIn) {
    apiClient.setToken(savedToken);
  }

  final settingsBox = await Hive.openBox('settingsBox');
  AppColors.isDark = settingsBox.get('isDark', defaultValue: false);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider(repository)),
        ChangeNotifierProvider(create: (_) => AuthProvider(apiClient)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(initialRoute: isLoggedIn ? "home" : "welcome"),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.bodyColor),
      initialRoute: widget.initialRoute,
      routes: {
        "home": (context) => RootShell(),
        "login": (context) => LoginPage(),
        "register": (context) => SigninPage(),
        "welcome": (context) => Welcome(),
        "profile": (context) => ProfilePage(),
        "calendar": (context) => CalendarPage(),
        "settings": (context) => SettingsPage(),
      },
    );
  }
}
