//
//  AdditionalInfoView.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/12/06.
//

import UIKit
import SnapKit

class AdditionalInfoView: UIView {

    //MARK: - UI
    private let nicknameTitle: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let phoneNumberTitle: UILabel = {
        let label = UILabel()
        label.text = "휴대폰번호"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var nicknameTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "닉네임을 입력해주세요.")
        textField.addTarget(self, action: #selector(nicknameTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var phoneNumberTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "휴대폰 번호를 입력해주세요.")
        textField.addTarget(self, action: #selector(phoneNumberTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var nicknameErrorLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "닉네임에는 특수문자가 포함될 수 없습니다. 다시 확인해주세요."
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .clear
        return label
    }()
    
    private lazy var phoneNumberErrorLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.text = "올바른 휴대폰 번호를 입력해주세요."
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .clear
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    //MARK: - Functions
    private func setupUI() {
        // 닉네임 입력
        addSubview(nicknameTitle)
        addSubview(nicknameTextField)
        addSubview(nicknameErrorLabel)
        nicknameTitle.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.trailing.equalTo(self)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTitle.snp.bottom).offset(6)
            make.leading.trailing.equalTo(self)
        }
        
        nicknameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(6)
            make.leading.trailing.equalTo(self)
        }
        
        // 휴대폰번호 입력
        addSubview(phoneNumberTitle)
        addSubview(phoneNumberTextField)
        addSubview(phoneNumberErrorLabel)
        phoneNumberTitle.snp.makeConstraints{ make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(48)
            make.leading.trailing.equalTo(self)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTitle.snp.bottom).offset(6)
            make.leading.trailing.equalTo(self)
        }
        
        phoneNumberErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(6)
            make.leading.trailing.equalTo(self)
        }
    }
    
    // 닉네임 유효성 검사
    func isValidNickname(nickname: String) -> Bool {
        return !nickname.contains("!")
    }
    
    // 휴대폰번호 유효성 검사
    func isValidPhoneNumber(number: String) -> Bool {
        return number.count >= 9
    }
    
    @objc private func nicknameTextFieldDidChange() {
        if !isValidNickname(nickname: nicknameTextField.text ?? "") {
            nicknameErrorLabel.textColor = .red
        } else {
            nicknameErrorLabel.textColor = .clear
        }
        
    }

    @objc private func phoneNumberTextFieldDidChange() {
        if !isValidPhoneNumber(number: phoneNumberTextField.text ?? "") {
            phoneNumberErrorLabel.textColor = .red
        } else {
            phoneNumberErrorLabel.textColor = .clear
        }
    }
    
}
