import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: appbar(),
        body: Column(
          children: [
            SizedBox(height: screenSize.height * 0.05),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: screenSize.height * 0.4,
                  width: screenSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: const ButtonStyle(),
                              child: const Text("First feature"),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: const ButtonStyle(),
                              child: const Text("First feature"),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: const ButtonStyle(),
                              child: const Text("First feature"),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.1,
                            width: screenSize.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {context.go('/options');},
                              style: const ButtonStyle(),
                              child: const Text("Interactive classroom"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                onTap: () {},
                child: Container(
                  height: screenSize.height * 0.41,
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
            )
          ],
        ),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      title: const Text(
        'Homepage',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      elevation: 0,
    );
  }
}
