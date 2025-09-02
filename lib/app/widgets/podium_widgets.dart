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
      // Access controller data directly
      final topThree = controller.topThree;

      // Ensure we have at least 3 items for podium
      if (topThree.length < 3) {
        return _buildEmptyPodium();
      }

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
                name: topThree[1]['name'] ?? 'Unknown',
                points: topThree[1]['points']?.toString() ?? '0 Pts',
                height: 140,
                color: HexColor("#4D37A5"),
                avatar: topThree[1]['avatar'] ?? '',
              ),
            ),
            const SizedBox(width: 16),

            // 1st Place
            Flexible(
              child: PodiumItem(
                rank: 1,
                name: topThree[0]['name'] ?? 'Unknown',
                points: topThree[0]['points']?.toString() ?? '0 Pts',
                height: 170,
                color: HexColor("#4D37A5"),
                avatar: topThree[0]['avatar'] ?? '',
              ),
            ),
            const SizedBox(width: 16),

            // 3rd Place
            Flexible(
              child: PodiumItem(
                rank: 3,
                name: topThree[2]['name'] ?? 'Unknown',
                points: topThree[2]['points']?.toString() ?? '0 Pts',
                height: 100,
                color: HexColor("#4D37A5"),
                avatar: topThree[2]['avatar'] ?? '',
              ),
            ),
          ],
        ),
      );
    });
  }

  // Show empty state when insufficient data
  Widget _buildEmptyPodium() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No rankings yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PodiumItem extends StatelessWidget {
  final int rank;
  final String name;
  final String points;
  final double height;
  final Color color;
  final String avatar;

  const PodiumItem({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.height,
    required this.color,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar with stacked crown for 1st place
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(avatar),
              onBackgroundImageError: (_, __) => const Icon(Icons.person),
            ),

            // Crown for 1st place - positioned on top of avatar
            if (rank == 1)
              Positioned(
                bottom:
                    -8, // Adjust this value to position crown higher or lower
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                    border: Border.all(color: HexColor("#7A5AF8"), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const FaIcon(
                    FontAwesomeIcons.crown, // Font Awesome crown icon
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),

        // Name - Fixed width and ellipsis
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

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            points,
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

        // Replace the Container with this updated version:
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
            padding: const EdgeInsets.only(top: 5), // Add top padding
            child: Align(
              alignment: Alignment.topCenter, // Align to top center
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
}
