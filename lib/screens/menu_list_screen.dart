import 'package:flutter/material.dart';



class MenuListScreen extends StatelessWidget {
  const MenuListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Demo'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection here
              print('Selected: $value');
            },
            itemBuilder: (BuildContext context) {
              return {'Login', 'Profile', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Main Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
