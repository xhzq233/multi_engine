import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(Directionality(
    textDirection: TextDirection.ltr,
    child: ColoredBox(
      color: Colors.black26,
      child: ListView(
        children: [
          Align(
            child: GestureDetector(
              onTap: SystemNavigator.pop,
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Align(
            child: GestureDetector(
              onTap: SystemNavigator.pop,
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Align(
            child: GestureDetector(
              onTap: SystemNavigator.pop,
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Align(
            child: GestureDetector(
              onTap: SystemNavigator.pop,
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Align(
            child: GestureDetector(
              onTap: SystemNavigator.pop,
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
        ],
      ),
    ),
  ));
}
