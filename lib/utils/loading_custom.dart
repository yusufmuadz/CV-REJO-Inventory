import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

enum LoadState {
  initial, // Pertama kali load
  loadingMore, // Infinite scroll
  idle, // Selesai load
  error, // Ada error
  noMore, // Tidak ada data lagi
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: const Color(0xFFFF51BD),
        size: 50,
      ),
    );
  }
}
