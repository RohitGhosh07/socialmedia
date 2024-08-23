import 'package:flutter/material.dart';
import 'package:swipecv/models/image_model.dart';

class ZoomView extends StatelessWidget {
  const ZoomView({
    super.key,
    required this.images,
  });

  final ImageModel images;

  @override
  Widget build(BuildContext context) {
    final TransformationController controller = TransformationController();

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onDoubleTap: () {
                  // zoom out or zoom in
                  if (controller.value.getMaxScaleOnAxis() > 1) {
                    controller.value = Matrix4.identity();
                  } else {
                    controller.value = Matrix4.identity()..scale(2.0);
                  }
                },
                child: InteractiveViewer(
                  transformationController: controller,
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.1,
                  maxScale: 2.0,
                  child:
                      Image.network(images.imgUrl ?? '', fit: BoxFit.fitWidth),
                ),
              ),
            ),
            // Pop Button
            Positioned(
              top: 50,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
