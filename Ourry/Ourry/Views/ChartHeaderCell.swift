//
//  ChartHeaderCell.swift
//  Ourry
//
//  Created by SeongHoon Jang on 4/20/24.
//

import UIKit
import SnapKit

class ChartHeaderCell: UITableViewCell {
    //MARK: - Properties
    
    static let identifier = "ChartHeaderCell"

    // 응답 결과 확인 타이틀
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "응답 결과 확인"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    // 응답자 수 아이콘
    private let solutionsCountView: IconTextView = {
        let answerView = IconTextView()
        
        return answerView
    }()
    
    // 의견 수 아이콘
    private let opinionCountView: IconTextView = {
        let commentView = IconTextView()
        return commentView
    }()

    //MARK: - 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Constraints
    func setupViews() {
        self.contentView.addSubview(chartTitleLabel)
        self.contentView.addSubview(solutionsCountView)
        self.contentView.addSubview(opinionCountView)
        
        // 카테고리명
        chartTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.contentView.snp.leading).offset(16)
            $0.top.equalTo(self.contentView).inset(16)
            $0.bottom.equalTo(self.contentView)
        }
        
        // 총 응답자 수
        solutionsCountView.snp.makeConstraints {
            $0.trailing.equalTo(self.opinionCountView.snp.leading).offset(-8)
            $0.centerY.equalTo(self.chartTitleLabel)
        }
        
        // 총 의견 수
        opinionCountView.snp.makeConstraints {
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
            $0.centerY.equalTo(self.chartTitleLabel)
        }
    }
    
    func configure(pollCnt: Int, resCnt: Int) {
        solutionsCountView.configure(icon: "note.text", text: "응답자수 \(pollCnt)")
        opinionCountView.configure(icon: "text.bubble.fill", text: "의견 \(resCnt)")
    }
}
