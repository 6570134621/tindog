import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bangkaew/src/chat/widgets.dart';
import 'package:intl/intl.dart';
import 'chatpage.dart';
import 'package:bangkaew/src/config/theme.dart' as custom_theme;
class AnimatedDialog extends StatefulWidget {
  final double height;
  final double width;

  const AnimatedDialog({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> {
  final firestore= FirebaseFirestore.instance;
  final controller = TextEditingController();
  String search = '';
  bool show = false;
  @override
  Widget build(BuildContext context) {
    if (widget.height != 0) {
      Timer(const Duration(milliseconds: 200), () {
        setState(() {
          show = true;
        });
      });
    } else {
      setState(() {
        show = false;
      });
    }

    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              color: widget.width == 0
                  ? Colors.indigo.withOpacity(0)
                  : Color(0xFFF0A6CA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.width == 0 ? 100 : 100),
                bottomRight: Radius.circular(widget.width == 0 ? 100 : 100),
                bottomLeft: Radius.circular(widget.width == 0 ? 100 : 100),
              )),
          child: widget.width == 0 ? null : !show ? null :
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [
                  custom_theme.Theme.gradient.colors.last, // สลับตำแหน่งสีใหม่
                  custom_theme.Theme.gradient.colors.first, // สลับตำแหน่งสีใหม่
                ],
              ),
            ),

            child: Column(
              children: [
                ChatWidgets.searchField(
                    onChange: (a){
                      setState(() {
                        search = a;
                      });
                    }
                ),
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8.0),
                    child: StreamBuilder(
                        stream: firestore.collection('users').snapshots(),
                        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                          List data = !snapshot.hasData? []:
                          snapshot.data!.docs.where((element) =>
                          (element['Email'].toString().contains(search) ||
                              element['Name'].toString().contains(search)) &&
                              element.id != FirebaseAuth.instance.currentUser!.uid)
                              .toList();
                          // data = data : [Instance of '_JsonQueryDocumentSnapshot', Instance of '_JsonQueryDocumentSnapshot']
                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              Timestamp time = data[i]['date_time'];
                              return ChatWidgets.card(
                                title: data[i]['Name'],
                                time: DateFormat('EEE hh:mm').format(time.toDate()),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        //data[i].id : 4GtjlYjR78TXdk7opqSBKAydW4e2
                                        print("data[i].id : ${data[i].id}");
                                        // when choose someone, will send uid him
                                        return  ChatPage(
                                          id: data[i].id.toString(),
                                          name: data[i]['Name'],

                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
