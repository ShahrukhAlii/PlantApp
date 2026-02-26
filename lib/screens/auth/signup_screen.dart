import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import 'login_screen.dart';
import '../plant_guide_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool loading = false;
  bool agree = true;

  // Email/Password signup
  void signupUser() async {
    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to Terms & Conditions')),
      );
      return;
    }
    setState(() => loading = true);
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await userCredential.user!.updateDisplayName(nameController.text.trim());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Signup failed')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  // Google Sign-In
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
        MaterialPageRoute(builder: (_) => const PlantGuideScreen()),
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
                const Text('Plantify',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 48),
            const Text('Create An Account',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            PlantifyInput(
                controller: nameController,
                hintText: 'Full Name',
                icon: Icons.person_outline),
            const SizedBox(height: 16),
            PlantifyInput(
                controller: emailController, hintText: 'Mail', icon: Icons.mail_outline),
            const SizedBox(height: 16),
            PlantifyInput(
                controller: passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true),
            const SizedBox(height: 16),
            PlantifyInput(
                controller: confirmController,
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                isPassword: true),
            const SizedBox(height: 24),
            Row(
              children: [
                Checkbox(
                  value: agree,
                  onChanged: (v) => setState(() => agree = v!),
                  side: const BorderSide(color: Colors.white54),
                ),
                const Expanded(
                    child: Text('I agree to all Terms & Conditions',
                        style: TextStyle(color: Colors.white70, fontSize: 12))),
              ],
            ),
            const SizedBox(height: 24),
            PlantifyButton(
              text: loading ? 'Signing up...' : 'Sign up',
              isPrimary: false,
              onPressed: loading ? null : signupUser,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?',
                    style: TextStyle(color: Colors.white70)),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text('or continue using',
                  style: TextStyle(color: Colors.white54)),
            ),
            const SizedBox(height: 24),
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