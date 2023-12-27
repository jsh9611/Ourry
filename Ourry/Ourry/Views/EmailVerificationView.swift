//
//  EmailVerificationView.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/12/05.
//

import UIKit
import SnapKit

class EmailVerificationView: UIView, UITextFieldDelegate {
    
    //MARK: - UI
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var emailTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "이메일을 입력하세요")
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var emailVerificationCodeTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "인증번호를 입력하세요")
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()

    private lazy var verificationRequestButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증번호 발송", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(request), for: .touchUpInside)
        button.backgroundColor = .buttonColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.cornerRadius = 8
        return button
    }()

    private lazy var verificationCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증번호 확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(check), for: .touchUpInside)
        button.backgroundColor = .buttonColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.cornerRadius = 8
        return button
    }()
    
    var isVerified: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        emailTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    //MARK: - Functions
    private func setupUI() {
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(verificationRequestButton)
        addSubview(emailVerificationCodeTextField)
        addSubview(verificationCheckButton)
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(6)
            make.leading.equalTo(self)
            make.trailing.equalTo(verificationRequestButton.snp.leading).offset(-4)
            make.height.equalTo(36)
        }

        verificationRequestButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField)
            make.trailing.equalTo(self)
            make.width.equalTo(80)
            make.height.equalTo(36)
        }

        emailVerificationCodeTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(6)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(36)
        }

        verificationCheckButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(6)
            make.trailing.equalTo(verificationRequestButton.snp.trailing)
            make.width.equalTo(80)
            make.height.equalTo(36)
        }
    }
    
    @objc func textFieldDidChange() {
        self.isVerified = (self.emailTextField.text?.count ?? 0 > 0) && (self.emailVerificationCodeTextField.text?.count ?? 0 > 0)
        print(isVerified)
    }
    
    func getEmailValue() -> String {
        return emailTextField.text ?? ""
    }
    
    //TODO: 이메일 인증코드 요청
    @objc private func request() {
        print(emailTextField.text ?? "Empty")
    }
    
    //TODO: 이메일 인증코드 확인
    @objc private func check() {
        print(emailVerificationCodeTextField.text ?? "Empty")
    }
}
