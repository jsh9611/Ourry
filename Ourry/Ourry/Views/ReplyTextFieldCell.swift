//
//  ReplyTextFieldCell.swift
//  Ourry
//
//  Created by SeongHoon Jang on 4/20/24.
//

import UIKit
import SnapKit

class ReplyTextFieldCell: UITableViewCell {
    //MARK: - Properties
    
    static let identifier = "ReplyTextFieldCell"
    
    // stackview
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [optionImageView, replyTextField])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fill
        return stackView
    }()
    
    // 프로필 배경
    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // 프로필 라벨
    private let optionTagLable: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        
        return label
    }()

    private lazy var replyTextField: BlueShadowTextField = {
        let textField = BlueShadowTextField(placeholder: "답글을 입력해주세요")
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
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
        self.contentView.addSubview(horizontalStackView)
        self.contentView.addSubview(optionTagLable)
        
        horizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)

        }
        
        optionImageView.snp.makeConstraints {
            $0.width.height.equalTo(28)
        }
        
        optionTagLable.snp.makeConstraints {
            $0.center.equalTo(optionImageView)
        }
    }
}
