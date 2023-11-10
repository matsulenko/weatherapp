//
//  Forecast24HoursHeaderView.swift
//  WeatherApp
//
//  Created by Matsulenko on 03.10.2023.
//

import CoreLocation
import DGCharts
import UIKit
import WeatherKit

final class Forecast24HoursHeaderView: UIView {
    
    private var dayNumber: Int?
    
    private var timeZoneIdentifier: String?
    
    private lazy var spacing: CGFloat = {
        var spacing = (bounds.width - 272) / 7
        
        if spacing < 0 {
            spacing = 0
        }
        
        return spacing
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Medium", size: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(named: "Text")
        
        return label
    }()
    
    var data24hours: [WeatherForecastHourly]
    
    private lazy var backgroundWhiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Background")
        
        return view
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Background")
        
        return view
    }()
    
    private lazy var backgroundBlueView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "VeryLightBlue")
        
        return view
    }()
        
    private lazy var temperatureChart: UIView = {
        
        let chart = LineChartView()
        
        var lineChartEntries: [ChartDataEntry] = []
        
        for i: Int in 0...7 {
            var indexY = i
            
            if dayNumber == nil {
                indexY = 3 * i + Date().getHours(Date(), timeZoneIdentifier: timeZoneIdentifier)
            } else {
                var offset: Int = 0
                let zeroHour = data24hours[dayNumber! * 24].hours
                
                if zeroHour == 23 {
                    offset = 1
                } else if zeroHour == 1 {
                    offset = -1
                }
                
                indexY = dayNumber! * 24 + i * 3 + offset
            }
            
            if indexY < data24hours.count {
                let chartDataEntry = ChartDataEntry(x: Double(i), y: data24hours[indexY].temperature)
                lineChartEntries.append(chartDataEntry)
            } else {
                break
            }
        }
        
        let dataSet = LineChartDataSet(entries: lineChartEntries)
        dataSet.drawFilledEnabled = true
        dataSet.setColor(UIColor(named: "MainChart")!)
        dataSet.lineWidth = 0.3
        dataSet.colors = [UIColor(named: "MainChart")!]
        dataSet.circleColors = [UIColor.white]
        dataSet.circleHoleRadius = 0
        dataSet.circleRadius = 2
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
        let valuesNumberFormatter = ChartValueFormatter(numberFormatter: numberFormatter)
        dataSet.valueFormatter = valuesNumberFormatter
        dataSet.valueFont = UIFont(name: "Rubik-Light_Regular", size: 14)!
        dataSet.valueColors = [UIColor(named: "Text") ?? UIColor.systemGray3]
        
        let colors = [
            UIColor(named: "VeryLightBlue")!.cgColor,
            UIColor(named: "MainChart")!.cgColor,
            UIColor(named: "VeryLightBlue")!.cgColor
        ]
        
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: [0, 0.79, 1]) {
            dataSet.fill = LinearGradientFill(gradient: gradient, angle: 270)
            dataSet.fillFormatter = LineChartFillFormatter()
        }
        let data = LineChartData(dataSet: dataSet)
        
        chart.data = data
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.drawGridBackgroundEnabled = false
        chart.xAxis.drawLabelsEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.legend.enabled = false
        chart.xAxis.enabled = true
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.drawBordersEnabled = false
        chart.xAxis.labelPosition = .bottom
        
        chart.extraTopOffset = 23
        
        chart.xAxis.axisLineWidth = 0.3
        chart.xAxis.axisLineColor = UIColor(named: "MainChart")!
        chart.xAxis.axisLineDashLengths = [5.0]
        
        chart.leftAxis.axisLineWidth = 0.3
        chart.leftAxis.axisLineColor = UIColor(named: "MainChart")!
        chart.leftAxis.axisLineDashLengths = [5.0]
                
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = UIColor(named: "VeryLightBlue")
        chart.isUserInteractionEnabled = false
        
        return chart
    }()
    
    private lazy var timeLine: UIView = {
        let chart = LineChartView()
        
        var lineChartEntries: [ChartDataEntry] = []
        
        for i: Int in 0...7 {
            let chartDataEntry = ChartDataEntry(x: Double(i), y: 1.0)
            lineChartEntries.append(chartDataEntry)
        }
        
        let dataSet = LineChartDataSet(entries: lineChartEntries)
        dataSet.setColor(UIColor(named: "MainChart")!)
        dataSet.lineWidth = 0.5
        dataSet.colors = [UIColor(named: "MainChart")!]
        dataSet.drawCirclesEnabled = false
        
        let data = LineChartData(dataSet: dataSet)
        
        chart.data = data
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.drawGridBackgroundEnabled = false
        chart.xAxis.drawLabelsEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.legend.enabled = false
        chart.xAxis.enabled = true
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.drawBordersEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.axisLineColor = .clear
        chart.leftAxis.axisLineColor = .clear
        
        for i: Int in 0...7 {
            let line = ChartLimitLine(limit: Double(i))
            line.lineWidth = 4
            line.lineColor = UIColor(named: "MainChart")!
            chart.xAxis.addLimitLine(line)
        }
        
        chart.translatesAutoresizingMaskIntoConstraints = false
//        chart.backgroundColor = UIColor(named: "VeryLightBlue")
        chart.isUserInteractionEnabled = false
        
        return chart
    }()
    
    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: viewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "VeryLightBlue")
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(
            ForecastCollectionViewCell.self,
            forCellWithReuseIdentifier: ForecastCollectionViewCell.id
        )
        
        return collectionView
    }()
    
    init(frame: CGRect, data24hours: [WeatherForecastHourly], timeZoneIdentifier: String?, dayNumber: Int?) {
        self.data24hours = data24hours
        self.timeZoneIdentifier = timeZoneIdentifier
        self.dayNumber = dayNumber
        super.init(frame: frame)
        
        addSubviews()
        setupView()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        spacing = (bounds.width - 272) / 7
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(backgroundWhiteView)
        addSubview(backgroundBlueView)
        addSubview(temperatureChart)
        addSubview(collectionView)
        addSubview(timeLine)
        addSubview(topLabel)
        addSubview(separator)
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "Background")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            topLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            topLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            temperatureChart.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 15),
            temperatureChart.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            temperatureChart.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            temperatureChart.heightAnchor.constraint(equalToConstant: 58),
            
            backgroundWhiteView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundWhiteView.bottomAnchor.constraint(equalTo: backgroundBlueView.topAnchor),
            backgroundWhiteView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundWhiteView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            backgroundBlueView.topAnchor.constraint(equalTo: temperatureChart.topAnchor),
            backgroundBlueView.bottomAnchor.constraint(equalTo: temperatureChart.bottomAnchor),
            backgroundBlueView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundBlueView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: temperatureChart.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 74),
            
            timeLine.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -24),
            timeLine.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeLine.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            timeLine.heightAnchor.constraint(equalToConstant: 8),
            
            separator.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 20),
            
            self.bottomAnchor.constraint(equalTo: separator.bottomAnchor)
        ])
    }
}

extension Forecast24HoursHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data24hours.count == 0 {
            0
        } else {
            8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.id, for: indexPath) as! ForecastCollectionViewCell
        
        var cellIndex = indexPath.row
        
        if dayNumber == nil {
            cellIndex = 3 * indexPath.row + Date().getHours(Date(), timeZoneIdentifier: timeZoneIdentifier)
        } else {
            var offset: Int = 0
            let zeroHour = data24hours[dayNumber! * 24].hours
            
            if zeroHour == 23 {
                offset = 1
            } else if zeroHour == 1 {
                offset = -1
            }
                
            cellIndex = dayNumber! * 24 + indexPath.row*3 + offset
        }
        
        if cellIndex < data24hours.count {
            let hourData = data24hours[cellIndex]
            cell.setup(with: hourData)
        } else {
            return UICollectionViewCell()
        }
            
        return cell
    }
}

extension Forecast24HoursHeaderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 30, height: 74)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}
