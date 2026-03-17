import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MasonrySearchGrid extends StatelessWidget {
  const MasonrySearchGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: 18,
      itemBuilder: (context, index) {
        return _MasonryItem(
          image:
              'https://picsum.photos/300/${index.isEven ? 420 : 360}?random=$index',
          showPlay: index == 2 || index == 7 || index == 11,
        );
      },
    );
  }
}

class _MasonryItem extends StatelessWidget {
  final String image;
  final bool showPlay;

  const _MasonryItem({required this.image, required this.showPlay});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Image.network(image, fit: BoxFit.cover),
          ),
          if (showPlay)
            Positioned.fill(
              child: Center(
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, size: 22),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
