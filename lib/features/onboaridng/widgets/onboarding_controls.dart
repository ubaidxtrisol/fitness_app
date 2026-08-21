import 'package:flutter/material.dart';

class OnboardingControls extends StatelessWidget {
  final int pagesLength;
  final int currentPage;
  final VoidCallback onNextPressed;

  const OnboardingControls({
    super.key,
    required this.pagesLength,
    required this.currentPage,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Dot Indicator
              Row(
                children: List.generate(
                  pagesLength,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 8.0,
                    width: currentPage == index ? 24.0 : 8.0,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? colorScheme.primary
                          : colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ),
              // Next / Get Started Button
              ElevatedButton(
                onPressed: onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 0,
                ),
                child: Text(
                  currentPage == pagesLength - 1 ? 'Start' : 'Next',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
