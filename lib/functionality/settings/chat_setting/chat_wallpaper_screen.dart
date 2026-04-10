import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/app_widget/app_snackbar.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_bloc.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_event.dart';
import 'package:chat_app_bloc/functionality/settings/chat_setting/bloc/chat_setting_state.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatWallpaperScreen extends StatefulWidget {
  const ChatWallpaperScreen({super.key});

  @override
  State<ChatWallpaperScreen> createState() => _ChatWallpaperScreenState();
}

class _ChatWallpaperScreenState extends State<ChatWallpaperScreen> {
  String? selectedPath;

  final List<String> wallpapers = [
    'assets/images/background.jpg',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=1000&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1503796964332-e25e282e390f?q=80&w=765&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1521433849537-1d4ead3ddaf9?q=80&w=735&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1538986010276-34ea89ccbd72?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1540065835187-718dc1c4209c?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=1000&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?q=80&w=1000&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?q=80&w=1000&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1501854140801-50d01698950b?q=80&w=1000&auto=format&fit=crop',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatSettingBloc, ChatSettingState>(
      builder: (context, state) {
        selectedPath ??= state.wallpaperPath;

        return Scaffold(
          backgroundColor: AppColor.backgroundColor,
          appBar: CustomeAppBar(
            automaticallyImplyLeadings: true,
            titleWidget: Text(
              "Chat Wallpaper",
              style: GoogleFonts.poppins(
                color: isColorValidation(context),
                fontWeight: FontWeight.w600,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<ChatSettingBloc>().add(ResetWallpaper());
                  setState(() {
                    selectedPath = 'assets/images/background.jpg';
                  });
                  AppSnackbar.success(context, "Wallpaper reset to default");
                },
                child: Text(
                  "Reset",
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<ChatSettingBloc>()
                      .add(UpdateWallpaper(selectedPath!));
                  AppSnackbar.success(
                      context, "Wallpaper applied successfully");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Set Wallpaper",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Preview Section
                Container(
                  height: 400,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        _buildWallpaperImage(selectedPath!),
                        Container(
                          color: Colors.black.withOpacity(0.2),
                        ),
                        _buildPreviewChat(),
                      ],
                    ),
                  ),
                ),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: wallpapers.length,
                  itemBuilder: (context, index) {
                    final path = wallpapers[index];
                    final isSelected = selectedPath == path;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPath = path;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: _buildWallpaperImage(path, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),

                // Apply Button
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWallpaperImage(String path, {BoxFit fit = BoxFit.cover}) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        ),
      );
    } else {
      return Image.asset(
        path,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }

  Widget _buildPreviewChat() {
    return Column(
      children: [
        const SizedBox(height: 40),
        _buildChatBubble("Hey there! How's it going?", true),
        _buildChatBubble("I'm doing great! Check out this wallpaper.", false),
        _buildChatBubble("Looks amazing! 😍", true),
      ],
    );
  }

  Widget _buildChatBubble(String text, bool isSender) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSender
              ? Theme.of(context).primaryColor.withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isSender ? 15 : 0),
            bottomRight: Radius.circular(isSender ? 0 : 15),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isSender ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
