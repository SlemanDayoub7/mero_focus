package com.sleman.miro_focus.widgets

/** Opens the app for habit tracking. */
class HabitsWidgetProvider : QuickLaunchWidgetProvider() {
    override val layoutName = "habits_widget"
    override val rootViewName = "habits_widget_root"
    override val launchUri = "merofocus://habits/open"
}
