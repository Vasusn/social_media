import 'package:flutter/material.dart';

import 'my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onSignOut;
  const MyDrawer(
      {super.key, required this.onProfileTap, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          //header
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),

              //home
              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTab: () => Navigator.pop(context),
              ),

              //profile
              MyListTile(
                icon: Icons.person,
                text: 'P R O F I L E',
                onTab: onProfileTap,
              ),
            ],
          ),

          //logout
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListTile(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTab: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}
