import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/config/app_assets.dart';
// import 'package:laundry_app/config/app_assets.dart';

class HomeEmptyPage extends StatelessWidget {
  const HomeEmptyPage({
    super.key,
    required this.ratio,
    required this.message,
  });

  final double ratio;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ratio,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                    AppAssets.emptyPage,
                  ),
                  fit: BoxFit.cover,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    offset: const Offset(5, 3),
                  )
                ]),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
