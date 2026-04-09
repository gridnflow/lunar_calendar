package com.gridnflow.lunar.calendar

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class LunarWidgetSmall : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) updateSmall(context, manager, id)
    }
}

class LunarWidgetMedium : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) updateMedium(context, manager, id)
    }
}

class LunarWidgetLarge : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) updateLarge(context, manager, id)
    }
}

private fun prefs(context: Context) =
    HomeWidgetPlugin.getData(context)

fun updateSmall(context: Context, manager: AppWidgetManager, widgetId: Int) {
    val p = prefs(context)
    val solarDay  = p.getString("solar_day", "--") ?: "--"
    val lunarDate = p.getString("lunar_short", "--/--") ?: "--/--"

    val views = RemoteViews(context.packageName, R.layout.widget_small)
    views.setTextViewText(R.id.widget_solar_day, solarDay)
    views.setTextViewText(R.id.widget_lunar_date, "음$lunarDate")
    manager.updateAppWidget(widgetId, views)
}

fun updateMedium(context: Context, manager: AppWidgetManager, widgetId: Int) {
    val p = prefs(context)
    val solarFull  = p.getString("solar_full", "---- 년 --월 --일") ?: "---- 년 --월 --일"
    val lunarFull  = p.getString("lunar_full", "음력 --월 --일") ?: "음력 --월 --일"
    val dayPillar  = p.getString("day_pillar", "--") ?: "--"
    val solarTerm  = p.getString("solar_term", "") ?: ""

    val views = RemoteViews(context.packageName, R.layout.widget_medium)
    views.setTextViewText(R.id.widget_solar_full, solarFull)
    views.setTextViewText(R.id.widget_lunar_full, lunarFull)
    views.setTextViewText(R.id.widget_day_pillar, "일주  $dayPillar")
    views.setTextViewText(R.id.widget_solar_term, if (solarTerm.isNotEmpty()) "절기  $solarTerm" else "")
    manager.updateAppWidget(widgetId, views)
}

fun updateLarge(context: Context, manager: AppWidgetManager, widgetId: Int) {
    val p = prefs(context)
    val solarFull  = p.getString("solar_full", "---- 년 --월 --일") ?: "---- 년 --월 --일"
    val lunarFull  = p.getString("lunar_full", "음력 --월 --일") ?: "음력 --월 --일"
    val solarTerm  = p.getString("solar_term", "") ?: ""
    val sajuYear   = p.getString("saju_year", "--") ?: "--"
    val sajuMonth  = p.getString("saju_month", "--") ?: "--"
    val sajuDay    = p.getString("saju_day", "--") ?: "--"
    val sajuHour   = p.getString("saju_hour", "--") ?: "--"
    val fortune    = p.getString("fortune_summary", "앱을 열어 운세를 불러오세요") ?: "앱을 열어 운세를 불러오세요"

    val views = RemoteViews(context.packageName, R.layout.widget_large)
    views.setTextViewText(R.id.widget_solar_full, solarFull)
    views.setTextViewText(R.id.widget_lunar_full, lunarFull)
    views.setTextViewText(R.id.widget_solar_term, if (solarTerm.isNotEmpty()) "절기  $solarTerm" else "")
    views.setTextViewText(R.id.widget_saju_year, sajuYear)
    views.setTextViewText(R.id.widget_saju_month, sajuMonth)
    views.setTextViewText(R.id.widget_saju_day, sajuDay)
    views.setTextViewText(R.id.widget_saju_hour, sajuHour)
    views.setTextViewText(R.id.widget_fortune, fortune)
    manager.updateAppWidget(widgetId, views)
}
