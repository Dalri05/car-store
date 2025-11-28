plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // ! NOVO: Plugin do Google Services para o Firebase funcionar
    id("com.google.gms.google-services")
}

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.car_store"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Se você mudou o ID no Firebase, mude aqui também.
        applicationId = "com.example.car_store"

        // ! MUDANÇA: Mudei de flutter.minSdkVersion para 23 para evitar erros do Firebase
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ! NOVO: Configuração da Assinatura (Lendo do key.properties)
    signingConfigs {
        release {
            keyAlias = keystoreProperties['keyAlias']
            keyPassword = keystoreProperties['keyPassword']
            storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword = keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            // ! MUDANÇA: Usando a configuração 'release' que criamos acima
            signingConfig = signingConfigs.release
            // Configurações para manter o código legível e evitar erros na versão release
            minifyEnabled false
            shrinkResources false
        }
    }
}

flutter {
    source = "../.."
}
