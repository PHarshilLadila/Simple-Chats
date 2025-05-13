import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeadings;
  final Widget titleWidget;
  final Widget? leading;

  final List<Widget>? actions;

  const CustomeAppBar({
    super.key,
    required this.automaticallyImplyLeadings,
    required this.titleWidget,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      iconTheme: IconThemeData(color: AppColor.whiteColor),
      automaticallyImplyLeading: automaticallyImplyLeadings,
      actions: actions,
      leading: leading,
      backgroundColor: AppColor.mainColor,
      centerTitle: true,
      title: titleWidget,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
