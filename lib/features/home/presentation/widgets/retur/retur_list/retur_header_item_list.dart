// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ionicons/ionicons.dart';

// import '../../../controllers/home_retur_controller.dart';

// class ReturHeaderItemList extends StatelessWidget {
//   final HomeReturController controller;

//   const ReturHeaderItemList({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 47,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(width: 1, color: Color(0xFFD7C3B4))),
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(12),
//           topLeft: Radius.circular(12),
//         ),
//         color: Color(0xFFF0F3FF),
//       ),
//       child: _buildTitleIconList(
//         isCheckbox: false,
//         valueCheckbox: false,
//         controller: controller,
//         onChanged: (value) {
//           // controller.selectAll();
//         },
//       ),
//     );
//   }

//   Widget _buildTitleIconList({
//     bool isIcon = true,
//     bool isCheckbox = true,
//     int? index,
//     String? title,
//     String? number,
//     bool? valueCheckbox,
//     Function(bool?)? onChanged,
//     required HomeReturController controller,
//   }) {
//     String resultTitle = 'TAMBAH BARANG';

//     if (title != null) {
//       resultTitle = title;
//     }
//     return Row(
//       children: [
//         Visibility(
//           visible: isIcon,
//           child: const SizedBox(
//             width: 30,
//             child: Icon(
//               Icons.checklist_rounded,
//               size: 24,
//               color: Color(0xFF857467),
//             ),
//           ),
//         ),
//         Visibility(
//           visible: !isIcon,
//           child: SizedBox(
//             width: 30,
//             child: Text(
//               '$number',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.hankenGrotesk(
//                 color: const Color(0xFF857467),
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 0.48,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             resultTitle,
//             style: GoogleFonts.hankenGrotesk(
//               color: const Color(0xFF524439),
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.48,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Visibility(
//           visible: isIcon && !isCheckbox,
//           child: InkWell(
//             onTap: () {
//               _inputProductRetur(controller: controller);
//             },
//             child: const Icon(
//               Icons.add_circle_outline_outlined,
//               size: 28,
//               color: Color(0xFFd68f4d),
//             ),
//           ),
//         ),
//         Visibility(
//           visible: isCheckbox && !isIcon,
//           child: InkWell(
//             onTap: () {
//               debugPrint('index $index');

//               controller.itemPoAddRetur.removeAt(index ?? 0);
//             },
//             child: const Icon(
//               Ionicons.close_circle_outline,
//               size: 28,
//               color: Colors.redAccent,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
