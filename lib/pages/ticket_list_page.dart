import 'package:flutter/material.dart';
import 'package:parking_ticket_app/components/my_homepage_container.dart';
import 'package:parking_ticket_app/components/my_homepage_tickets.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({super.key});

  @override
  State<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  final List<Map<String, dynamic>> tickets = [
    {
      'id': '1',
      'ticketNumber': 'Ticket 1',
      'ticketDate': '12/7/99',
    },
    {
      'id': '2',
      'ticketNumber': 'Ticket 2',
      'ticketDate': '12/7/99',
    },
    {
      'id': '3',
      'ticketNumber': 'Ticket 3',
      'ticketDate': '12/7/99',
    },
  ];

  bool _isExpanded = false;
  double _sliderValue = 10;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        appBar: AppBar(
          toolbarHeight: 100,
          title: const MyHomePageContainer(title: 'Tickets'),
        ),
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
            : ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return MyHomePageTickets(
                    ticketNumber: ticket['ticketNumber'],
                    ticketDate: ticket['ticketDate'],
                  );
                },
              ),
      ),
    );
  }
}
