import 'package:criclive/screens/matchDetails.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'PUC India',
      initialRoute: Dashboard.id,
      routes: {
        Dashboard.id: (context) => const Dashboard(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
