//
//  ReplyCell.swift
//  Ourry
//
//  Created by SeongHoon Jang on 4/20/24.
//

import UIKit
import SnapKit

class ReplyCell: UITableViewCell {
    //MARK: - Properties
    
    static let identifier = "ReplyCell"
    private var solutionId: Int?
    
    // 답글 배경
    let commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        
        return view
    }()

    // 답글 구분용 화살표
    lazy var commentSperatorImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.turn.down.right")
        image.tintColor = .black
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    // 프로필 배경
    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // 프로필 라벨
    private let optionTagLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        
        return label
    }()
    
    // 닉네임
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        
        return label
    }()
    
    // 글 작성일
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022-03-21"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    // 구분선
    private let commentDivider = CommentDivider()
    
    // 글 내용
    private let descriptionUILabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    // 더보기 버튼
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    

    //MARK: - 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
//        self.backgroundColor = .gray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Constraints
    private func configureLayout() {
//        self.contentView.addSubview(barView)
//        optionImageView optionTagLable nicknameLabel creationDateLabel commentDivider descriptionUILabel actionButton
        
        self.contentView.addSubview(commentView)
        self.contentView.addSubview(commentSperatorImageView)
        
        self.commentView.addSubview(optionImageView)
        self.commentView.addSubview(optionTagLable)
        self.commentView.addSubview(nicknameLabel)
        self.commentView.addSubview(creationDateLabel)
        self.commentView.addSubview(actionButton)
        self.commentView.addSubview(commentDivider)
        self.commentView.addSubview(descriptionUILabel)
        
        commentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(44)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().priority(750)
            $0.height.equalTo(500).priority(100)
        }
        
        commentSperatorImageView.snp.makeConstraints {
            $0.centerY.equalTo(commentView)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(28)
        }
        
        optionImageView.snp.makeConstraints {
            $0.top.leading.equalTo(self.commentView).inset(12)
            $0.width.height.equalTo(40)
        }
        
        optionTagLable.snp.makeConstraints {
            $0.center.equalTo(optionImageView)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(optionImageView.snp.top)
            $0.leading.equalTo(optionImageView.snp.trailing).offset(8)
        }
        
        creationDateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom)
            $0.leading.equalTo(optionImageView.snp.trailing).offset(8)
        }
        
        actionButton.snp.makeConstraints {
            $0.trailing.equalTo(self.commentView).inset(12)
            $0.centerY.equalTo(optionImageView)
        }
        
        commentDivider.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.commentView).inset(12)
            $0.top.equalTo(optionImageView.snp.bottom).offset(8)
        }

        descriptionUILabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.commentView).inset(16)
            $0.top.equalTo(commentDivider.snp.bottom).offset(8)
            $0.bottom.equalTo(self.commentView).inset(12)
        }
    }
    
    func configure(id: Int, seq: Int, nickname: String, createdAt: String, content: String) {
        let tag = String(Character(UnicodeScalar(seq + 64) ?? "A"))
        
        solutionId = id
        optionTagLable.text = tag
        nicknameLabel.text = nickname
        creationDateLabel.text = createdAt
        descriptionUILabel.text = content
    }
    
    func getReplyCellData() -> ReplyCellData? {
        guard let id = solutionId,
              let tag = optionTagLable.text,
              let nickname = nicknameLabel.text,
              let createdAt = creationDateLabel.text,
              let content = descriptionUILabel.text else {
            return nil
        }
        
        return ReplyCellData(
            solutionId: id,
            tag: tag,
            nickname: nickname,
            createdAt: createdAt,
            content: content
        )
    }
}
