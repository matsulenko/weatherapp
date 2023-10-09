//
//  LineChartFillFormatter.swift
//  WeatherApp
//
//  Created by Matsulenko on 03.10.2023.
//

import DGCharts
import Foundation

final class LineChartFillFormatter: FillFormatter {
    func getFillLinePosition(dataSet: DGCharts.LineChartDataSetProtocol, dataProvider: DGCharts.LineChartDataProvider) -> CGFloat {
        -100
    }
}
