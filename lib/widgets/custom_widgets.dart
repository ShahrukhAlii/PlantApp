import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


class PlantifyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // ✅ make nullable
  final bool isPrimary;
  final bool isFullWidth;

  const PlantifyButton({
    super.key,
    required this.text,
    this.onPressed, // ✅ optional now
    this.isPrimary = true,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed, // ✅ can now accept null
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : AppColors.secondary,
          foregroundColor: isPrimary ? AppColors.white : AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PlantifyInput extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;

  const PlantifyInput({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppColors.primary),
          suffixIcon: isPassword ? const Icon(Icons.visibility_off_outlined, color: AppColors.primary) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
}

class RotatingLogo extends StatefulWidget {
  final double size;
  const RotatingLogo({super.key, this.size = 120});

  @override
  State<RotatingLogo> createState() => _RotatingLogoState();
}

class _RotatingLogoState extends State<RotatingLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Circle rotating Anti-Clockwise
          RotationTransition(
            turns: Tween(begin: 1.0, end: 0.0).animate(_controller),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.secondary,
                  width: 4,
                  style: BorderStyle.solid,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: widget.size / 2 - 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Inner Logo rotating Clockwise
          RotationTransition(
            turns: _controller,
            child: Container(
              width: widget.size * 0.7,
              height: widget.size * 0.7,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(widget.size * 0.2),
              ),
              child: Icon(
                Icons.eco,
                size: widget.size * 0.5,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
