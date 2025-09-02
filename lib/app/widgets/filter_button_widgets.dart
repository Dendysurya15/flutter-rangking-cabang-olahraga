import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isActive;
  final IconData? icon;

  const FilterButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isActive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                subtitle, // Display the selected value (like "Tenis Meja", "Tunggal", etc.)
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
