//
//  LoginBackButton.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/12/09.
//

import UIKit

//MARK: - 로그인 Back 버튼
class LoginBackButton: UIButton {

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        layer.cornerRadius = 8
        layer.borderWidth = 2
        setTitleColor(.black, for: .normal)
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = .white
    }
}
