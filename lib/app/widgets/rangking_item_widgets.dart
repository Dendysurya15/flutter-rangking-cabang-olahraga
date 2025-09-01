import 'package:flutter/material.dart';

class RankingItem extends StatelessWidget {
  final int rank;
  final String name;
  final String username;
  final String points;
  final String avatar;
  final bool isHighlighted;

  const RankingItem({
    super.key,
    required this.rank,
    required this.name,
    required this.username,
    required this.points,
    required this.avatar,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 350;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.deepPurple.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isHighlighted
                ? Border.all(color: Colors.deepPurple.shade200, width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Rank - Fixed width
              SizedBox(
                width: isSmallScreen ? 24 : 28,
                height: isSmallScreen ? 24 : 28,
                child: Container(
                  decoration: BoxDecoration(
                    color: _getRankColor(),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),

              // Avatar - Fixed size
              CircleAvatar(
                radius: isSmallScreen ? 16 : 18,
                backgroundImage: NetworkImage(avatar),
                backgroundColor: Colors.grey.shade200,
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),

              // Name and Username - Flexible
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isSmallScreen) const SizedBox(height: 2),
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 11,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              SizedBox(width: isSmallScreen ? 4 : 8),

              // Points - Flexible but with constraints
              Flexible(
                flex: 1,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: isSmallScreen ? 40 : 50,
                    maxWidth: isSmallScreen ? 60 : 70,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 4 : 6,
                    vertical: isSmallScreen ? 2 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    points,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 9 : 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getRankColor() {
    if (rank <= 3) return Colors.amber;
    if (rank <= 5) return Colors.deepPurple;
    if (rank <= 10) return Colors.blue;
    return Colors.grey;
  }
}
