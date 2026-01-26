package com.example.left

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.os.Bundle
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Monthly Widget - Shows current month name with dots for each day
 * Uses row-based layout for proper reflow on resize
 */
class MonthlyWidget : AppWidgetProvider() {
    
    companion object {
        // Monthly dot: 18dp size + 4dp margin each side = 26dp per dot
        private const val DOT_SIZE_WITH_MARGIN_DP = 26
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
        val widthDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 200)
        val usableWidthDp = widthDp - LAUNCHER_PADDING_DP
        val dotsPerRow = maxOf(MIN_DOTS_PER_ROW, usableWidthDp / DOT_SIZE_WITH_MARGIN_DP)
        
        // Get data from SharedPreferences (sent from Flutter)
        val widgetData = HomeWidgetPlugin.getData(context)
        val monthName = widgetData.getString("monthly_title", "JANUARY") ?: "JANUARY"
        val totalDays = widgetData.getInt("monthly_total_items", 31)
        val passedDays = widgetData.getInt("monthly_passed_items", 0)
        val daysLeft = totalDays - passedDays

        // Create widget view
        val views = RemoteViews(context.packageName, R.layout.monthly_widget)
        
        // Set month name (top left)
        views.setTextViewText(R.id.widget_title, monthName)
        
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
     * Creates a single dot view
     */
    private fun createDotView(context: Context, isDulled: Boolean): RemoteViews {
        val dotView = RemoteViews(context.packageName, R.layout.widget_dot)
        
        val drawable = if (isDulled) R.drawable.dot_passed else R.drawable.dot_active
        dotView.setImageViewResource(R.id.dot_image, drawable)
        
        val alpha = if (isDulled) 100 else 255
        dotView.setInt(R.id.dot_image, "setAlpha", alpha)
        
        return dotView
    }

    override fun onEnabled(context: Context) {}
    override fun onDisabled(context: Context) {}
}

