// AGP 9 compiles Kotlin itself ("built-in Kotlin"); the Kotlin plugins below add Compose and serialization.
plugins {
    id("com.android.application") version "9.5.0" apply false
    id("org.jetbrains.kotlin.plugin.compose") version "2.3.0" apply false
    id("org.jetbrains.kotlin.plugin.serialization") version "2.3.0" apply false
}
