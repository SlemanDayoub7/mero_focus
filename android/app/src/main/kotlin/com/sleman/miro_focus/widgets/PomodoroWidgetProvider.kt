package com.sleman.miro_focus.widgets

/** Opens the app and starts the Pomodoro timer immediately. */
class PomodoroWidgetProvider : QuickLaunchWidgetProvider() {
    override val layoutName = "pomodoro_widget"
    override val rootViewName = "pomodoro_widget_root"
    override val launchUri = "merofocus://pomodoro/start"
}
