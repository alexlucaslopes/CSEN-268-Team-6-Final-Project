import 'package:flutter/material.dart';
import '../widgets/auth_button.dart';

class AnimatedBulletButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Duration delay;

  const AnimatedBulletButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.delay,
  });

  @override
  State<AnimatedBulletButton> createState() => _AnimatedBulletButtonState();
}

class _AnimatedBulletButtonState extends State<AnimatedBulletButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool showBullet = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => showBullet = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _fadeAnimation.value,
      duration: const Duration(milliseconds: 300),
      child: SlideTransition(
        position: _slideAnimation,
        child: Row(
          children: [
            AnimatedOpacity(
              opacity: showBullet ? 1 : 0,
              duration: const Duration(milliseconds: 1000),
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  "•",
                  style: TextStyle(fontSize: 26, color: Colors.black54),
                ),
              ),
            ),

            // ⭐ Uses your original AuthButton — styling preserved!
            Expanded(
              child: AuthButton(
                label: widget.label,
                onPressed: widget.onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
