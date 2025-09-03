import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rangking_cabang_olahraga/app/modules/home/controllers/home_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PodiumWidget extends GetView<HomeController> {
  const PodiumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final topThree = controller.topThree;
      final isGandaType = controller.selectedGameType.value == "Ganda";

      return Container(
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 2nd Place
            Flexible(
              child: PodiumItem(
                rank: 2,
                name: topThree.length > 1 ? topThree[1]['name'] ?? '-' : '-',
                points: topThree.length > 1
                    ? topThree[1]['points']?.toString() ?? '0'
                    : '0',
                height: 140,
                color: HexColor("#4D37A5"),
                avatar: topThree.length > 1 ? topThree[1]['avatar'] ?? '' : '',
                secondAvatar: isGandaType && topThree.length > 1
                    ? topThree[1]['secondAvatar'] ?? ''
                    : '',
                isGandaType: isGandaType,
              ),
            ),
            const SizedBox(width: 16),

            // 1st Place
            Flexible(
              child: PodiumItem(
                rank: 1,
                name: topThree.isNotEmpty ? topThree[0]['name'] ?? '-' : '-',
                points: topThree.isNotEmpty
                    ? topThree[0]['points']?.toString() ?? '0'
                    : '0',
                height: 170,
                color: HexColor("#4D37A5"),
                avatar: topThree.isNotEmpty ? topThree[0]['avatar'] ?? '' : '',
                secondAvatar: isGandaType && topThree.isNotEmpty
                    ? topThree[0]['secondAvatar'] ?? ''
                    : '',
                isGandaType: isGandaType,
              ),
            ),
            const SizedBox(width: 16),

            // 3rd Place
            Flexible(
              child: PodiumItem(
                rank: 3,
                name: topThree.length > 2 ? topThree[2]['name'] ?? '-' : '-',
                points: topThree.length > 2
                    ? topThree[2]['points']?.toString() ?? '0'
                    : '0',
                height: 100,
                color: HexColor("#4D37A5"),
                avatar: topThree.length > 2 ? topThree[2]['avatar'] ?? '' : '',
                secondAvatar: isGandaType && topThree.length > 2
                    ? topThree[2]['secondAvatar'] ?? ''
                    : '',
                isGandaType: isGandaType,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class PodiumItem extends StatelessWidget {
  final int rank;
  final String name;
  final String points;
  final double height;
  final Color color;
  final String avatar;
  final String secondAvatar;
  final bool isGandaType;

  const PodiumItem({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.height,
    required this.color,
    required this.avatar,
    required this.secondAvatar,
    required this.isGandaType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar section
        _buildAvatarSection(),
        const SizedBox(height: 6),

        // Name
        SizedBox(
          width: 70,
          child: Text(
            name.length > 12 ? "${name.substring(0, 12)}..." : name,
            style: GoogleFonts.rubik(
              textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(height: 2),

        // Points container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$points Pts',
            style: GoogleFonts.rubik(
              textStyle: TextStyle(
                fontSize: 11,
                color: HexColor("#7E051A"),
                fontWeight: FontWeight.w500,
              ),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(height: 6),

        // Podium base
        Container(
          width: 100,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                '$rank',
                style: GoogleFonts.rubik(
                  textStyle: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSection() {
    if (isGandaType && secondAvatar.isNotEmpty) {
      // IMPROVED: Compact overlapping for Ganda (doubles)
      return SizedBox(
        width: 60, // Fixed width to control spacing
        height: 50,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // First avatar (back)
            Positioned(
              left: -5,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: HexColor("#7A5AF8"), width: 2),
                ),
                child: CircleAvatar(
                  radius: 20, // Slightly smaller than original 22
                  backgroundImage: avatar.isNotEmpty
                      ? NetworkImage(avatar)
                      : null,
                  backgroundColor: Colors.grey.shade200,
                  child: avatar.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey, size: 18)
                      : null,
                ),
              ),
            ),
            // Second avatar (front) - overlapping
            Positioned(
              left: 25, // Overlap by half for compact look
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: HexColor("#7A5AF8"), width: 2),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: secondAvatar.isNotEmpty
                      ? NetworkImage(secondAvatar)
                      : null,
                  backgroundColor: Colors.grey.shade200,
                  child: secondAvatar.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey, size: 18)
                      : null,
                ),
              ),
            ),
            // Crown for 1st place - centered between avatars
            if (rank == 1)
              Positioned(
                bottom: -4,
                left: 20, // Center position between overlapping avatars
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                    border: Border.all(color: HexColor("#7A5AF8"), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const FaIcon(
                    FontAwesomeIcons.crown,
                    color: Colors.white,
                    size: 11,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      // Display single avatar for Tunggal (singles) - unchanged
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
            backgroundColor: Colors.grey.shade200,
            child: avatar.isEmpty
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          // Crown for 1st place
          if (rank == 1)
            Positioned(
              bottom: -8,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                  border: Border.all(color: HexColor("#7A5AF8"), width: 1.5),
                ),
                padding: const EdgeInsets.all(4),
                child: const FaIcon(
                  FontAwesomeIcons.crown,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
        ],
      );
    }
  }
}
