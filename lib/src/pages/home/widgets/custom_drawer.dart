import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tindog/src/constants/setting.dart';
import 'package:tindog/src/config/route.dart' as custom_route;
import 'package:tindog/src/viewmodels/menu_view_model.dart';
import 'package:badges/badges.dart' as badges;

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String collectionName = "users";
  List<String> docIDs = [];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width*0.7,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white10,
              spreadRadius: 2, // กำหนดความกว้างของเงา
              blurRadius: 5, // กำหนดความเข้มของเงา
              offset: Offset(0, 3), // กำหนดตำแหน่งแนวนอนและแนวตั้งของเงา
            ),
          ],
        ),
        child: Column(
          children: [
            _buildUserProfile(),
            // ต้องมีการ return widget ใดก็ตามเพื่อเตรียมสร้างหน้าจอใหม่
            ..._buildMainMenu(),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), // กำหนดสีเงา
                    spreadRadius: 2, // กำหนดความกว้างของเงา
                    blurRadius: 5, // กำหนดความเข้มของเงา
                    offset: Offset(0, 3), // กำหนดตำแหน่งแนวนอนและแนวตั้งของเงา
                  ),
                ],
              ),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  color: Colors.black54,
                ),
                title: Text("LOGOUT"),
                onTap: showDialogLogOut,
                trailing: FaIcon(FontAwesomeIcons.dog),
              ),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Object?>> _buildUserProfile() {
    return FutureBuilder<DocumentSnapshot>(
        future: firestoreRef.collection('users').doc(user?.uid).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data?.data() != null) {
              final dataItem = snapshot.data?.data() as Map<String, dynamic>;
              return UserAccountsDrawerHeader(
                accountName: Text(
                    dataItem["Name"] != null ? dataItem["Name"] : Container(),
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                ),
                accountEmail: Text(dataItem["Email"] != null
                    ? dataItem["Email"]
                    : Container(),
                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: dataItem['ProfileImage'] != null 
                      ? NetworkImage(dataItem['ProfileImage'])
                      : NetworkImage('https://cdn-icons-png.flaticon.com/512/3616/3616929.png')
                  ,
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://cdn.pixabay.com/photo/2019/08/21/08/33/nose-4420535_1280.jpg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          offset: Offset(0, 3),
                          blurRadius: 5)
                    ]),
              );
            } else {
              Navigator.pushReplacementNamed(context, custom_route.Route.login);
              return Container(); // ต้องมีการ return widget ใดก็ตามเพื่อเตรียมสร้างหน้าจอใหม่
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  void showDialogLogOut() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Logout 🥹'),
          content: Text('are you sure you want to logout ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            TextButton(
              child: Text(
                'Yes !!',
                style: TextStyle(color: Colors.deepOrange),
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  SharedPreferences.getInstance()
                      .then((value) => value.remove(Setting.TOKEN_PREF));
                  Navigator.of(dialogContext).pop();
                  Navigator.pushNamedAndRemoveUntil(
                      context, custom_route.Route.login, (route) => false);
                });
                // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid')
        .where('uid', isEqualTo: user)
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              print("print element: ${element.reference}");
              docIDs.add(element.reference.id);
            }));
  }

  Future<UserAccountsDrawerHeader> _buildProfile() async {
    final userDocument = await firestoreRef
        .collection(collectionName)
        .doc(getCurrentUserUid())
        .get();
    final data = await userDocument.data() as Map<String, dynamic>;
    return UserAccountsDrawerHeader(
      accountName: Text(data["Name"]),
      accountEmail: Text(data["Email"]),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/images/JohnWick.png'),
      ),
    );
  }

  List<ListTile> _buildMainMenu() => MenuViewModel()
      .items
      .map(
        (item) => ListTile(

          title: Text(
            // กำหนดเงา
            item.title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
          leading: badges.Badge(
            showBadge: item.icon == FontAwesomeIcons.inbox,
            badgeContent: Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            child: FaIcon(
              item.icon,
              color: item.iconColor,
            ),
          ),
          onTap: () {
            item.onTap(context);
          },
        ),
      )
      .toList();

  String? getCurrentUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;

    // เข้าถึงข้อมูลของผู้ใช้ปัจจุบันที่ล็อกอินอยู่
    User? currentUser = auth.currentUser;

    // อ่านค่า UID จากผู้ใช้ปัจจุบัน (หากไม่มีผู้ใช้ล็อกอิน จะได้ค่าเป็น null)
    String? uid = currentUser?.uid;
    return uid;
  }
}
