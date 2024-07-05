import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssbiproject/Login_Screen/Registration_Screen.dart';
import 'package:ssbiproject/Other_screen/APIs_Screen.dart';
import 'package:ssbiproject/Other_screen/Static_varible.dart';
import 'package:ssbiproject/Other_screen/Url_Screen.dart';
import 'package:ssbiproject/Screen/Bottom_Screen.dart';
import 'package:ssbiproject/Setting/Constvariable.dart';

class Login_Screen extends StatefulWidget {
  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _tempurlController = TextEditingController();
  final TextEditingController _usercontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  bool ishidepassword = true;
  final LogAPIs Apiservice = LogAPIs();
  bool _uservalidate = false;
  bool _passvalidate = false;
  String _errorMessage = '';

  List<Map<String, dynamic>> _urls = [];

  void dispose() {
    _usercontroller.dispose();
    _passcontroller.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    Map<String, dynamic>? url = await fetchData();
    if (url != null) {
      setState(() {
        _urlController.text = url['url'] ?? '';
        _tempurlController.text = url['url'] ?? '';
        staticverible.temqr = url['url'] ?? '';
      });
    }
  }

  Future<Map<String, dynamic>?> fetchData() async {
    List<Map<String, dynamic>>? urls = await DatabaseHelper.getUrls();
    setState(() {
      _urls = urls ?? [];
    });
    return _urls.isNotEmpty ? _urls.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 136, 109, 232),
                  Color.fromARGB(255, 167, 127, 197),
                ]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Color(ColorVal),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => UrlScreen()));
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _usercontroller,
                        decoration: InputDecoration(
                            errorText: _uservalidate
                                ? 'Please Enter The User Name '
                                : null,
                            label: Text(
                              'User Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(ColorVal),
                              ),
                            )),
                      ),
                      TextField(
                        obscureText: ishidepassword,
                        controller: _passcontroller,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                                child: Icon(Icons.visibility),
                                onTap: _togglepasswordview),
                            errorText: _passvalidate
                                ? 'Please Enter The Password'
                                : null,
                            label: Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(ColorVal),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff281537),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          InkWell(
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(ColorVal)),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                setState(() {
                                  _uservalidate = _usercontroller.text.isEmpty;
                                  _passvalidate = _passcontroller.text.isEmpty;
                                });

                                if (_uservalidate || _passvalidate) {
                                  // Show error message for empty username or password
                                  return;
                                }
                                // Show a loading indicator while logging in

                                // Perform login action

                                // Completer<void> completer = Completer<void>();
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(
                                //       SnackBar(
                                //         content: Row(
                                //           children: [
                                //             CircularProgressIndicator(),
                                //             SizedBox(width: 10),
                                //             Text("Please wait..."),
                                //           ],
                                //         ),
                                //         duration: Duration(seconds: 2),
                                //         backgroundColor: Colors.blue,
                                //       ),
                                //     )
                                //     .closed
                                //     .then((reason) {
                                //   completer.complete();
                                //   // Complete the Future when the SnackBar is closed
                                // });

                                // Perform additional actions or navigate to a new screen if needed
                                // ...
                                //  await _login();

                                // Wait for 2 seconds and then hide the loading indicator
                                // await Future.delayed(Duration(seconds: 2));

                                // // Hide the SnackBar
                                // ScaffoldMessenger.of(context)
                                //     .hideCurrentSnackBar();

                                if (_urlController.text.isEmpty) {
                                  if (_tempurlController.text.isNotEmpty) {
                                    // Temporary URL is not empty, but main URL is empty
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Temporary URL is not empty, but main URL is empty."),
                                        duration: Duration(seconds: 3),
                                        action: SnackBarAction(
                                          label: 'OK',
                                          onPressed: () {},
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                } else if (_urlController.text !=
                                    _tempurlController.text) {
                                  // Main URL and Temporary URL do not match

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Please check URL"),
                                      duration: Duration(seconds: 3),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {},
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                // If the login is successful, hide the loading indicator
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Bottom_Screen()));
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            child: Container(
                              child: Center(
                                  child: Text(
                                "Need an account ? SIGN UP",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(ColorVal)),
                              )),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegistrationScreen()));
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomSheet: BottomSheet(
          backgroundColor: Colors.white,
          onClosing: () {
            print("Hello");
          },
          builder: (BuildContext context) {
            String message1 = '';
            Color textColor = Colors.black;

            if (staticverible.temqr == null || staticverible.temqr.isEmpty) {
              message1 = "Current server is null";
              textColor = Colors.red;
            } else {
              message1 = "Current server is ${staticverible.temqr}";
              textColor = Color(ColorVal);
            }

            return Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50, // Set your desired fixed height
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "$version",
                        style: TextStyle(fontSize: 13, color: Color(ColorVal)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        message1,
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _login() async {
    final String username = _usercontroller.text.trim();
    final String password = _passcontroller.text.trim();

    setState(() {
      _uservalidate = username.isEmpty;
      _passvalidate = password.isEmpty;
      _errorMessage = '';
    });

    try {
      // Assuming Apiservice.loginUser returns a List<Login>
      List<Login> loginList = await Apiservice.loginUser(username, password);

      // Check if the loginList is not empty (successful login)
      if (loginList.isNotEmpty) {
        print('Login successful');
        //  await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Bottom_Screen(),
          ),
        );
      } else {
        // Handle case where loginList is empty (Unauthorized)
        throw Exception('Incorrect username or password. Please try again.');
      }
    } catch (e) {
      // Handle errors
      String errorMessage =
          'You are not connected to internet.Please check your connection ';

      if (e is SocketException) {
        errorMessage = 'Network error: Check your internet connection.';
      } else if (e.toString().contains('Invalid UserId or Password')) {
        errorMessage = 'Invalid UserId or Password.';
        // Update the state variable
        setState(() {
          _errorMessage = errorMessage;
        });
      }

      setState(() {
        _errorMessage = errorMessage;
      });

      print(errorMessage);
    }
  }

  void _togglepasswordview() {
    if (ishidepassword == true) {
      ishidepassword = false;
    } else {
      ishidepassword = true;
    }
    setState(() {});
  }
}
