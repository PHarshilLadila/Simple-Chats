import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetBottomSheet extends StatelessWidget {
  const NoInternetBottomSheet({super.key});

  static BuildContext? _currentContext;
  static bool _shouldBeShowing = false;

  static void show(BuildContext context) {
    if (_shouldBeShowing) return;
    _shouldBeShowing = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // If while opening, we decided we shouldn't be showing (e.g. internet returned)
        // we close it immediately.
        if (!_shouldBeShowing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          });
        }
        _currentContext = context;
        return const NoInternetBottomSheet();
      },
    ).then((_) {
      _currentContext = null;
      _shouldBeShowing = false;
    });
  }

  static void hide(BuildContext context) {
    _shouldBeShowing = false;
    if (_currentContext != null) {
      if (Navigator.canPop(_currentContext!)) {
        Navigator.of(_currentContext!).pop();
      }
      _currentContext = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/no_internet.jpg',
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.wifi_off,
                          size: 100, color: Colors.grey);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'No Internet Connection',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 40),
              child: Text(
                'Please check your internet settings and try again.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
