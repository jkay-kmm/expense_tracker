import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:expense_tracker/pages/signup.dart';
import 'package:expense_tracker/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // print("Initializing database...");
  await ExpenseDatabase.initialize();
  // print("Database initialized");
  runApp(ChangeNotifierProvider(
    create: (content) => ExpenseDatabase(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
