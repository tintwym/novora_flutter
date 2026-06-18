/// Declared asset paths (images, icons, fonts registered in `pubspec.yaml`).
abstract final class AppAssets {
  /// Square mark — launcher icon source (`flutter_launcher_icons`), favicon, PWA.
  static const appIcon = 'assets/images/app_icon.png';

  /// Icon-only mark (transparent) for dark hero panels and marketing surfaces.
  static const appIconMark = 'assets/images/app_icon_mark.png';

  /// Horizontal wordmark (transparent) for light surfaces.
  static const webLogo = 'assets/images/novora-logo-web-light.png';

  /// Horizontal wordmark (transparent, light text) for dark surfaces.
  static const webLogoDark = 'assets/images/novora-logo-web-dark.png';
}
