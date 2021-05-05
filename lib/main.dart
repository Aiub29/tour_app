import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_app/pages/home_page.dart';
import 'package:tour_app/pages/launcher_page.dart';
import 'package:tour_app/pages/login_page.dart';
import 'package:tour_app/pages/nearby_page.dart';
import 'package:tour_app/pages/new_tour_page.dart';
import 'package:tour_app/pages/tour_details_page.dart';
import 'package:tour_app/pages/weather_page.dart';
import 'package:tour_app/providers/nearby_provider.dart';
import 'package:tour_app/providers/tour_provider.dart';
import 'package:tour_app/providers/weather_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TourProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        ChangeNotifierProvider(create: (context) => NearbyProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: Colors.transparent,
          ),
          primarySwatch: Colors.blue,
        ),
        home: LauncherPage(),
        routes: {
          LauncherPage.routName :(context) => LauncherPage(),
          LoginPage.routName :(context) => LoginPage(),
          HomePage.routName :(context) => HomePage(),
          NewTourPage.routName :(context) => NewTourPage(),
          TourDetailsPage.routName :(context) => TourDetailsPage(),
          WeatherPage.routName :(context) => WeatherPage(),
          NearbyPage.routName :(context) => NearbyPage(),

        },
      ),
    );
  }
}

