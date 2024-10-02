import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomOptionsPage extends StatefulWidget {
  const RoomOptionsPage({super.key});

  @override
  State<RoomOptionsPage> createState() => _RoomOptionsPageState();
}

class _RoomOptionsPageState extends State<RoomOptionsPage> {
  bool _isOverlayVisible = false; 
  final TextEditingController _roomNumberController = TextEditingController(); 

  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible; 
    });
  }

  void _joinRoom() {
    String roomNumber = _roomNumberController.text;
    if (roomNumber.isNotEmpty) {
      context.go('/video_conf', extra: roomNumber); 
      _toggleOverlay(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Room Options",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: Stack( 
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: screenSize.height * 0.5,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.go('/room_create');
                            },
                            child: Container(
                              height: screenSize.height * 0.10,
                              width: screenSize.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Create a Room",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleOverlay, // Show overlay on tap
                            child: Container(
                              height: screenSize.height * 0.10,
                              width: screenSize.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Join a Room",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/room_create');
                      },
                      onDoubleTap: _toggleOverlay,
                      child: Container(
                        height: screenSize.height * 0.38,
                        width: screenSize.width * 0.96,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.grey[300],
                        ),
                        child: const Center(
                          child: Text(
                            "Tapping controller area",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isOverlayVisible) // Show overlay if visible
              GestureDetector(
                onTap: _toggleOverlay, // Hide overlay on tap
                child: Container(
                  color: Colors.black54, // Background color for overlay
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: screenSize.height * 0.5, // Adjust height for overlay
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Enter Room Number",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _roomNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Room Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _joinRoom, // Join room function
                              child: const Text("Enter"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
