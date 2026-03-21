import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/modules/providers/app_provider.dart';
import 'app/modules/services/notification_service.dart';
import 'app/modules/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const StudentManagerApp());
}

class StudentManagerApp extends StatelessWidget {
  const StudentManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..loadData(),
      child: MaterialApp(
        title: 'Student Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
