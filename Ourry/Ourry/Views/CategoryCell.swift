//
//  CategoryCell.swift
//  Ourry
//
//  Created by SeongHoon Jang on 1/11/24.
//

import UIKit

//MARK: - Category Cell
class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        backgroundColor = isSelected ? .white : .systemGray6
        titleLabel.textColor = isSelected ? .loginNextButtonColor : .darkGray
        layer.borderColor = isSelected ? UIColor.loginNextButtonColor.cgColor : UIColor.clear.cgColor
    }
}
