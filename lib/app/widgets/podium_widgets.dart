import 'package:flutter/material.dart';

class PodiumWidget extends StatelessWidget {
  const PodiumWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              name: "Kevin Halim",
              points: "186 Pts",
              height: 120,
              color: Colors.grey.shade300,
              avatar:
                  "https://ui-avatars.com/api/?name=Kevin+Halim&background=6366f1&color=fff",
            ),
          ),
          const SizedBox(width: 16),

          // 1st Place
          Flexible(
            child: PodiumItem(
              rank: 1,
              name: "Gilang Kencana",
              points: "201 Pts",
              height: 150,
              color: Colors.amber.shade300,
              avatar:
                  "https://ui-avatars.com/api/?name=Gilang+Kencana&background=f59e0b&color=fff",
            ),
          ),
          const SizedBox(width: 16),

          // 3rd Place
          Flexible(
            child: PodiumItem(
              rank: 3,
              name: "Narpati Lukita",
              points: "150 Pts",
              height: 100,
              color: Colors.orange.shade300,
              avatar:
                  "https://ui-avatars.com/api/?name=Narpati+Lukita&background=f97316&color=fff",
            ),
          ),
        ],
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
        // Crown for 1st place
        if (rank == 1)
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 20,
            ),
          ),

        // Avatar
        CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatar)),
        const SizedBox(height: 6),

        // Name - Fixed width and ellipsis
        SizedBox(
          width: 70,
          child: Text(
            name,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),

        // Points
        Text(
          points,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),

        // Podium
        Container(
          width: 70,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
