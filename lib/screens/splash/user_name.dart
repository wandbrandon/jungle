import 'package:jungle/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:flutter/material.dart';

class UserName extends StatefulWidget {
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    models.User currentUser = context.watch<models.User>();
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "First Name",
              ),
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Add Name"),
            ),
          ],
        ),
      ),
    );
  }
}
