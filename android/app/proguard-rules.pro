# mobile_scanner: keep the plugin, ML Kit barcode scanning and CameraX classes.
# R8 (enabled by default for Flutter release builds) strips/renames classes that
# these libraries load via reflection, which makes the camera fail to start
# with MobileScannerErrorCode.genericError in release while debug works fine.
-keep class dev.steenbakker.mobile_scanner.** { *; }
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_barcode.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_common.** { *; }
-keep class com.google.android.gms.vision.** { *; }
-keep class com.google.android.libraries.barhopper.** { *; }
-keep class com.google.photos.** { *; }
-keep class androidx.camera.** { *; }
-dontwarn com.google.mlkit.**
-dontwarn androidx.camera.**
