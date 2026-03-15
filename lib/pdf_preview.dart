// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
//
// class PdfViewerScreen extends StatelessWidget {
//   final String filePath;
//
//   const PdfViewerScreen({super.key, required this.filePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("PDF Viewer")),
//       body: FutureBuilder<Uint8List>(
//         future: File(filePath).readAsBytes().then((bytes) => Uint8List.fromList(bytes)),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error loading PDF"));
//           } else {
//             return SfPdfViewer.memory(snapshot.data!);
//           }
//         },
//       ),
//     );
//   }
// }