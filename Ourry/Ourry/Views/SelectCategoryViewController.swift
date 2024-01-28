//
//  SelectCategoryViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 1/21/24.
//

import UIKit
import SnapKit

protocol SelectCategoryVCDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}

class SelectCategoryViewController: UIViewController {
    
    weak var delegate: SelectCategoryVCDelegate?
    
    private let catogorys = ["가정/육아", "결혼/연애", "부동산/경제", "사회생활", "학업", "커리어"]
    
    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(categoryStackView)
        categoryStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(self.additionalSafeAreaInsets)
        }

        for category in catogorys {
            let button = UIButton()
            
            button.tintColor = .blue
            button.backgroundColor = .white
            button.setTitle("\(category)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16)

            button.layer.shadowColor = UIColor.blueShadowColor.cgColor
            button.layer.shadowOffset = CGSize(width: 1, height: 1)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 4.0
            
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            
            categoryStackView.addArrangedSubview(button)
        }
        
    }
    
    @objc func categoryButtonTapped(_ sender: UIButton) {
        if let category = sender.titleLabel?.text {
            delegate?.didSelectCategory(category)
        }
    }

 
    
}
