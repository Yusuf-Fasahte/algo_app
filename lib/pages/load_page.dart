// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

// class LoadPage extends StatefulWidget {
//   const LoadPage({super.key});

//   @override
//   State<LoadPage> createState() => _LoadPageState();
// }

// class _LoadPageState extends State<LoadPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Container(
//         color: Colors.black,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 15,
//             vertical: 20,
//           ),
//           child: GNav(
//             haptic: true,
//             backgroundColor: Colors.black,
//             color: Colors.white,
//             activeColor: Colors.white,
//             tabBackgroundColor: Colors.grey.shade800,
//             gap: 8,
//             onTabChange: (index){

//             },
//             padding: EdgeInsets.all(15),
//             tabs: [
//               GButton(
//                 icon: Icons.home,
//                 text: 'Home',
//               ),
//               GButton(
//                 icon: Icons.bookmark,
//                 text: 'Tickets',
//               ),
//               GButton(
//                 icon: Icons.mail,
//                 text: 'Messages',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parking_ticket_app/pages/home_page.dart';
import 'package:parking_ticket_app/pages/ticket_list_page.dart';
import 'package:parking_ticket_app/pages/ticket_page.dart';

import 'message_page.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    TicketListPage(),
    MessagePage(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            haptic: true,
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            selectedIndex: _selectedIndex,
            onTabChange: _onTabChange,
            padding: EdgeInsets.all(15),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.bookmark,
                text: 'Tickets',
              ),
              GButton(
                icon: Icons.mail,
                text: 'Messages',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
