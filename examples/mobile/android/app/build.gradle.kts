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
        testInstrumentationRunner = "dev.gpui.mobile.test.PlatformViewProbeInstrumentation"
        versionName = "0.1.0"
        ndk { abiFilters += setOf("arm64-v8a", "x86_64") }
        manifestPlaceholders["nativeLibraryName"] = "gpui_ce_mobile_example"
    }

    buildTypes {
        debug { isDebuggable = true; isJniDebuggable = true }
        release { isMinifyEnabled = false }
    }

    sourceSets["main"].jniLibs.srcDirs("src/main/jniLibs")
    // build.sh strips staged NDK outputs and keeps originals outside the APK.
    // Skip AGP Maven stripping, which is not executable on the Nix host.
    packaging { jniLibs { keepDebugSymbols += setOf(
        "*/arm64-v8a/libgpui_ce_mobile_example.so",
        "*/x86_64/libgpui_ce_mobile_example.so",
        "*/arm64-v8a/libgpui_mobile.so",
        "*/x86_64/libgpui_mobile.so",
    ) } }
    lint { abortOnError = false; checkReleaseBuilds = false }
}
