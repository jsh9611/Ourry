//
//  QuestionTableCell.swift
//  Ourry
//
//  Created by SeongHoon Jang on 1/11/24.
//

import UIKit
import SnapKit

//MARK: - QuestionTableCell
class QuestionTableCell: UITableViewCell {
    static let reuseIdentifier = "QuestionTableCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    let answerView: IconTextView = {
        let answerView = IconTextView()
        answerView.configure(icon: "note.text", text: "123")
        return answerView
    }()
    
    let commentView: IconTextView = {
        let commentView = IconTextView()
        commentView.configure(icon: "text.bubble.fill", text: "456")
        return commentView
    }()
    
    let createdView: IconTextView = {
        let createdView = IconTextView()
        createdView.configure(icon: "clock", text: "5시간 전")
        return createdView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        // 그림자 효과
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = false
//        contentView.layer.borderColor = UIColor.red.cgColor
//        contentView.layer.borderWidth = 2
        
        contentView.layer.shadowRadius = 4.0
        contentView.layer.shadowOpacity = 1.0
        contentView.layer.shadowColor = UIColor.blueShadowColor.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(answerView)
        contentView.addSubview(commentView)
        contentView.addSubview(createdView)
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.right.lessThanOrEqualTo(contentView).offset(-10)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        let infoStackView = UIStackView(arrangedSubviews: [answerView, commentView, createdView])
        infoStackView.axis = .horizontal
        infoStackView.alignment = .center
        infoStackView.spacing = 8
        
        contentView.addSubview(infoStackView)
        
        infoStackView.snp.makeConstraints{
            
            $0.centerY.equalTo(authorLabel)
            $0.right.equalTo(contentView).offset(-10)
        }
        
    }
    
    func configure(title: String, author: String, answer: Int, comment: Int, date: Date) {
        titleLabel.text = title
        authorLabel.text = author
        
        answerView.textLabel.text = "\(answer)"
        commentView.textLabel.text = "\(comment)"
        createdView.textLabel.text = "\(date.timeAgoString())"
    }
}
