//
//  CommentsHeaderCell.swift
//  Ourry
//
//  Created by SeongHoon Jang on 4/20/24.
//

import UIKit
import SnapKit

class CommentsHeaderCell: UITableViewCell {
    //MARK: - Properties
    
    static let identifier = "CommentsHeaderCell"

    // 응답 결과 확인 타이틀
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "응답 별 의견"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
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
        
        chartTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.contentView.snp.leading).offset(16)
            $0.top.equalTo(self.contentView).inset(16)
            $0.bottom.equalTo(self.contentView)
        }
    }
}
