import 'package:flutter/material.dart';

class SendEmailAnimation extends StatefulWidget {
  const SendEmailAnimation({super.key});

  @override
  State<SendEmailAnimation> createState() => _SendEmailAnimationState();
}

class _SendEmailAnimationState extends State<SendEmailAnimation>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  double containerLeftPedding = 20.0;
  double? animationValue;
  double translateX = 0;
  double translateY = 0;
  double roated = 0;
  double scale = 1;
  bool? show;
  bool send = false;
  Color color = Colors.lightBlue;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 1300),
    );
    show = true;
    animationController.addListener(() {
      setState(() {
        show = false;
        animationValue = animationController.value;
        if (animationValue! >= 0.2 && animationValue! < 0.4) {
          containerLeftPedding = 100.0;
          color = Colors.green;
        } else if (animationValue! >= 0.4 && animationValue! <= 0.5) {
          translateX = 80.0;
          roated = -20.0;
          scale = 0.1;
        } else if (animationValue! >= 0.5 && animationValue! <= 0.8) {
          translateY = -20.0;
        } else if (animationValue! >= 0.81) {
          containerLeftPedding = 20.0;
          send = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
