import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeadings;
  final Widget titleWidget;
  final Widget? leading;
  final bool? centerTitle;
  final double? leadingWidth;
  final double? titleSpacing;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final double? elevation;

  const CustomeAppBar({
    super.key,
    required this.automaticallyImplyLeadings,
    required this.titleWidget,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.centerTitle = true,
    this.leadingWidth,
    this.titleSpacing,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      iconTheme: IconThemeData(color: isColorValidation(context)),
      actionsIconTheme: IconThemeData(color: isColorValidation(context)),
      automaticallyImplyLeading: automaticallyImplyLeadings,
      actions: actions,
      leading: leading,
      leadingWidth: leadingWidth, // 👈 Pass to AppBar
      titleSpacing: titleSpacing, // 👈 Pass to AppBar
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      centerTitle: centerTitle,
      title: titleWidget,

      elevation: elevation ?? 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
