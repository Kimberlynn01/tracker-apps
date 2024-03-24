// ignore_for_file: deprecated_member_use

import 'package:course_udemy_expense_tracker_app/firebase_options.dart';
import 'package:course_udemy_expense_tracker_app/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData().copyWith(
          backgroundColor: const Color(0xFF392C4D),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
        ),

        primaryColor: Colors.white,
        hintColor: Colors.white,
        canvasColor: const Color(0xFFA3A0A0), // img login / register color
        backgroundColor: const Color(0xFF392C4D),
        primaryColorDark: const Color(0xFF392C4D),
        indicatorColor: const Color.fromARGB(255, 48, 38, 75),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: const Color(0xFF392C4D),
        ),
        cardColor: const Color.fromARGB(255, 48, 38, 75),
        cardTheme: const CardTheme().copyWith(
          color: const Color.fromARGB(255, 57, 39, 108),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 53, 35, 91),
            ),
          ),
        ),
        primaryColorLight: const Color(0xFF2E1F45), // color for modal
        snackBarTheme: const SnackBarThemeData().copyWith(
            backgroundColor: const Color.fromARGB(255, 72, 59, 96),
            actionTextColor: Colors.white),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFF392C4D),
          filled: true,
          iconColor: Colors.white,
          focusColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      theme: ThemeData(
        useMaterial3: true,
      ).copyWith(
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: const Color(0xFF6200EA),
        ),
        cardColor: const Color(0xFF7C4DFF),
        cardTheme: const CardTheme().copyWith(
          color: Colors.deepPurpleAccent[200],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              Colors.deepPurpleAccent[400],
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData().copyWith(
            backgroundColor: Colors.deepPurple[300],
            actionTextColor: Colors.white),
        backgroundColor: const Color(0xff7C4DFF),
        primaryColor: const Color.fromARGB(255, 71, 69, 74),
        canvasColor: const Color(0xff777575), // img login / register color
        primaryColorLight: const Color(0xff2F2341), // color for modal
        primaryColorDark: Colors.deepPurple[700],
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Color(0xff7C4DFF),
        ),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData().copyWith(
          backgroundColor: const Color(0xff7C4DFF),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
        ),
        hintColor: Colors.black,
        listTileTheme: ListTileThemeData().copyWith(
          iconColor: Colors.white,
          textColor: Colors.white,
        ),
        indicatorColor: Colors.deepPurpleAccent[700],
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xff7C4DFF),
          filled: true,
          iconColor: Colors.white,
          focusColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.white,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
      home: const Login(),
    ),
  );
}
