// import 'package:flutter/material.dart';



// class ThemePage extends StatelessWidget {
//   const ThemePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeNotifier>(
//       builder: (context, theme, _) => MaterialApp(
//         theme: theme.getTheme(),
//         home: Scaffold(
//           appBar: AppBar(
//             title: Text('Hybrid Theme'),
//           ),
//           body: Row(
//             children: [
//               Container(
//                 child: ElevatedButton(
//                   onPressed: () => {
//                     print('Set Light Theme'),
//                     theme.setLightMode(),
//                   },
//                   child: Text('Set Light Theme'),
//                 ),
//               ),
//               Container(
//                 child: ElevatedButton(
//                   onPressed: () => {
//                     print('Set Dark theme'),
//                     theme.setDarkMode(),
//                   },
//                   child: Text('Set Dark theme'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }