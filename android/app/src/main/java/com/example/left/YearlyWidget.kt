package com.example.left

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.os.Bundle
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Yearly Widget - Shows current year with dots for each day
 * Uses row-based layout for proper reflow on resize
 * - Top left: Current year (e.g., "2026")
 * - Top right: Days left including today
 * - Dulled dots: Passed days
 * - Bright dots: Remaining days (including today)
 */
class YearlyWidget : AppWidgetProvider() {
    
    companion object {
        // Yearly dot: 6dp size + 2dp margin each side = 10dp per dot
        private const val DOT_SIZE_WITH_MARGIN_DP = 10
        // Safety margin for launcher padding
        private const val LAUNCHER_PADDING_DP = 24
        private const val MIN_DOTS_PER_ROW = 1
    }
    
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
            updateWidget(context, appWidgetManager, appWidgetId, options)
        }
    }
    
    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        // Widget was resized - rebuild with new dimensions
        updateWidget(context, appWidgetManager, appWidgetId, newOptions)
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        options: Bundle
    ) {
        // Get widget width to calculate dots per row
        val widthDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 300)
        val usableWidthDp = maxOf(0, widthDp - LAUNCHER_PADDING_DP)
        val dotsPerRow = maxOf(MIN_DOTS_PER_ROW, usableWidthDp / DOT_SIZE_WITH_MARGIN_DP)
        
        // Get data from SharedPreferences (sent from Flutter)
        val widgetData = HomeWidgetPlugin.getData(context)
        val year = widgetData.getString("yearly_title", "2026") ?: "2026"
        val totalDays = widgetData.getInt("yearly_total_items", 365)
        val passedDays = widgetData.getInt("yearly_passed_items", 0)
        val daysLeft = totalDays - passedDays

        // Create widget view
        val views = RemoteViews(context.packageName, R.layout.yearly_widget)
        
        // Set year (top left)
        views.setTextViewText(R.id.widget_title, year)
        
        // Set days left (top right) - including today
        views.setTextViewText(R.id.widget_subtitle, "$daysLeft days left")

        // Clear existing rows
        views.removeAllViews(R.id.dots_container)

        // Build rows of dots
        var dotIndex = 0
        while (dotIndex < totalDays) {
            // Create a new row
            val rowView = RemoteViews(context.packageName, R.layout.widget_dot_row)
            
            // Add dots to this row
            val dotsInThisRow = minOf(dotsPerRow, totalDays - dotIndex)
            for (i in 0 until dotsInThisRow) {
                val isDulled = dotIndex < passedDays
                val dotView = createDotView(context, isDulled)
                rowView.addView(R.id.dot_row, dotView)
                dotIndex++
            }
            
            // Add row to container
            views.addView(R.id.dots_container, rowView)
        }

        // Update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    /**
     * Creates a single dot view (6dp for yearly - small and compact)
     */
    private fun createDotView(context: Context, isDulled: Boolean): RemoteViews {
        val dotView = RemoteViews(context.packageName, R.layout.widget_dot_yearly)
        
        val drawable = if (isDulled) R.drawable.dot_passed else R.drawable.dot_active
        dotView.setImageViewResource(R.id.dot_image, drawable)
        
        val alpha = if (isDulled) 100 else 255
        dotView.setInt(R.id.dot_image, "setAlpha", alpha)
        
        return dotView
    }

    override fun onEnabled(context: Context) {}
    override fun onDisabled(context: Context) {}
}
