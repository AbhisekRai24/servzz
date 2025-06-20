import 'dart:async';
import 'package:flutter/material.dart';
import 'package:servzz/features/home/presentation/view_model/banner_slider.dart';

class SliderState extends State<BannerSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.95);
  final List<String> _imageList = [
    "assets/image/food_banner.jpg",
    "assets/image/offer_banner_1.jpg",
    "assets/image/offer_banner_2.jpg",
    "assets/image/offer_banner_3.jpg",
  ];

  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _imageList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _imageList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                _imageList[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        },
      ),
    );
  }
}
