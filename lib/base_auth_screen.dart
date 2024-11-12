import 'package:flutter/material.dart';
import 'helpers/auth_helper.dart';

abstract class BaseAuthScreen extends StatefulWidget {
  const BaseAuthScreen({Key? key}) : super(key: key);
}

abstract class BaseAuthScreenState<T extends BaseAuthScreen> extends State<T> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await AuthHelper.isLoggedIn();
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
