//
//  ChartBarCell.swift
//  Ourry
//
//  Created by SeongHoon Jang on 4/20/24.
//

import UIKit
import SnapKit

class ChartBarCell: UITableViewCell {
    
    static let identifier = "ChartBarCell"
    
    let barView: UIView = {
        let view = UIView()
        view.backgroundColor = .surveyOptionBackroundColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let fillView: UIView = {
        let view = UIView()
        view.backgroundColor = .voteResultColor
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let optionTagLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureLayout() {
        self.contentView.addSubview(barView)
        self.barView.addSubview(fillView)
        self.barView.addSubview(optionImageView)
        self.barView.addSubview(optionTagLable)
        self.barView.addSubview(detailLabel)
        self.barView.addSubview(percentageLabel)
        
        barView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().priority(750)
            $0.height.equalTo(56)
        }
        
        fillView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(self.barView)
            $0.width.equalTo(300)
        }
        
        optionImageView.snp.makeConstraints {
            $0.leading.equalTo(barView).offset(16)
            $0.centerY.equalTo(barView)
            $0.width.height.equalTo(35)
        }

        optionTagLable.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self.optionImageView)
        }
        
        detailLabel.snp.makeConstraints {
            $0.centerY.equalTo(barView)
            $0.leading.equalTo(optionImageView.snp.trailing).offset(8)
        }
        
        percentageLabel.snp.makeConstraints {
            $0.centerY.equalTo(barView)
            $0.trailing.equalTo(barView).offset(-8)
        }
    }
    
    func configure(seq: Int, name: String, cnt: Int, total: Int) {
        let totalWidth = contentView.frame.width - 32
        let percentage = CGFloat(cnt) / CGFloat(total)
        let filledWidth = totalWidth * percentage
        let tag = String(Character(UnicodeScalar(seq + 64) ?? "A"))
        
        detailLabel.text = name
        optionTagLable.text = tag
        percentageLabel.text = "\(Int(percentage * 100))% (\(cnt))"
        
        fillView.snp.updateConstraints {
            $0.width.equalTo(filledWidth)
        }
    }
}
