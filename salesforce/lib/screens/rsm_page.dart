import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:salesforce/components/present_absent_dialog.dart';
import 'package:salesforce/screens/aso_monthly_perfomence.dart';
import 'package:salesforce/screens/employee_activity.dart';
import 'package:salesforce/screens/login_page.dart';
import 'package:salesforce/screens/show_feedback.dart';
import 'package:salesforce/screens/show_order_list.dart';
import 'package:salesforce/services/attendance_marking.dart';

class RSM extends StatefulWidget {
  const RSM({super.key});

  @override
  State<RSM> createState() => _RSMState();
}

class _RSMState extends State<RSM> {
  void signOutUser() async {
    // debugPrint('Enter function');

    // If user press confirm then logout
    if (await _showDialogWindow() == true) {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LogInPage()));
    }
  }

  Future<bool> _showDialogWindow() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Logout',
        ),
        backgroundColor: Colors.lightBlue.shade100,
        content: const Text(
          'Are you sure want to log out salesforce?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void markAttendace() async {
    bool present = await PresentAbsentDialog().presentOrAbsentDialog(context);
    var userUid = FirebaseAuth.instance.currentUser!.uid;
    await AttendanceMarking().markingAttendance(userUid, present);
  }

  int selectedIndex = 0;

  List<Widget> navigationPages = [
    ShowOrderList(
      currentUserRoll: 'RSM',
    ),
    ShowFeedback(),
    Center(
      child: EmployeeActivity(
        employeeRoll: 'ASM',
      ),
    ),
    Center(
      child: ASOMonthlyPerformance(),
    ),
  ];

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RSM"),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            onPressed: signOutUser,
            icon: const Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: navigationPages[selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        child: Container(
          color: const Color.fromARGB(255, 166, 225, 255),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GNav(
              onTabChange: (index) => navigateBottomBar(index),
              backgroundColor: const Color.fromARGB(255, 166, 225, 255),
              gap: 8,
              // color: Colors.green,
              activeColor: Colors.white,
              hoverColor: Colors.white,
              tabBackgroundColor: Colors.lightBlue,
              padding: const EdgeInsets.all(16),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.thumb_up,
                  text: 'Feedback',
                ),
                GButton(
                  icon: Icons.group,
                  text: 'ASM activity',
                ),
                GButton(
                  icon: Icons.bar_chart,
                  text: 'Statistics',
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.lightBlue.shade100,
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: ListView(
            children: [
              ListTile(
                onTap: markAttendace,
                title: const Text(
                  "Attendance",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Take attendance for today"),
                leading: const Icon(Icons.calendar_today_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
