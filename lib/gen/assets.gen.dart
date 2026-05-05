// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/barcode.png
  AssetGenImage get barcode => const AssetGenImage('assets/icons/barcode.png');

  /// File path: assets/icons/card_member.png
  AssetGenImage get cardMember =>
      const AssetGenImage('assets/icons/card_member.png');

  /// File path: assets/icons/date_in.png
  AssetGenImage get dateIn => const AssetGenImage('assets/icons/date_in.png');

  /// File path: assets/icons/date_order.png
  AssetGenImage get dateOrder =>
      const AssetGenImage('assets/icons/date_order.png');

  /// File path: assets/icons/district.png
  AssetGenImage get district =>
      const AssetGenImage('assets/icons/district.png');

  /// File path: assets/icons/ediprofile.png
  AssetGenImage get ediprofile =>
      const AssetGenImage('assets/icons/ediprofile.png');

  /// File path: assets/icons/gridicons_product.png
  AssetGenImage get gridiconsProduct =>
      const AssetGenImage('assets/icons/gridicons_product.png');

  /// File path: assets/icons/home.png
  AssetGenImage get home => const AssetGenImage('assets/icons/home.png');

  /// File path: assets/icons/hubungiadmin.png
  AssetGenImage get hubungiadmin =>
      const AssetGenImage('assets/icons/hubungiadmin.png');

  /// File path: assets/icons/logout.png
  AssetGenImage get logout => const AssetGenImage('assets/icons/logout.png');

  /// File path: assets/icons/orderan.png
  AssetGenImage get orderan => const AssetGenImage('assets/icons/orderan.png');

  /// File path: assets/icons/person.png
  AssetGenImage get person => const AssetGenImage('assets/icons/person.png');

  /// File path: assets/icons/person2.png
  AssetGenImage get person2 => const AssetGenImage('assets/icons/person2.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    barcode,
    cardMember,
    dateIn,
    dateOrder,
    district,
    ediprofile,
    gridiconsProduct,
    home,
    hubungiadmin,
    logout,
    orderan,
    person,
    person2,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/bg_picking_man.png
  AssetGenImage get bgPickingMan =>
      const AssetGenImage('assets/images/bg_picking_man.png');

  /// File path: assets/images/picking_man.png
  AssetGenImage get pickingMan =>
      const AssetGenImage('assets/images/picking_man.png');

  /// List of all assets
  List<AssetGenImage> get values => [bgPickingMan, pickingMan];
}

class $AssetsLogoGen {
  const $AssetsLogoGen();

  /// File path: assets/logo/logo.jpeg
  AssetGenImage get logo => const AssetGenImage('assets/logo/logo.jpeg');

  /// List of all assets
  List<AssetGenImage> get values => [logo];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLogoGen logo = $AssetsLogoGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
