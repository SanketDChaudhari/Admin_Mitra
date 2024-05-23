import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'compliant_details.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser;

  DatabaseReference ref = FirebaseDatabase.instance.ref("Complains");

  signout() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text("Home",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        gradient: const LinearGradient(
          colors: [Color(0xff329d9c), Color(0xff56C596)],
        ),
        actions: [
          Row(
            children: [
              FloatingActionButton(
                onPressed: (()=>signout()),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: const Icon(Icons.login_rounded),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child:Expanded(
          child: StreamBuilder(
            stream: ref.onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                Map<String, dynamic>? map = _convertDynamicMap(snapshot.data!.snapshot.value);
                List<dynamic> list = map?.values.toList() ?? [];

                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      'No complaints yet',
                      style: TextStyle(fontSize: 18, color: Color(0xff329d9c)),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComplaintDetails(complaint: list[index]),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Card(
                          color: const Color(0xffCFF4D2),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "Garbage | ${list[index]['date']} \n${list[index]['location']}",
                              style: const TextStyle(
                                color: Color(0xff329d9c),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Map<String, dynamic>? _convertDynamicMap(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Map<String, dynamic>) {
      return value;
    }
    try {
      return Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
    } catch (e) {
      print('Error converting dynamic map: $e');
      return null;
    }
  }
}
