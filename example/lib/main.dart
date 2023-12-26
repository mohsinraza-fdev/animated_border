import 'package:animated_border/animated_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // home: const AnimatedBorderExample(),
    );
  }
}
//
// class AnimatedBorderExample extends StatefulWidget {
//   final bool smoothen ;
//   const AnimatedBorderExample({Key? key, this.smoothen = false,}) : super(key: key);
//
//   @override
//   State<AnimatedBorderExample> createState() => _AnimatedBorderExampleState();
// }
//
// class _AnimatedBorderExampleState extends State<AnimatedBorderExample> {
//   bool get smoothen => widget.smoothen;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text(
//           'Animated Borders',
//           style: TextStyle(
//             fontSize: 24,
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       floatingActionButton: widget.smoothen ? null : FloatingActionButton.extended(
//         onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AnimatedBorderExample(smoothen: true,))),
//         label: Text(
//           'Smoothen',
//         ),
//       ),
//       body: ListView(
//         children: [
//           const SizedBox(height: 40),
//           Padding(
//             padding: EdgeInsets.only(left: 8),
//             child: Text(
//               'Single Color Border Animation',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[800],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           AnimatedBorder(
//             duration: const Duration(seconds: 4),
//             borderSegments: [
//               BorderSegment.centerLeft(
//                 smoothen: smoothen,
//                 color: const Color(0xFFFF66EB),
//               ),
//             ],
//             child: const ChildContainer(),
//           ),
//           const SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.only(left: 8),
//             child: Text(
//               'Twin Color Border Animation',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[800],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           AnimatedBorder(
//             duration: const Duration(seconds: 4),
//             borderSegments: [
//               BorderSegment.centerLeft(
//                 smoothen: smoothen,
//                 color: const Color(0xFFFF66EB),
//               ),
//               BorderSegment.centerRight(
//                 smoothen: smoothen,
//                 color: const Color(0xFF896EFD),
//               )
//             ],
//             child: const ChildContainer(),
//           ),
//           const SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.only(left: 8),
//             child: Text(
//               'Twin Color Cross Border Animation',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[800],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           AnimatedBorder(
//             duration: const Duration(seconds: 4),
//             borderSegments: [
//               BorderSegment.bottomLeft(
//                 smoothen: smoothen,
//                 color: const Color(0xFFFF66EB),
//               ),
//               BorderSegment.bottomRight(
//                 smoothen: smoothen,
//                 reverse: true,
//                 color: const Color(0xFF896EFD),
//               )
//             ],
//             child: const ChildContainer(),
//           ),
//           const SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.only(left: 8),
//             child: Text(
//               '4 Color Border Animation',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[800],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           AnimatedBorder(
//             duration: const Duration(seconds: 4),
//             borderSegments: [
//               BorderSegment.topCenter(
//                 smoothen: smoothen,
//                 color: const Color(0xFFFF66EB),
//               ),
//               BorderSegment.bottomCenter(
//                 smoothen: smoothen,
//                 color: Colors.blue,
//               ),
//               BorderSegment.centerLeft(
//                 smoothen: smoothen,
//                 color: const Color(0xFF896EFD),
//               ),
//               BorderSegment.centerRight(
//                 smoothen: smoothen,
//                 color: Colors.orange,
//               ),
//             ],
//             child: const ChildContainer(),
//           ),
//           const SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.only(left: 8),
//             child: Text(
//               '16 Color Border Animation',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[800],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           AnimatedBorder(
//             glow: true,
//             duration: const Duration(seconds: 4),
//             borderSegments: [
//               BorderSegment(
//                 startPosition: 0,
//                 smoothen: smoothen,
//                 color: Colors.red,
//               ),
//               BorderSegment(
//                 startPosition: 25,
//                 smoothen: smoothen,
//                 color: Colors.red,
//               ),
//               BorderSegment(
//                 startPosition: 50,
//                 smoothen: smoothen,
//                 color: Colors.red,
//               ),
//               BorderSegment(
//                 startPosition: 75,
//                 smoothen: smoothen,
//                 color: Colors.orange,
//               ),
//               BorderSegment(
//                 startPosition: 100,
//                 smoothen: smoothen,
//                 color: Colors.orange,
//               ),
//               BorderSegment(
//                 startPosition: 125,
//                 smoothen: smoothen,
//                 color: Colors.orange,
//               ),
//               BorderSegment(
//                 startPosition: 150,
//                 smoothen: smoothen,
//                 color: Colors.yellow,
//               ),
//               BorderSegment(
//                 startPosition: 175,
//                 smoothen: smoothen,
//                 color: Colors.yellow,
//               ),
//               BorderSegment(
//                 startPosition: 200,
//                 smoothen: smoothen,
//                 color: Colors.green,
//               ),
//               BorderSegment(
//                 startPosition: 225,
//                 smoothen: smoothen,
//                 color: Colors.green,
//               ),
//               BorderSegment(
//                 startPosition: 250,
//                 smoothen: smoothen,
//                 color: Colors.blue,
//               ),
//               BorderSegment(
//                 startPosition: 275,
//                 smoothen: smoothen,
//                 color: Colors.blue,
//               ),
//               BorderSegment(
//                 startPosition: 300,
//                 smoothen: smoothen,
//                 color: Colors.indigo,
//               ),
//               BorderSegment(
//                 startPosition: 325,
//                 smoothen: smoothen,
//                 color: Colors.indigo,
//               ),
//               BorderSegment(
//                 startPosition: 350,
//                 smoothen: smoothen,
//                 color: Colors.deepPurple,
//               ),
//               BorderSegment(
//                 startPosition: 375,
//                 smoothen: smoothen,
//                 color: Colors.deepPurple,
//               ),
//
//             ],
//             child: const ChildContainer(),
//           ),
//           const SizedBox(height: 300,),
//         ],
//       ),
//     );
//   }
// }
//
// class ChildContainer extends StatelessWidget {
//   const ChildContainer({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100,
//       width: double.maxFinite,
//       color: Colors.grey[50],
//     );
//   }
// }
