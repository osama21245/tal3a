import 'package:flutter/material.dart';

class PhotoFilter {
  final String name;
  final ColorFilter? colorFilter;
  final String? imagePath;

  const PhotoFilter({required this.name, this.colorFilter, this.imagePath});

  static List<PhotoFilter> get filters => [
    const PhotoFilter(name: 'Original', colorFilter: null),
    PhotoFilter(
      name: 'Grayscale',
      colorFilter: ColorFilter.mode(Colors.grey.shade400, BlendMode.saturation),
    ),
    const PhotoFilter(
      name: 'Sepia',
      colorFilter: ColorFilter.matrix(<double>[
        0.393,
        0.769,
        0.189,
        0,
        0,
        0.349,
        0.686,
        0.168,
        0,
        0,
        0.272,
        0.534,
        0.131,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
    ),
    const PhotoFilter(
      name: 'Vintage',
      colorFilter: ColorFilter.matrix(<double>[
        0.6,
        0.3,
        0.1,
        0,
        0,
        0.2,
        0.6,
        0.2,
        0,
        0,
        0.2,
        0.1,
        0.7,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
    ),
  ];
}
