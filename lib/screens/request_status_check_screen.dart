import 'package:flutter/material.dart';

class RequestStatusCheckScreen extends StatefulWidget {
  const RequestStatusCheckScreen({Key? key});

  @override
  _RequestStatusCheckScreen createState() => _RequestStatusCheckScreen();
}

class _RequestStatusCheckScreen extends State<RequestStatusCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('ваша заявка в обработке')));
  }
}
