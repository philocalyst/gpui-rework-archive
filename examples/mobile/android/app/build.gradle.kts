plugins {
    id("com.android.application")
}

android {
    namespace = "dev.gpui.mobile.example"
    compileSdk = 36

    buildToolsVersion = "36.0.0"

    defaultConfig {
        applicationId = "dev.gpui.mobile.example"
        minSdk = 26
        targetSdk = 36
        versionCode = 1
        versionName = "0.1.0"
        ndk { abiFilters += setOf("arm64-v8a", "x86_64") }
        manifestPlaceholders["nativeLibraryName"] = "gpui_ce_mobile_example"
    }

    buildTypes {
        debug { isDebuggable = true; isJniDebuggable = true }
        release { isMinifyEnabled = false }
    }

    sourceSets["main"].jniLibs.srcDirs("src/main/jniLibs")
    // Stored uncompressed, the emoji font is mapped from the APK instead of copied at startup.
    androidResources { noCompress += "ttf" }
    lint { abortOnError = false; checkReleaseBuilds = false }
}
