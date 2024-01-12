//
//  IconTextView.swift
//  Ourry
//
//  Created by SeongHoon Jang on 1/11/24.
//

import UIKit
import SnapKit

class IconTextView: UIView {
    let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.tintColor = .lightGray
        iconImageView.contentMode = .scaleAspectFit
        return iconImageView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    // 아이콘과 텍스트를 설정하는 함수
    func configure(icon: String, text: String) {
        iconImageView.image = UIImage(systemName: icon)
        textLabel.text = text
    }

    //MARK: - 초기화 및 레이아웃 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // 수평으로 아이콘과 텍스트를 나열하기 위한 스택뷰
        let stackView = UIStackView(arrangedSubviews: [iconImageView, textLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5

        addSubview(stackView)
        
        iconImageView.snp.makeConstraints {
            $0.height.equalTo(14)
        }

        stackView.snp.makeConstraints{
            $0.edges.equalTo(self)
        }
    }
}
