# Flutter specific
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Zego
-keep class im.zego.** { *; }
-dontwarn im.zego.**

# Jackson
-keep class com.fasterxml.jackson.** { *; }
-dontwarn com.fasterxml.jackson.**

# Java Beans
-keep class java.beans.** { *; }
-dontwarn java.beans.**

# DOM
-keep class org.w3c.dom.** { *; }
-dontwarn org.w3c.dom.**

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**

# Audio/Video plugins
-keep class com.ryanheise.audioservice.** { *; }
-keep class com.ryanheise.audiosession.** { *; }

# File picker
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# Keep generic signatures
-keepattributes Signature

# Keep annotation
-keepattributes *Annotation*

# Keep source file names and line numbers
-keepattributes SourceFile,LineNumberTable

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepnames class * implements java.io.Serializable

# Keep R8 from stripping Kotlin metadata
-keep class kotlin.Metadata { *; }