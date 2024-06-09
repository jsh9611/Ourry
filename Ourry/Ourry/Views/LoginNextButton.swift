//
//  CustomNextButton.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/12/08.
//

import UIKit

//MARK: - 로그인 Next 버튼
class LoginNextButton: UIButton {
    
    var isEnable: Bool = false {
        didSet {
            updateButtonState()
        }
    }

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 버튼 UI 설정
    private func setupUI() {
        backgroundColor = .white
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setTitleColor(.loginNextButtonColor, for: .normal)
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.loginNextButtonColor.cgColor
        
        updateButtonState()
    }
    
    // 버튼의 활성화 여부에 따라 색상/활성화여부 설정
    private func updateButtonState() {
        let color: UIColor = isEnable ? .loginNextButtonColor : .disabledButtonColor
        setTitleColor(color, for: .normal)
        layer.borderColor = color.cgColor
        isEnabled = isEnable
    }

}
