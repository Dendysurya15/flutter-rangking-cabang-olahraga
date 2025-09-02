import 'package:flutter/material.dart';

class GameTypeFilterBottomSheet extends StatefulWidget {
  final String currentSelection;

  const GameTypeFilterBottomSheet({super.key, required this.currentSelection});

  @override
  State<GameTypeFilterBottomSheet> createState() =>
      _GameTypeFilterBottomSheetState();
}

class _GameTypeFilterBottomSheetState extends State<GameTypeFilterBottomSheet> {
  late String selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.currentSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Kategori",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            height: 1,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      for (int i = 0; i < 60; i++) // Reduced number
                        Expanded(
                          child: Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            color: i % 2 == 0
                                ? Colors.grey.shade400
                                : Colors.transparent,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Individu Section
          const Text(
            "Individu",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Tunggal option
          _buildOption("Tunggal"),

          // Bottom border after Tunggal
          Container(height: 1, color: Colors.grey.shade300),

          // Ganda option
          _buildOption("Ganda"),

          // Bottom border after Ganda
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 24),

          // Komunitas option
          _buildOption("Komunitas"),
          const SizedBox(height: 30),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedType.isNotEmpty
                  ? () => Navigator.pop(context, selectedType)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedType.isNotEmpty
                    ? const Color(0xFF7A5AF8)
                    : Colors.grey.shade300,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Terapkan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String option) {
    final isSelected = selectedType == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xFF7A5AF8) : Colors.black87,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF7A5AF8)
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected
                    ? const Color(0xFF7A5AF8)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
