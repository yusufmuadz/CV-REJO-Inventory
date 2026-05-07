import 'package:flutter/cupertino.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String)? onSubmitted;
  final Function() onSuffixTap;
  final String placeholder;
  final EdgeInsetsGeometry? prefixInsets;
  const CustomSearchField({
    super.key,
    required this.searchController,
    this.onSubmitted,
    required this.onSuffixTap,
    required this.placeholder,
    this.prefixInsets,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      placeholder: placeholder,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      prefixInsets:
          prefixInsets ?? const EdgeInsetsDirectional.fromSTEB(6, 8, 0, 8),
      placeholderStyle: const TextStyle(
        color: Color(0xFF7C7C7C),
        fontSize: 13,
        fontFamily: 'Inter',
        height: 1.5,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.39,
      ),
      controller: searchController,
      // suffixMode: OverlayVisibilityMode.editing,
      onSubmitted: onSubmitted,
      onSuffixTap: onSuffixTap,
    );
  }
}
