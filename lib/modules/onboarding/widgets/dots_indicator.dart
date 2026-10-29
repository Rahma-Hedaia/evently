import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const DotsIndicator({super.key, required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? theme.primaryColor : theme.dividerColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}