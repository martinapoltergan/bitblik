package app.bitblik

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "installedPackages" -> {
                        val wanted = call.argument<List<String>>("packages")
                        if (wanted == null) {
                            result.error("bad_args", "packages must be a list of strings", null)
                        } else {
                            result.success(wanted.filter { isInstalled(it) })
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Only answers for packages declared in <queries> in the manifest. Anything else
     * throws NameNotFoundException exactly as if it were absent, which is the whole
     * point of scoped package visibility: no QUERY_ALL_PACKAGES, no way to enumerate.
     */
    private fun isInstalled(packageName: String): Boolean =
        try {
            packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }

    private companion object {
        const val CHANNEL = "app.bitblik/installed_packages"
    }
}
