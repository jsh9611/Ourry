//
//  PasswordView.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/12/06.
//

import UIKit
import SnapKit

class PasswordView: UIView {
    
    //MARK: - UI
    private let passwordTitle: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let passwordCheckTitle: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var passwordTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "비밀번호를 입력해주세요.")
        textField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var confirmPasswordTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "인증번호를 입력하세요.")
        textField.addTarget(self, action: #selector(passwordConfirmTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "비밀번호는 대소문자를 포함해서 12자리에서 16자리를 입력해야 합니다."
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .clear
        return label
    }()
    
    private lazy var confirmPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.text = "입력한 비밀번호와 일치하지 않습니다. 다시 확인해주세요."
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
        addSubview(passwordTitle)
        addSubview(passwordTextField)
        addSubview(confirmPasswordTextField)
        
        addSubview(passwordCheckTitle)
        addSubview(passwordErrorLabel)
        addSubview(confirmPasswordErrorLabel)
        
        passwordTitle.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.trailing.equalTo(self)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTitle.snp.bottom).offset(6)
            make.leading.trailing.equalTo(self)
        }
        
        passwordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(6)
            make.leading.trailing.equalTo(self)
        }
        
        passwordCheckTitle.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(48)
            make.leading.trailing.equalTo(self)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckTitle.snp.bottom).offset(6)
            make.leading.trailing.equalTo(self)
        }
        
        confirmPasswordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(6)
            make.leading.trailing.equalTo(self)
        }
    }
    
    // 유효한 비밀번호인지 검사
    func isValidPassword(pw: String?) -> Bool {
        let password = pw ?? ""
        return (password.count >= 8) && (password.count <= 16)
    }
    
    @objc private func passwordTextFieldDidChange() {
        if !isValidPassword(pw: passwordTextField.text) {
            passwordErrorLabel.textColor = .red
        } else {
            passwordErrorLabel.textColor = .clear
        }
        
    }
    
    // 동일한 비밀번호를 입력했는지 검사
    func isSamePassword(pw1: String?, pw2: String?) -> Bool {
        return (pw1 ?? "") == (pw2 ?? "")
    }
    
    @objc private func passwordConfirmTextFieldDidChange() {
        if !isSamePassword(pw1: passwordTextField.text,
                           pw2: confirmPasswordTextField.text) {
            confirmPasswordErrorLabel.textColor = .red
        } else {
            confirmPasswordErrorLabel.textColor = .clear
        }
    }
    
}
