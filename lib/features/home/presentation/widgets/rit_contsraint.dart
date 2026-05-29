import 'package:cv_rejo/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/custom/custom_search_field.dart';

class RitConstraint extends StatelessWidget {
  final HomeController controller;

  const RitConstraint({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          padding: EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kendala',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF151C27),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.add_circle_outline,
                  size: 27,
                  color: Color(0xFF151C27),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 42,
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomSearchField(
            placeholder: 'Cari kendala...',
            searchController: controller.searchController,
            prefixInsets: EdgeInsetsGeometry.fromLTRB(10, 0, 5, 0),
            onSubmitted: (value) {
              controller.onRefreshTransaction();
            },
            onSuffixTap: () {
              controller.searchController.clear();
            },
          ),
        ),
        // Expanded(
        //   child: ListView.separated(
        //     itemBuilder: (context, index) {
        //       return Container(
        //         height: 100,
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(10),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.grey.withOpacity(0.3),
        //               blurRadius: 10,
        //               offset: const Offset(0, 0),
        //             ),
        //           ],
        //         ),
        //       );
        //     },
        //     separatorBuilder: (context, index) => const SizedBox(height: 10),
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //     itemCount: 1,
        //   ),
        // ),
      ],
    );
  }
}
