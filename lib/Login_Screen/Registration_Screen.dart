import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ssbiproject/Other_screen/Static_varible.dart';
import 'package:ssbiproject/Setting/Constvariable.dart';
import 'package:ssbiproject/Setting/JSON_Screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController orgcontroller = TextEditingController();
  TextEditingController firstcontroller = TextEditingController();
  TextEditingController lastcontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController doccontroller = TextEditingController();
  DateTime selectdobdate = DateTime.now();

  DateTime firstDate = DateTime(1870);
  DateTime lastDate = DateTime(2050);

  late List<String> departments;
  late List<String> states;
  late Map<String, List<String>> stateDepartments;
  late Map<String, List<String>> districtDepartments;
  late String selectedDepartment;
  late String selectedState;
  late String selectedDistrict;
  late List<String> genders;
  late List<String> type;
  late List<String> Role;
  late List<String> doc;
  String selectedGender = '';
  String selecttype = '';
  String selectrole = '';
  String selectdoc = '';
  bool Orgvalidate = false;
  bool fistvalidate = false;
  bool lastvalidate = false;
  bool datevalidate = false;
  bool emailvalidate = false;
  bool mobilevalidate = false;
  bool docvalidate = false;
  @override
  void dispose() {
    datecontroller.dispose();
  }

  void initState() {
    super.initState();
    genders = ['Select Gender', 'Male', 'Female', 'Other'];

    // Set default selection for gender
    selectedGender = genders.first;

    type = ['Select Type', 'Own', 'Organization'];
    selecttype = type.first;
    Role = ['Select Role', 'Weaver', 'Manager', 'Supervisor'];
    selectrole = Role.first;

    doc = ['Select Document', 'Aadhar Card', 'Pan Card', 'Voter Id'];
    selectdoc = doc.first;

    // Replace this with your actual JSON loading logic
    Map<String, dynamic> jsonData = jsonDecode(loadJsonData());

    // Extract departments
    departments = List<String>.from(jsonData['department'][0]
        .values
        .expand((d) => d is Iterable ? d : [d])
        .map((item) => item.toString()));

    // Extract states
    states = (jsonData['states'] as List)
        .map((state) => state['name'] as String)
        .toList();

    // Extract state-department mapping
    stateDepartments = Map.fromIterable(jsonData['department'][0].keys,
        key: (state) => state.toString(),
        value: (state) => List<String>.from(
            jsonData['department'][0][state].map((item) => item.toString())));

    // Extract district-department mapping
    districtDepartments = {};
    for (var stateData in jsonData['states']) {
      var stateName = stateData['name'] as String;
      var districts =
          (stateData['districts'] as List).map((d) => d as String).toList();
      districtDepartments[stateName] = districts;
    }

    // Set default selections
    selectedDepartment = departments.first;
    selectedState = states.first;
    selectedDistrict = districtDepartments[selectedState]!.first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 136, 109, 232),
                      Color.fromARGB(255, 167, 127, 197),
                    ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Registration !",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.height / 0.90,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 110, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                            fontSize: 26,
                            color: Color(ColorVal),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("State"),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 0, color: Colors.black)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedState,
                              items: states.map((String state) {
                                return DropdownMenuItem<String>(
                                  value: state,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      state,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedState = value!;
                                  selectedDistrict =
                                      districtDepartments[selectedState]!.first;
                                  selectedDepartment =
                                      stateDepartments[selectedState]!.first;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Districts"),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0, color: Colors.black)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedDistrict,
                                  items: districtDepartments[selectedState]!
                                      .map((String district) {
                                    return DropdownMenuItem<String>(
                                        value: district,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            district,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          ),
                                        ));
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedDistrict = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Department"),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 0, color: Colors.black)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedDepartment,
                                          items:
                                              stateDepartments[selectedState]!
                                                  .map((String department) {
                                            return DropdownMenuItem<String>(
                                              value: department,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  department,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedDepartment = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Type"),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.4,
                                                  child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            width: 0)),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          String>(
                                                        value: selecttype,
                                                        items: type
                                                            .map((String type) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: type,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
                                                              child: Text(
                                                                type,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            selecttype = value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Role"),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                        child: Container(
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border:
                                                                  Border.all(
                                                                      width:
                                                                          0)),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              value: selectrole,
                                                              items: Role.map(
                                                                  (String
                                                                      role) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: role,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    child: Text(
                                                                      role,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                setState(() {
                                                                  selectrole =
                                                                      value!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ]),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: Orgvalidate ? 60 : 40,
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: TextField(
                                      controller: orgcontroller,
                                      decoration: InputDecoration(
                                          errorText: Orgvalidate
                                              ? 'Please Enter Organization'
                                              : null,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          label: Text("Organization",
                                              style: TextStyle(fontSize: 14))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: fistvalidate ? 60 : 40,
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: TextField(
                                      controller: firstcontroller,
                                      decoration: InputDecoration(
                                          errorText: fistvalidate
                                              ? 'Please Enter First Name'
                                              : null,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          label: Text("First Name",
                                              style: TextStyle(fontSize: 14))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: lastvalidate ? 60 : 40,
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    child: TextField(
                                      controller: lastcontroller,
                                      decoration: InputDecoration(
                                          errorText: lastvalidate
                                              ? 'Please Enter Last Name'
                                              : null,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          label: Text(
                                            "Last Name",
                                            style: TextStyle(fontSize: 14),
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Gender"),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.4,
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(width: 0)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: selectedGender,
                                                items: genders
                                                    .map((String gender) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: gender,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text(
                                                        gender,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    selectedGender = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Container(
                                    height: datevalidate ? 60 : 40,
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    child: AbsorbPointer(
                                      absorbing: false,
                                      child: TextField(
                                        keyboardType: TextInputType.none,
                                        controller: datecontroller,
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate:
                                                selectdobdate.isBefore(lastDate)
                                                    ? selectdobdate
                                                    : lastDate,
                                            firstDate: firstDate,
                                            lastDate: lastDate,
                                          );
                                          if (pickedDate != null &&
                                              pickedDate != selectdobdate) {
                                            selectdobdate = pickedDate;
                                            datecontroller.text =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(selectdobdate);
                                          }
                                        },
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          errorText: datevalidate
                                              ? 'Please Select Date'
                                              : null,
                                          label: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text("Date of birth"),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: emailvalidate ? 60 : 40,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.4,
                                        child: TextField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: emailcontroller,
                                          decoration: InputDecoration(
                                            errorText: emailvalidate
                                                ? 'Please Enter Email Id'
                                                : null,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            label: Text(
                                              "Email",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    height: mobilevalidate ? 60 : 40,
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: mobilecontroller,
                                      decoration: InputDecoration(
                                          errorText: mobilevalidate
                                              ? 'Please Enter Mobile No'
                                              : null,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          label: Text(
                                            "Mobile No",
                                            style: TextStyle(fontSize: 14),
                                          )),
                                    ),
                                  ),
                                ),
                              ])
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Select Document"),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.4,
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(width: 0)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: selectdoc,
                                            items: doc.map((String doc) {
                                              return DropdownMenuItem<String>(
                                                value: doc,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    doc,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectdoc = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(""),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            height: mobilevalidate ? 60 : 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            child: TextField(
                                              controller: doccontroller,
                                              decoration: InputDecoration(
                                                  errorText: mobilevalidate
                                                      ? 'Please Enter Document No'
                                                      : null,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  label: Text(
                                                    "Document No",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: BottomSheet(
          backgroundColor: Colors.white,
          onClosing: () {
            print("Hello");
          },
          builder: (BuildContext context) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(ColorVal),
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width,
                      height: 50, // Set your desired fixed height
                      child: Center(
                          child: Text(
                        "Submit",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ))),
                  onTap: () {
                    setState(() {
                      orgcontroller.text.isEmpty
                          ? Orgvalidate = true
                          : Orgvalidate = false;
                      firstcontroller.text.isEmpty
                          ? fistvalidate = true
                          : fistvalidate = false;
                      lastcontroller.text.isEmpty
                          ? lastvalidate = true
                          : lastvalidate = false;
                      datecontroller.text.isEmpty
                          ? datevalidate = true
                          : datevalidate = false;
                      emailcontroller.text.isEmpty
                          ? emailvalidate = true
                          : emailvalidate = false;
                      mobilecontroller.text.isEmpty
                          ? mobilevalidate = true
                          : mobilevalidate = false;
                      doccontroller.text.isEmpty
                          ? docvalidate = true
                          : docvalidate = false;
                      if (!Orgvalidate &&
                          !fistvalidate &&
                          !lastvalidate &&
                          !datevalidate &&
                          !emailvalidate &&
                          !mobilevalidate &&
                          !docvalidate) {
                        insertData();
                        cleartext();
                      }
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

// Insert Data
  Future<void> insertData() async {
    try {
      final String apiurl =
          staticverible.temqr + "handloom/register.aspx/AddUser";

      // Prepare the request payload
      final Map<String, dynamic> requestData = {
        'state': selectedState,
        'district': selectedDistrict,
        'department': selectedDepartment,
        'type': selecttype,
        'role': selectrole,
        'firstname': firstcontroller.text.toString(),
        'lastname': lastcontroller.text.toString(),
        'gender': selectedGender,
        'dob': datecontroller.text.toString(),
        'email': emailcontroller.text.toString(),
        'mobileno': mobilecontroller.text.toString(),
        'organization': orgcontroller.text.toString(),
        'documentname': selectdoc,
        'documentno': doccontroller.text.toString(),
      };

      // Log the request payload for debugging
      print('Request Payload: $requestData');

      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(apiurl),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      // Log the response body for debugging
      print('Response Body: ${response.body}');

      // Check the response status code
      if (response.statusCode == 200) {
        print('Data Insert successfully');
        SucessMagssage(context);
      } else {
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  // clear method
  void cleartext() {
    setState(() {
      orgcontroller.clear();
      firstcontroller.clear();
      lastcontroller.clear();
      datecontroller.clear();
      emailcontroller.clear();
      mobilecontroller.clear();
      doccontroller.clear();
    });
  }

  // Massage
  void SucessMagssage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: double.maxFinite,
              height: 50,
              child: Column(
                children: [
                  Text("Sucess"),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(ColorVal)),
                  ))
            ],
          );
        });
  }
}
