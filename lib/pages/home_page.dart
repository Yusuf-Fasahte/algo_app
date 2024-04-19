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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
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
