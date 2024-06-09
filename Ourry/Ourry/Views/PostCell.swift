//
//  PostCell.swift
//  Ourry
//
//  Created by SeongHoon Jang on 4/20/24.
//

import UIKit
import SnapKit

class PostCell: UITableViewCell {
    //MARK: - Properties
    
    static let identifier = "PostCell"

    // 글 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    // 카테고리명
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = .systemFont(ofSize: 11, weight: .light)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    // 프로필 이미지
    private let profileImageView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.gray.cgColor
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .black
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        return containerView
    }()
    
    // 닉네임
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
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

    //MARK: - 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Constraints
    func setupViews() {
        self.contentView.addSubview(categoryLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(nicknameLabel)
        self.contentView.addSubview(creationDateLabel)
        self.contentView.addSubview(commentDivider)
        self.contentView.addSubview(descriptionUILabel)
        
        // 카테고리명
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(16)
            $0.leading.equalTo(self.contentView.snp.leading).offset(16)
        }
        
        // 제목
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.categoryLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.contentView.snp.leading).offset(16)
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
        }
        
        // 프로필 이미지
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.contentView.snp.leading).offset(16)
            $0.width.height.equalTo(40)
        }
        
        // 닉네임
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView)
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(12)
        }
        
        // 작성일
        creationDateLabel.snp.makeConstraints {
            $0.top.equalTo(self.nicknameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(self.nicknameLabel)
        }
        
        // 구분선
        commentDivider.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(8)
            $0.leading.equalTo(self.contentView.snp.leading).offset(16)
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
        }
        
        // 설명
        descriptionUILabel.snp.makeConstraints {
            $0.top.equalTo(self.commentDivider.snp.bottom).offset(8)
            $0.leading.equalTo(self.contentView.snp.leading).offset(16)
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
            $0.bottom.equalTo(self.contentView.snp.bottom)//.offset(-16)
        }
    }
    
    func configure(title: String, content: String, category: String, nickname: String, createdAt: String) {
        categoryLabel.text = category
        titleLabel.text = title
        nicknameLabel.text = nickname
        creationDateLabel.text = createdAt
        descriptionUILabel.text = content
    }
}
