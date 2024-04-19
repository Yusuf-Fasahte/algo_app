import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_ticket_app/read%20data/user_data.dart';
import 'package:ticket_widget/ticket_widget.dart';

class TicketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          'Ticket Screen',
          style: TextStyle(
              color: Colors.grey[200],
              fontSize: 30,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          child: TicketWidget(
            color: Colors.blueGrey,
            width: 350,
            height: 500,
            isCornerRounded: true,
            padding: EdgeInsets.all(20),
            child: TicketData(),
          ),
        ),
      ),
    );
  }
}

class TicketData extends StatefulWidget {
  TicketData({super.key});
  @override
  State<TicketData> createState() => _TicketDataState();
}

class _TicketDataState extends State<TicketData> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Parking Ticket',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: _userData == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ticketDetailsWidget(
                      'Ticket ID',
                      _userData!.ownerName,
                      'Expiry Time',
                      '04-04-2024',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, right: 52.0),
                      child: ticketDetailsWidget(
                        'Car Number',
                        _userData!.carNumberPlate,
                        'Class',
                        'Premium',
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, right: 53.0),
                      child: ticketDetailsWidget(
                        'Sector',
                        '66',
                        'Sub Sector',
                        'B',
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueGrey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: 'Parking',
              drawText: false,
              height: 70,
            ),
          ),
        ),
      ],
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
