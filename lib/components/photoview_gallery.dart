import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// class FullScreenImage extends StatelessWidget {
//   final ImageProvider<Object> imageProvider;

//   const FullScreenImage({Key? key, required this.imageProvider}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () => Navigator.of(context).pop(),
//         child: Center(
//           child: PhotoView(
//             imageProvider: imageProvider,
//             initialScale: PhotoViewComputedScale.contained,
//             maxScale: PhotoViewComputedScale.covered,
//             enableRotation: true,
//           ),
//         ),
//       ),
//     );
//   }
// }

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
        body: Stack(children: [
      Container(
        child: PhotoViewGallery.builder(
          itemCount: widget.imageUrls.length,
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.imageUrls[index]),
              initialScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
            );
          },
          onPageChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          pageController: _pageController,
        ),
      ),
    ]));
  }
}
