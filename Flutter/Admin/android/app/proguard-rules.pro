# Keep rules for plugins that call Kotlin code through JNI (package:jni).
#
# Pigeon's JNI bindings resolve methods by their exact JVM signature, e.g.
#   getAll(Ljava/lang/String;Ljava/util/List;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;
# R8 renames those Kotlin types in release builds by default, which makes the
# lookup fail at runtime with:
#   java.lang.NoSuchMethodError: ... SharedPreferencesApiRegistrar.getAll(...)
# Keeping the type names intact lets the JNI bridge find the methods again.
-keep class kotlin.coroutines.Continuation { *; }
-keep class kotlin.jvm.internal.DefaultConstructorMarker { *; }
