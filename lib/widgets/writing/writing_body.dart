// import 'package:flutter/material.dart';
// import 'package:naro/widgets/common/date_dialog.dart';

// class WritingBody extends StatelessWidget {
//   const WritingBody({
//       required this.titleController,
//       required this.contentController,
//       super.key
//     });
//   final TextEditingController titleController;
//   final TextEditingController contentController;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           FilledButton(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (context) => const DateDialog(),
//               ).then((pickedDate) {
//                 if (pickedDate != null) {
//                   print('Selected date: $pickedDate');
//                 } else {
//                   print('No date selected');
//                 }
//               });
//               print('dialog test');
//             },
//             child: const Text('modal test', style: TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 16,
//               color: Color.fromARGB(255, 255, 255, 255),
//             )),
//           ),
//           TextWriting(
//             titleController: titleController,
//             contentController: contentController,
//           ),
//           PhotoUpload(),
//           SizedBox(height: 40),
//         ],
//       )
//     );
//   }
// }
