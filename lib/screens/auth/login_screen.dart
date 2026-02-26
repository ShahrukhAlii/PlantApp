import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../home_screen.dart';
import 'signup_screen.dart';
import '../plant_guide_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  // Email/Password login
  void loginUser() async {
    setState(() => loading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PlantGuideScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  // Google Sign-In (Web + Mobile)
  Future<void> signInWithGoogle() async {
    setState(() => loading = true);
    try {
      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(authProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          setState(() => loading = false);
          return; // User canceled
        }
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.eco, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Plantify',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 48),
            const Text(
              'Welcome Back',
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            // Email input
            PlantifyInput(
              controller: emailController,
              hintText: 'Mail',
              icon: Icons.mail_outline,
            ),
            const SizedBox(height: 16),
            // Password input
            PlantifyInput(
              controller: passwordController,
              hintText: 'Password',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 24),
            // Login button
            PlantifyButton(
              text: loading ? 'Logging in...' : 'Login',
              isPrimary: true,
              onPressed: loading ? null : loginUser,
            ),
            const SizedBox(height: 16),
            // Signup navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?',
                    style: TextStyle(color: Colors.white70)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text('or continue using',
                  style: TextStyle(color: Colors.white54)),
            ),
            const SizedBox(height: 24),
            // Social login buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: loading ? null : signInWithGoogle,
                  child: const _SocialIcon(icon: Icons.g_mobiledata, color: Colors.red),
                ),
                const SizedBox(width: 24),
                const _SocialIcon(icon: Icons.facebook, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Social login button
class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _SocialIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration:
      const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 40),
    );
  }
}