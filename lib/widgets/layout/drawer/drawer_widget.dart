import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final user = FirebaseAuth.instance.currentUser;

  void userLogout() {
    FirebaseAuth.instance.signOut();
    Future.delayed(const Duration(milliseconds: 200), () {
      snackMessage("User logged out", Colors.red);
    });
  }

  snackMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        key: const Key("logout"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    "assets/ACTIVY.svg",
                    height: 24,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Be more productive with us!",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? "User",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          GestureDetector(
                            onTap: userLogout,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.red.shade600,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.red.shade600),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Home"),
              leading: const Icon(
                Icons.home,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                "© 2023 ACTIVY",
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
