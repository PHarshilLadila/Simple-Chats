// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/theme/bloc/theme_bloc.dart';
import 'package:chat_app_bloc/theme/bloc/theme_event.dart';
import 'package:chat_app_bloc/theme/bloc/theme_state.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeSettingsWidget extends StatelessWidget {
  const ThemeSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color Selection
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.darkSurface
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBorderColor
                      : AppColor.borderColor,
                ),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ListTileTheme(
                  minLeadingWidth: 0,
                  horizontalTitleGap: 12,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    childrenPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: state.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.palette,
                        color: state.primaryColor,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      'Primary Color',
                      style: GoogleFonts.poppins(
                        color: AppColor.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      state.colorName,
                      style: GoogleFonts.poppins(
                        color: AppColor.textSecondary,
                        fontSize: 13,
                        letterSpacing: 0.2,
                      ),
                    ),
                    trailing: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: state.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    collapsedIconColor: state.primaryColor,
                    iconColor: state.primaryColor,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: AppColor.availableColors.entries.map((entry) {
                          return GestureDetector(
                            onTap: () {
                              context.read<ThemeBloc>().add(
                                    ChangePrimaryColorEvent(
                                      color: entry.value,
                                      colorName: entry.key,
                                    ),
                                  );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: entry.value,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: state.colorName == entry.key
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 1,
                                ),
                                boxShadow: state.colorName == entry.key
                                    ? [
                                        BoxShadow(
                                          color: entry.value.withOpacity(0.2),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        )
                                      ]
                                    : null,
                              ),
                              child: state.colorName == entry.key
                                  ? Center(
                                      child: Icon(
                                        Icons.check,
                                        color: isColorValidation(context),
                                        size: 18,
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
