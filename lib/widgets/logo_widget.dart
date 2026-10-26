import 'package:flutter/material.dart';

class ConnectWorldLogo extends StatelessWidget {
  final double size;
  const ConnectWorldLogo({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF4500), Color(0xFFFF8C00), Color(0xFFFFD700)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withValues(alpha: 0.5),
            blurRadius: size * 0.35,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.public_rounded,
            color: Colors.white,
            size: size * 0.65,
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Color(0xFF121216),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shield_rounded,
                color: Colors.amberAccent,
                size: size * 0.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
