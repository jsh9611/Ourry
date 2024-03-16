//
//  BarChartView.swift
//  Ourry
//
//  Created by SeongHoon Jang on 3/10/24.
//

import Foundation
import UIKit
import SnapKit

class BarChartView: UIView {
    
    private var bars: [UIView] = []
    private var percentages: [Double] = []
    private let barHeight: CGFloat = 54
    private let barSpacing: CGFloat = 8
    private let bgColor = UIColor.lightGray.cgColor
    private let barColor = UIColor.black
    
    func setup(with data: [(String, Double)]) {
        // Remove previous bars
        bars.forEach { $0.removeFromSuperview() }
        bars.removeAll()
        percentages.removeAll()
        
        let totalPercentage = data.reduce(0) { $0 + $1.1 }
        var previousBar: UIView?
        
        for (index, (food, percentage)) in data.enumerated() {
            let bar = UIView()
            bar.backgroundColor = .surveyOptionBackroundColor
            bar.layer.cornerRadius = 8
            
            addSubview(bar)
            bar.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(barHeight)
                
                if let previous = previousBar {
                    make.top.equalTo(previous.snp.bottom).offset(barSpacing)
                } else {
                    make.top.equalToSuperview().offset(0) // Adjust the initial top constraint as needed
                }
            }
            
            let fillWidth = UIScreen.main.bounds.width - 32 // Width of the view minus insets
            let filledWidth = fillWidth * CGFloat(percentage / totalPercentage)
            
            let fillView = UIView()
            fillView.backgroundColor = .voteResultColor
            fillView.layer.cornerRadius = 8
            fillView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            fillView.layer.masksToBounds = true
            
            bar.addSubview(fillView)
            fillView.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
                make.width.equalTo(filledWidth)
            }
            
            let label = UILabel()
            label.text = "\(Int(percentage * 100))%"
            label.textColor = .black
            bar.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(-8)
            }
            
            let foodLabel = UILabel()
            foodLabel.text = food
            foodLabel.textColor = .black
            foodLabel.font = .systemFont(ofSize: 16, weight: .semibold)
            bar.addSubview(foodLabel)
            foodLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(8)
            }
            
            bars.append(bar)
            percentages.append(percentage)
            previousBar = bar
        }
    }
}


//class BarChartView: UIView {
//    
//    // MARK: - Properties
//    
//    private var bars: [BarChart] = [] // 막대 배열
//    private var total: Int // 총 개수
//    
//    // MARK: - Initializers
//    
//    init(bars: [BarChart], total: Int) {
//        self.bars = bars
//        self.total = total
//        
//        super.init(frame: .zero)
//        
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Setup Views
//    
//    private func setupViews() {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.spacing = 10
//        
//        addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        for bar in bars {
//            let barView = BarView(bar: bar, total: total)
//            stackView.addArrangedSubview(barView)
//        }
//    }
//}
//
//struct BarChart {
////    let value: Int // 개수
////    let color: UIColor // 색상
//    let count: Int // 막대 개수
//    let total: Int // 총 개수
//}
//
//class BarView: UIView {
//    
//    // MARK: - Properties
//    
//    private let bar: BarChart
//    private let total: Int
//    
//    // MARK: - Initializers
//    
//    init(bar: BarChart, total: Int) {
//        self.bar = bar
//        self.total = total
//        
//        super.init(frame: .zero)
//        
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Setup Views
//    
//    private func setupViews() {
//        let barHeight: CGFloat = 40 // 막대 높이
//        let barWidth = frame.width
//        
//        let barLayer = CAShapeLayer()
//        barLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bar.count*10, height: 54)).cgPath
//        barLayer.fillColor = UIColor.gray.cgColor
//        
//        layer.addSublayer(barLayer)
//        
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.text = "\(bar.count)"
//        
//        addSubview(label)
//        label.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(barHeight + 5)
//        }
//    }
//}
