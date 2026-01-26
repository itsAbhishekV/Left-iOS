//
//  LeftWidgetsBundle.swift
//  LeftWidgets
//
//  Created by Abhishek on 21/01/26.
//

import WidgetKit
import SwiftUI

@main
struct LeftWidgetsBundle: WidgetBundle {
    var body: some Widget {
        MonthlyWidget()
        YearlyWidget()
    }
}
