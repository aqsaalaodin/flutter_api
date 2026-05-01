import 'package:flutter/material.dart';
import 'dart:ui';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _cyan = Color(0xFF00D4FF);
  static const _amber = Color(0xFFFFB347);
  static const _bg = Color(0xFF0A0E1A);
  static const _surface = Color(0xFF111827);
  static const _cardBorder = Color(0xFF1E2940);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          _buildBackground(context),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 32),
                  _buildSuccessCard(),
                  const SizedBox(height: 24),
                  _buildInfoGrid(),
                  const Spacer(),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          right: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_cyan.withOpacity(0.15), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_amber.withOpacity(0.10), Colors.transparent],
              ),
            ),
          ),
        ),
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _GridPainter(),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome back, superadmin',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 13,
              ),
            ),
          ],
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [_cyan, Color(0xFF0077FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _cyan.withOpacity(0.35),
                blurRadius: 14,
              ),
            ],
          ),
          child: const Icon(Icons.person_rounded,
              color: Colors.white, size: 22),
        ),
      ],
    );
  }

  Widget _buildSuccessCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _cardBorder, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF87).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF00FF87).withOpacity(0.3),
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF00FF87),
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Authentication Successful',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Token received & session is active',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF87).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Color(0xFF00FF87),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Role', 'Super Admin', Icons.shield_outlined, _cyan)),
        const SizedBox(width: 14),
        Expanded(child: _buildStatCard('Status', 'Active', Icons.circle, const Color(0xFF00FF87))),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color accent) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _surface.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder, width: 1.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: accent, size: 20),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  color: accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoginScreen(),
              transitionsBuilder: (_, anim, __, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: const Duration(milliseconds: 400),
            ),
            (_) => false,
          );
        },
        icon: const Icon(Icons.logout_rounded, color: _amber, size: 18),
        label: const Text(
          'Sign Out',
          style: TextStyle(
            color: _amber,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: _amber.withOpacity(0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

// ── Background grid painter ──────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2940).withOpacity(0.5)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}