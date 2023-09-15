// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewGalleryScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const PhotoViewGalleryScreen({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _PhotoViewGalleryScreenState createState() => _PhotoViewGalleryScreenState();
}

class _PhotoViewGalleryScreenState extends State<PhotoViewGalleryScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: PhotoViewGallery.builder(
              itemCount: widget.imageUrls.length,
              builder: (_, index) => PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
              ),
              onPageChanged: (index) => setState(() => _currentIndex = index),
              pageController: _pageController,
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(color: kPrimaryColor),
            ),
          ),
          Positioned(
            top: 50,
            right: 50,
            child: IconButton(
              icon: Icon(Icons.close, size: 50),
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
