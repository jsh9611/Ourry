//
//  MainTitleView.swift
//  Ourry
//
//  Created by SeongHoon Jang on 1/6/24.
//

import UIKit
import SnapKit

class MainTitleView: UIView {
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "OURRY"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .brandLogoColor
        label.numberOfLines = 0

        return label
    }()
    
    // 버튼들을 담을 스택 뷰
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    //MARK: - View 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(textLabel)
        
        addButton(imageName: "magnifyingglass", action: #selector(magnifyingglassButtonTapped))
        addButton(imageName: "gearshape", action: #selector(gearshapeButtonTapped))
        addButton(imageName: "bell", action: #selector(bellButtonTapped))

        addSubview(buttonsStackView)
        
        setupConstraints()
    }
    
    //MARK: - Constraints
    private func setupConstraints() {
        textLabel.snp.makeConstraints {
            $0.leading.equalTo(self).offset(16)
            $0.bottom.equalTo(self)
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.trailing.equalTo(self).offset(-16)
            $0.centerY.equalTo(textLabel.snp.centerY)
            $0.height.equalTo(25)
        }
    }
    
    //MARK: - Actions
    func addButton(imageName: String, action: Selector) {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: action, for: .touchUpInside)
        button.tintColor = .black
        
        buttonsStackView.addArrangedSubview(button)
    }
    
    @objc private func magnifyingglassButtonTapped() {
        
    }

    @objc private func gearshapeButtonTapped() {

    }

    @objc private func bellButtonTapped() {

    }

}

