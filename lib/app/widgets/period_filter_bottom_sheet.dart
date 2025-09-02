import 'package:flutter/material.dart';

class PeriodFilterBottomSheet extends StatefulWidget {
  final String currentSelection;

  const PeriodFilterBottomSheet({super.key, required this.currentSelection});

  @override
  State<PeriodFilterBottomSheet> createState() =>
      _PeriodFilterBottomSheetState();
}

class _PeriodFilterBottomSheetState extends State<PeriodFilterBottomSheet> {
  late String selectedPeriod;

  @override
  void initState() {
    super.initState();
    selectedPeriod = widget.currentSelection;
  }

  final List<Map<String, String>> periods = [
    {"title": "All Time", "subtitle": ""},
    {"title": "Januari - Maret 2024", "subtitle": "Current Season"},
    {"title": "Oktober - Desember 2023", "subtitle": ""},
    {"title": "Juli - Agustus 2023", "subtitle": ""},
  ];

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
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Periode",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Period options
          ...periods.map(
            (period) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPeriod = period["title"]!;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedPeriod == period["title"]
                          ? const Color(0xFF7A5AF8)
                          : Colors.grey.shade200,
                      width: selectedPeriod == period["title"] ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              period["title"]!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: selectedPeriod == period["title"]
                                    ? const Color(0xFF7A5AF8)
                                    : Colors.black87,
                              ),
                            ),
                            if (period["subtitle"]!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                period["subtitle"]!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedPeriod == period["title"]
                                ? const Color(0xFF7A5AF8)
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                          color: selectedPeriod == period["title"]
                              ? const Color(0xFF7A5AF8)
                              : Colors.transparent,
                        ),
                        child: selectedPeriod == period["title"]
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedPeriod.isNotEmpty
                  ? () => Navigator.pop(context, selectedPeriod)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedPeriod.isNotEmpty
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
}
