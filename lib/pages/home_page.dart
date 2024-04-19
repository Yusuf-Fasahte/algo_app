import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:flutter/widgets.dart';
import 'package:parking_ticket_app/components/my_homepage_container.dart';
import 'package:parking_ticket_app/components/my_homepage_list_containers.dart';
import 'package:parking_ticket_app/components/my_homepage_tickets.dart';
import 'package:parking_ticket_app/read%20data/user_data.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  UserData? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    // print(user);
    final doc = await docRef.get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        setState(() {
          _userData = UserData(
            ownerName: data['Owner Name'] as String,
            carBrand: data['Car Brand'] as String,
            carNumberPlate: data['Car Number Plate'] as String,
          );
        });
      }
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  bool _isExpanded = false;
  double _sliderValue = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        icon: Icon(_isExpanded ? Icons.close : Icons.add),
        label: Text(
          _isExpanded ? "Close" : "Add Ticket",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: _isExpanded
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 1.5,
                  ),
                ),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.fromLTRB(20, 50, 20, 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Time: ${_sliderValue.toInt()} mins',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      thumbColor: Colors.blueGrey[800],
                      activeColor: Colors.teal,
                      inactiveColor: Colors.grey,
                      value: _sliderValue,
                      divisions: 5,
                      min: 10,
                      max: 60,
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  actions: [
                    IconButton(
                      onPressed: signUserOut,
                      icon: Icon(
                        Icons.logout,
                        color: Colors.grey[100],
                      ),
                    )
                  ],
                  expandedHeight: 300.0,
                  backgroundColor: Colors.grey[900],
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                      StretchMode.fadeTitle,
                    ],
                    titlePadding: const EdgeInsets.symmetric(vertical: 10),
                    centerTitle: true,
                    title: const Text(
                      'Home Page',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    background: Container(
                      color: Colors.blueGrey[800],
                      child: BabylonJSViewer(src: 'lib/assets/car1.glb'),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    //Car Details
                    const MyHomePageContainer(title: 'Car Details'),
                    //Display Details
                    Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        // color: Colors.grey,
                        child: _userData == null
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                children: [
                                  MyHomePageListContainers(
                                    titleText: 'Owner Name',
                                    detailText: _userData!.ownerName,
                                  ),
                                  MyHomePageListContainers(
                                    titleText: 'Car Number Plate',
                                    detailText: _userData!.carNumberPlate,
                                  ),
                                  MyHomePageListContainers(
                                    titleText: 'Car Brand',
                                    detailText: _userData!.carBrand,
                                  ),
                                ],
                              )),
                    const MyHomePageContainer(title: 'Tickets'),
                    // const Column(
                    //   children: [
                    //     MyHomePageTickets(
                    //       ticketNumber: '11229670',
                    //       ticketDate: '10/5/24',
                    //     ),
                    //   ],
                    // ),
                  ]),
                ),
              ],
            ),
    );
  }
}
