# Keep rules for Kotlin types that plugins resolve by name through JNI.
#
# Pigeon's JNI bindings (`package:jni`) look these classes up with
# `JClass.forName(...)` and then resolve fields/methods by their exact JVM
# names and signatures. R8 shrinks and renames Kotlin's standard library in
# release builds by default, which breaks those lookups at runtime, e.g.
#   java.lang.NoSuchMethodError: ... SharedPreferencesApiRegistrar.getAll(...)
#   java.lang.ClassNotFoundException: kotlin/coroutines/intrinsics/CoroutineSingletons
#
# Each name below is referenced literally in `package:jni`'s `kotlin.dart`.
-keep class kotlin.coroutines.Continuation { *; }
-keep class kotlin.coroutines.intrinsics.CoroutineSingletons { *; }
-keep class kotlin.coroutines.intrinsics.IntrinsicsKt { *; }
-keep class kotlin.coroutines.intrinsics.IntrinsicsKt__IntrinsicsKt { *; }
-keep class kotlin.Result { *; }
-keep class kotlin.Result$Failure { *; }
-keep class kotlin.Unit { *; }
-keep class kotlin.jvm.internal.DefaultConstructorMarker { *; }
