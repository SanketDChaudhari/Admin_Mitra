import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';

class ComplaintDetails extends StatefulWidget {
  final dynamic complaint;

  const ComplaintDetails({super.key, required this.complaint});

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  late Widget? _imageWidget; // Declare _imageWidget as Widget?
  bool _loading = true;
  bool _isUploading = false;
  @override
  void initState() {
    super.initState();
    _fetchImage();
  }


  Future<void> _fetchImage() async {
    try {
      final imageUrl = widget.complaint['image'] as String?;
      if (imageUrl != null) {
        setState(() {
          _loading = true; // Set loading to true while fetching the image
        });

        // Load the image from the URL using Image.network
        _imageWidget = Image.network(
          imageUrl,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              _loading = false; // Set loading to false when image loading is complete
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            print('Error loading image: $error');
            _loading = false; // Set loading to false in case of error
            return const Icon(Icons.error);
          },
        );
      }
    } catch (error) {
      print('Error fetching image: $error');
      setState(() {
        _loading = false; // Set loading to false in case of error
      });
    }
  }


  Future<void> _moveComplaintToSuccessful() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final String email = widget.complaint['email'] as String;

      // Find the user by email
      final DatabaseReference usersRef = FirebaseDatabase.instance.ref("Users");
      final DataSnapshot usersSnapshot = await usersRef.get();

      String? userId;
      int? pendingComplaints;

      if (usersSnapshot.exists) {
        final Map<dynamic, dynamic> usersData = usersSnapshot.value as Map<dynamic, dynamic>;
        usersData.forEach((key, value) {
          if (value['email'] == email) {
            userId = key;
            pendingComplaints = value['Pending'] as int? ?? 0;
          }
        });
      }

      if (userId != null) {
        // print('User ID: $userId');
        // print('Pending Complaints: $pendingComplaints');

        // Decrement the pending complaint count
        pendingComplaints = (pendingComplaints ?? 0) - 1;

        // Update the user's data
        await usersRef.child(userId!).update({'Pending': pendingComplaints});

        // Add complaint to SuccessfulComplaint table
        await FirebaseDatabase.instance.ref("SuccessfulComplaints").child(widget.complaint['id']).set(widget.complaint);

        // Remove complaint from Complaint table
        await FirebaseDatabase.instance.ref("Complains").child(widget.complaint['id']).remove();
      }

      // Navigate back to previous screen after successfully moving the complaint
      Navigator.pop(context);
    } catch (error) {
      print('Error moving complaint: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: const Text(
          "Complaint Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        gradient: const LinearGradient(
          colors: [Color(0xff329d9c), Color(0xff56C596)],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_imageWidget != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _imageWidget!,
                  ),
                )
              else
                const CircularProgressIndicator(),

              const SizedBox(height: 16),

              _buildComplaintDetails(),

              Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 30, left: 90, right: 90),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff329d9c),
                        Color(0xff7BE495),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: 50,
                  height: 40,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent)
                      ),
                      onPressed: () {
                        _isUploading ? null : _moveComplaintToSuccessful();
                      },
                      child: _isUploading ? const CircularProgressIndicator() : const Text("DONE", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),)
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailContainer('HeadLine', widget.complaint['headline'] as String? ?? ''),
        _buildDetailContainer('Date', widget.complaint['date'] as String? ?? ''),
        _buildDetailContainer('Location', widget.complaint['location'] as String? ?? ''),
      ],
    );
  }

  Widget _buildDetailContainer(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffCFF4D2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
