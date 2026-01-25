import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

// --- BRAND CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF274B7F); // BTLR Sapphire Blue
const Color kBackgroundWhite = Color(0xFFFFFFFF);
const Color kFieldFillColor = Color(0xFFF2F5F9);
const Color kErrorRed = Color(0xFFD32F2F); // High-visibility distinguished error color
const double kBorderRadius = 12.0;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ScrollController _loginScrollController = ScrollController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginScrollController.dispose();
    super.dispose();
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await ref.read(authStateProvider.notifier).signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, anim, secAnim) => const HomeScreen(),
            transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(opacity: anim, child: child),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: kErrorRed,
            behavior: SnackBarBehavior.floating,
            width: 400,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      body: Scrollbar(
        controller: _loginScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _loginScrollController,
          child: _SmoothEntrance(
            duration: const Duration(milliseconds: 1500),
            child: Container(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- MASSIVE BRANDING ---
                      const Text(
                        "BTLR",
                        style: TextStyle(
                          fontSize: 120, // Mind-boggling size
                          fontWeight: FontWeight.w900,
                          color: kPrimaryBlue,
                          letterSpacing: -6,
                          height: 0.9,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "WELCOME BACK",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 6,
                            color: kPrimaryBlue,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      const SizedBox(height: 70),

                      _buildTextField(
                        controller: _emailController,
                        hint: "EMAIL ADDRESS",
                        icon: Icons.alternate_email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => (value == null || value.isEmpty) ? 'REQUIRED' : null,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        controller: _passwordController,
                        hint: "PASSWORD",
                        icon: Icons.lock_open_rounded,
                        obscure: _obscurePassword,
                        suffix: IconButton(
                          icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: kPrimaryBlue.withOpacity(0.5)
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'REQUIRED' : null,
                      ),
                      const SizedBox(height: 50),

                      _buildPrimaryButton(text: "LOG IN", isLoading: _isLoading, onPressed: _handleSignIn),
                      const SizedBox(height: 35),

                      GestureDetector(
                        onTap: _navigateToSignUp,
                        child: RichText(
                          text: const TextSpan(
                            text: "NEW HERE? ",
                            style: TextStyle(color: Colors.grey, fontSize: 13, letterSpacing: 1),
                            children: [
                              TextSpan(
                                text: "CREATE ACCOUNT",
                                style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ScrollController _signUpScrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _signUpScrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await ref.read(authStateProvider.notifier).signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      userName: _nameController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, anim, secAnim) => const HomeScreen(),
            transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(opacity: anim, child: child),
          ),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      body: Scrollbar(
        controller: _signUpScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _signUpScrollController,
          child: _SmoothEntrance(
            duration: const Duration(milliseconds: 1500),
            child: Container(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "JOIN BTLR",
                        style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.w900,
                            color: kPrimaryBlue,
                            letterSpacing: -5,
                            height: 0.9
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "CREATE YOUR ACCOUNT",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 4,
                            color: kPrimaryBlue,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      const SizedBox(height: 60),

                      _buildTextField(
                        controller: _nameController,
                        hint: "FULL NAME",
                        icon: Icons.person_outline,
                        validator: (value) => (value == null || value.isEmpty) ? 'REQUIRED' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        hint: "EMAIL ADDRESS",
                        icon: Icons.email_outlined,
                        validator: (value) => (value == null || value.isEmpty) ? 'REQUIRED' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        hint: "PASSWORD",
                        icon: Icons.lock_outline,
                        obscure: true,
                        validator: (value) => (value == null || value.isEmpty) ? 'REQUIRED' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hint: "CONFIRM PASSWORD",
                        icon: Icons.check_circle_outline,
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'REQUIRED';
                          if (value != _passwordController.text) return 'PASSWORDS DO NOT MATCH';
                          return null;
                        },
                      ),

                      const SizedBox(height: 60),
                      _buildPrimaryButton(text: "REGISTER", isLoading: _isLoading, onPressed: _handleSignUp),
                      const SizedBox(height: 35),

                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                          text: const TextSpan(
                            text: "ALREADY JOINED? ",
                            style: TextStyle(color: Colors.grey, fontSize: 13, letterSpacing: 1),
                            children: [
                              TextSpan(
                                text: "LOG IN",
                                style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- SHARED UI HELPERS ---

Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool obscure = false,
  Widget? suffix,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  return _HoverTextField(
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(
          color: kPrimaryBlue,
          fontSize: 17,
          fontWeight: FontWeight.w600
      ),
      cursorColor: kPrimaryBlue,
      decoration: InputDecoration(
        filled: true,
        fillColor: kFieldFillColor,
        prefixIcon: Icon(icon, color: kPrimaryBlue.withOpacity(0.8), size: 22),
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: TextStyle(
            color: kPrimaryBlue.withOpacity(0.4),
            fontSize: 13,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w500
        ),
        // DISTINGUISHED FIELD BORDERS
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.1), width: 1.0)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: BorderSide(color: kPrimaryBlue.withOpacity(0.1), width: 1.0)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: const BorderSide(color: kPrimaryBlue, width: 2.0)
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
        // --- DISTINGUISHED ERROR STYLE ---
        errorStyle: const TextStyle(
          color: kErrorRed,
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}

class _HoverTextField extends StatefulWidget {
  final Widget child;
  const _HoverTextField({required this.child});
  @override
  State<_HoverTextField> createState() => _HoverTextFieldState();
}

class _HoverTextFieldState extends State<_HoverTextField> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
          boxShadow: [
            if (_isHovered)
              BoxShadow(color: kPrimaryBlue.withOpacity(0.15), blurRadius: 20, spreadRadius: 2),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

Widget _buildPrimaryButton({required String text, required bool isLoading, required VoidCallback? onPressed}) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 72),
        backgroundColor: kPrimaryBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius)),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 3)),
    ),
  );
}

class _SmoothEntrance extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const _SmoothEntrance({required this.child, required this.duration});
  @override
  State<_SmoothEntrance> createState() => _SmoothEntranceState();
}

class _SmoothEntranceState extends State<_SmoothEntrance> {
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 150), () => setState(() => _visible = true));
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration,
      opacity: _visible ? 1.0 : 0.0,
      curve: Curves.easeInOutCubic,
      child: AnimatedPadding(
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(top: _visible ? 0 : 60),
        child: widget.child, // Corrected parameter usage
      ),
    );
  }
}