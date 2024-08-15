import 'package:flutter/material.dart';
import 'package:wallet_app/product/all_colors.dart';
import 'package:wallet_app/product/all_strings.dart';

class AnimateGestureDetector extends StatefulWidget {
  final Function() onTap;
  final String currentMoneyText;

  const AnimateGestureDetector({super.key, required this.onTap, required this.currentMoneyText});

  @override
  State<AnimateGestureDetector> createState() => _AnimateGestureDetectorState();
}

class _AnimateGestureDetectorState extends State<AnimateGestureDetector> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  final Color _imageColorFirst = AllColors().dollarIconColor;
  final Color _imageColorLast = AllColors().dollarIconColor2nd;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: _imageColorFirst,
      end: _imageColorLast,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.onTap();

        _animationController.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 100), () {
            _animationController.reverse();
          });
        });
      },
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            color: Colors.transparent, // Geri plan rengini saydam yapar
            child: Stack(
              children: [
                Center(
                  child: Image(
                    image: AssetImage(AllStrings().farmingIconAsset),
                    height: 150,
                    color: _colorAnimation.value,
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  child: Text(
                    widget.currentMoneyText,
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(color: TextFieldColors().fieldBorderColor),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
