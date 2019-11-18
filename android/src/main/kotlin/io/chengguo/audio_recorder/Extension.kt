package com.isvisoft.flutter_screen_recording

inline fun <T> T?.letNull(predicate: () -> T): T {
    if (this == null) {
        return predicate()
    }
    return this
}

inline fun <T> T?.notNull(predicate: (T) -> Unit) {
    if (this != null) {
        predicate(this)
    }
}