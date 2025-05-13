import 'dart:convert';

import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  final String? imageurl;
  StaggerAnimation({super.key, required this.controller, this.imageurl})
      : opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              0.100,
              curve: Curves.ease,
            ),
          ),
        ),
        width = Tween<double>(begin: 50.0, end: 300.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.125,
              0.250,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(begin: 50.0, end: 300.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 16),
          end: const EdgeInsets.only(bottom: 50),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(4),
          end: BorderRadius.circular(20),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.375,
              0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        color = ColorTween(
          begin: AppColor.backgroundColor,
          end: AppColor.mainColor,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.500,
              0.750,
              curve: Curves.ease,
            ),
          ),
        );

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius?> borderRadius;
  final Animation<Color?> color;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15),
      child: Container(
        padding: padding.value,
        alignment: Alignment.bottomCenter,
        child: Opacity(
          opacity: opacity.value,
          child: Container(
            width: width.value,
            height: height.value,
            decoration: BoxDecoration(
              color: color.value,
              border: Border.all(
                color: const Color.fromARGB(255, 46, 92, 54),
                width: 1,
              ),
              borderRadius: borderRadius.value,
            ),
            child: ClipRRect(
              borderRadius: borderRadius.value ?? BorderRadius.zero,
              child: Image.memory(
                base64Decode(imageurl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
