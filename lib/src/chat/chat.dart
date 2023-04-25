import 'package:bangkaew/src/chat/chatpage.dart';
import 'package:bangkaew/src/chat/functions.dart';
import 'package:bangkaew/src/chat/styles.dart';
import 'package:bangkaew/src/chat/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bangkaew/src/config/theme.dart' as custom_theme;
class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    Functions.updateAvailability();
    super.initState();
  }

  final firestore = FirebaseFirestore.instance;
  bool open = false;

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    return Scaffold(
      //backgroundColor: Colors.indigo.shade400,
      // appBar: AppBar(
      //   backgroundColor: Colors.indigo.shade400,
      //   title: const Text('Flash Chat'),
      //   elevation: 0,
      //   centerTitle: true,
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 10.0),
      //       child: IconButton(
      //           onPressed: () {
      //             setState(() {
      //               open == true ? open = false : open = true;
      //             });
      //           },
      //           icon: Icon(
      //             open == true ? Icons.close_rounded : Icons.search_rounded,
      //             size: 30,
      //           )),
      //     )
      //   ],
      // ),
      // drawer: ChatWidgets.drawer(context),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: custom_theme.Theme.gradient,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          custom_theme.Theme.gradient.colors.last, // สลับตำแหน่งสีใหม่
                          custom_theme.Theme.gradient.colors.first, // สลับตำแหน่งสีใหม่
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Text(
                            'Recent Users',
                            style: Styles.h1(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 75,
                          child: StreamBuilder(
                              stream: firestore.collection('Rooms').snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                List data = !snapshot.hasData ? [] : snapshot.data!.docs
                                        .where((element) => element['users']
                                            .toString()
                                            .contains(FirebaseAuth.instance.currentUser!.uid)).toList();
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (context, i) {
                                    List users = data[i]['users'];
                                    var friend = users.where((element) =>
                                        element !=
                                        FirebaseAuth.instance.currentUser!.uid);
                                    var user = friend.isNotEmpty ? friend.first
                                        : users.where((element) =>
                                                element == FirebaseAuth
                                                    .instance.currentUser!.uid).first;
                                    return FutureBuilder(
                                        future: firestore
                                            .collection('users')
                                            .doc(user)
                                            .get(),
                                        builder: (context, AsyncSnapshot snap) {
                                          return !snap.hasData
                                              ? Container()
                                              : ChatWidgets.circleProfile(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return ChatPage(
                                                            id: user,
                                                            name: snap.data['Name'],
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  name: snap.data['Name']);
                                        });
                                  },
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 0),
                    decoration: Styles.friendsBox(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text(
                            'Contacts',
                            style: Styles.h1().copyWith(color: Colors.indigo),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: StreamBuilder(
                                stream:
                                    firestore.collection('Rooms').snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  List data = !snapshot.hasData
                                      ? []
                                      : snapshot.data!.docs
                                          .where((element) => element['users']
                                              .toString()
                                              .contains(FirebaseAuth
                                                  .instance.currentUser!.uid))
                                          .toList();
                                  return ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, i) {
                                      List users = data[i]['users'];
                                      var friend = users.where((element) =>
                                          element !=
                                          FirebaseAuth
                                              .instance.currentUser!.uid);
                                      var user = friend.isNotEmpty
                                          ? friend.first
                                          : users
                                              .where((element) =>
                                                  element ==
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid)
                                              .first;
                                      return FutureBuilder(
                                          future: firestore
                                              .collection('users')
                                              .doc(friend.first)
                                              .get(),
                                          builder:
                                              (context, AsyncSnapshot snap) {
                                            return !snap.hasData
                                                ? Container()
                                                : ChatWidgets.card(
                                                    title: snap.data['Name'],
                                                    subtitle: data[i]
                                                        ['last_message'],
                                                    time: DateFormat('hh:mm a')
                                                        .format(data[i]['last_message_time'].toDate()),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return ChatPage(
                                                              id: friend.first,
                                                              name: snap
                                                                  .data['Name'],
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );
                                          });
                                    },
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ChatWidgets.searchBar(open),
            Positioned(
              bottom: 16, // ระยะจากขอบล่าง
              right: 16, // ระยะจากขอบขวา
              child: IconButton(
                onPressed: () {
                  setState(() {
                    open = !open;
                  });
                },
                icon: Icon(
                  open ? Icons.close_rounded : Icons.search_rounded,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
