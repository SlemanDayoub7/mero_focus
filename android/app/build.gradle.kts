plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Namespace also fixes the package of generated R/BuildConfig and of the
    // manifest placeholder used by GeneratedPluginRegistrant. Keep it in sync
    // with the MainActivity Kotlin package.
    namespace = "com.sleman.miro_focus"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Base (published) application id. The dev flavor appends ".dev".
        applicationId = "com.sleman.miro_focus"
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // See docs/en/03-process/build-flavors.md.
    // AGP forbids a product flavor sharing a name with a build type, so the
    // published flavor is `prod` (the `release` build type is standard and
    // cannot be renamed). Its application id is still com.sleman.miro_focus.
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Mero Focus (Dev)")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "Mero Focus")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Required by flutter_local_notifications.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
