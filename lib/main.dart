// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class User {
  String email = "";
  String password = "";
  String gender = "male";
  bool agreePolicy = false;
  bool receiveEmail = false;

  User() {
    email;
    password;
    gender;
    agreePolicy;
    receiveEmail;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = "Form Validation";

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: CustomForm(),
      ),
    );
  }
}

class CustomForm extends StatefulWidget {
  const CustomForm({Key? key}) : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();
  User user = User();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: _buildInputDecoration(
                label: 'Email',
                hint: 'example@gmil.com',
                icon: Icons.email,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: validatorEmail,
              onSaved: (String? value) {
                user.email = value!;
              },
            ),
            TextFormField(
              decoration: _buildInputDecoration(
                label: 'Password',
                icon: Icons.lock,
              ),
              obscureText: true,
              validator: validatorPassword,
              onSaved: (String? value) {
                user.password = value!;
              },
            ),
            _buildGenderForm(),
            _buildReceiveEmailForm(),
            _buildAgreePolicyForm(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  String? validatorEmail(value) {
    if (value == null || value.isEmpty) {
      return 'The Email is Empty';
    }
    if (!isEmail(value)) {
      return "The Email must be a valid email.";
    }
    return null;
  }

  String? validatorPassword(value) {
    if (value!.length < 8) {
      return "Teh Password must be at lest 8 characters";
    }
    return null;
  }

  InputDecoration _buildInputDecoration(
      {required String label, String? hint, required IconData icon}) {
    return InputDecoration(labelText: label, hintText: hint, icon: Icon(icon));
  }

  Widget _buildGenderForm() {
    const Color activeColor = Colors.orange;

    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Text(
            "Gender",
            style: TextStyle(fontSize: 16),
          ),
          Radio(
            activeColor: activeColor,
            value: "male",
            groupValue: user.gender,
            onChanged: _handleRadioValueChange,
          ),
          Text("Male"),
          Radio(
            activeColor: activeColor,
            value: "female",
            groupValue: user.gender,
            onChanged: _handleRadioValueChange,
          ),
          Text("Female"),
        ],
      ),
    );
  }

  Widget _buildReceiveEmailForm() {
    return Row(
      children: [
        Text(
          "Receive Email",
          style: TextStyle(fontSize: 16),
        ),
        Switch(
            activeColor: Colors.orange,
            value: user.receiveEmail,
            onChanged: (select) {
              setState(() {
                user.receiveEmail = select;
              });
            })
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 4),
      child: RaisedButton(
        onPressed: _submit,
        color: Colors.blue,
        child: Text(
          "Submit",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAgreePolicyForm() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 32),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: user.agreePolicy,
            activeColor: Colors.orange,
            onChanged: (value) {
              setState(() {
                user.agreePolicy = value!;
              });
            },
          ),
          Text("I Agree the "),
          GestureDetector(
            onTap: _launchUrl,
            child: Text(
              "Privacy Policy",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _handleRadioValueChange(value) {
    print('value: ${value}');
    setState(() {
      user.gender = value;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (user.agreePolicy == false) {
        showAlertDialog();
      } else {
        _formKey.currentState!.save();

        print("Email: ${user.email}");
        print("Password: ${user.password}");
        print("Gender: ${user.gender}");
        print("ReceiveEmail: ${user.receiveEmail}");
        print("AgreePolicy: ${user.agreePolicy}");
      }
    }
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Title"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Detail1"),
                Text("Detail2"),
                Text("Detail3"),
                Icon(Icons.directions_walk)
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.cake,
                color: Colors.blue,
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _launchUrl() async {
    final Uri _url = Uri.parse('https://flutter.dev');
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
}
