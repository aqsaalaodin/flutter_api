import 'package:flutter/material.dart';
import 'package:flutter_api/api_service.dart';
import 'package:flutter_api/homescreen.dart';
import 'dart:ui';
//import '../services/api_service.dart';
//import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameOrEmailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const _cyan = Color(0xFF00D4FF);
  static const _amber = Color(0xFFFFB347);
  static const _bg = Color(0xFF0A0E1A);
  static const _surface = Color(0xFF111827);
  static const _cardBorder = Color(0xFF1E2940);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameOrEmailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await ApiService.login(
        usernameOrEmail: _usernameOrEmailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _buildCard(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -80,
          child: _glowCircle(_cyan.withOpacity(0.18), 300),
        ),
        Positioned(
          bottom: -100,
          right: -60,
          child: _glowCircle(_amber.withOpacity(0.12), 280),
        ),
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _GridPainter(),
        ),
      ],
    );
  }

  Widget _glowCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }

  Widget _buildCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: _surface.withOpacity(0.85),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _cardBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: _cyan.withOpacity(0.06),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(28, 40, 28, 36),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 36),
                _buildUsernameField(),
                const SizedBox(height: 18),
                _buildPasswordField(),
                const SizedBox(height: 10),
                _buildForgotPassword(),
                const SizedBox(height: 24),
                if (_errorMessage != null) _buildErrorBanner(),
                const SizedBox(height: 8),
                _buildLoginButton(),
                const SizedBox(height: 28),
                _buildDivider(),
                const SizedBox(height: 24),
                _buildSignUpRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [_cyan, Color(0xFF0077FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(color: _cyan.withOpacity(0.4), blurRadius: 16),
            ],
          ),
          child:
              const Icon(Icons.bolt_rounded, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 22),
        const Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Sign in to your account',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.45),
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return _StyledField(
      controller: _usernameOrEmailCtrl,
      label: 'Username or Email',
      hint: 'john_doe  or  you@example.com',
      icon: Icons.person_outline_rounded,
      keyboardType: TextInputType.text,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Username or email is required';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return _StyledField(
      controller: _passwordCtrl,
      label: 'Password',
      hint: '••••••••',
      icon: Icons.lock_outline_rounded,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.white38,
          size: 20,
        ),
        onPressed: () =>
            setState(() => _obscurePassword = !_obscurePassword),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Password is required';
        if (v.length < 4) return 'At least 4 characters';
        return null;
      },
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: _cyan,
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 32),
        ),
        child: const Text(
          'Forgot password?',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4D6D).withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF4D6D).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFFF4D6D), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Color(0xFFFF4D6D),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: _isLoading
              ? null
              : const LinearGradient(
                  colors: [_cyan, Color(0xFF0077FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: _isLoading ? _cardBorder : null,
          boxShadow: _isLoading
              ? []
              : [
                  BoxShadow(
                    color: _cyan.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: _cyan,
                    strokeWidth: 2.4,
                  ),
                )
              : const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 12,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
      ],
    );
  }

  Widget _buildSignUpRow() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 13,
          ),
          children: [
            const TextSpan(text: "Don't have an account? "),
            WidgetSpan(
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: _amber,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable styled field ────────────────────────────────────────────────────
class _StyledField extends StatelessWidget {
  const _StyledField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  static const _cyan = Color(0xFF00D4FF);
  static const _fieldBg = Color(0xFF0D1525);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
            prefixIcon: Icon(icon, color: Colors.white38, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: _fieldBg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _cyan, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFFFF4D6D), width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFFFF4D6D), width: 1.4),
            ),
            errorStyle: const TextStyle(
              color: Color(0xFFFF4D6D),
              fontSize: 12,
            ),
          ),
        ),
      ],
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