package com.sleman.miro_focus.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.net.Uri
import android.widget.RemoteViews

/**
 * Base class of the home-screen widgets. Tapping the widget launches the app
 * with a merofocus:// address; the Flutter side (HomeWidgetBridge) reads it.
 *
 * Resources are looked up by name at runtime, so this file does not depend on
 * the app's R class or on the Android package name / flavors.
 */
abstract class QuickLaunchWidgetProvider : AppWidgetProvider() {

    protected abstract val layoutName: String
    protected abstract val rootViewName: String
    protected abstract val launchUri: String

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val resources = context.resources
        val layoutId = resources.getIdentifier(layoutName, "layout", context.packageName)
        val rootId = resources.getIdentifier(rootViewName, "id", context.packageName)
        if (layoutId == 0 || rootId == 0) return

        val launch = context.packageManager.getLaunchIntentForPackage(context.packageName) ?: return
        // Same action/data contract the home_widget Flutter plugin listens for.
        launch.action = "es.antonborri.home_widget.action.LAUNCH"
        launch.data = Uri.parse(launchUri)

        val pending = PendingIntent.getActivity(
            context,
            layoutId,
            launch,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, layoutId)
            views.setOnClickPendingIntent(rootId, pending)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
