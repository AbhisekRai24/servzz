import 'package:flutter/material.dart';
import 'package:servzz/features/banner_slider/presentation/view_model/slider_state.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => SliderState(); // ✅ Correct
}
