//
//  ResetPasswordInputViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/12/10.
//

import UIKit
import SnapKit

class ResetPasswordInputViewController: UIViewController {
    
    private let passwordTitle: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let passwordCheckTitle: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호 확인"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var passwordTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "새 비밀번호를 입력해주세요.")
        textField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var confirmPasswordTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "새 비밀번호를 한번 더 입력해주세요.")
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
    
    private lazy var nextButton: LoginNextButton = {
        let button = LoginNextButton()
        button.setTitle("비밀번호 변경하기", for: .normal)
        button.addTarget(self, action: #selector(goNextPage), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: LoginBackButton = {
        let button = LoginBackButton()
        button.setTitle("뒤로가기", for: .normal)
        button.addTarget(self, action: #selector(goBackPage), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    //MARK: - Functions
    private func setupUI() {
        view.backgroundColor = .white
        
        // 새 비밀번호
        view.addSubview(passwordTitle)
        view.addSubview(passwordTextField)
        view.addSubview(passwordErrorLabel)
        passwordTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTitle.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        passwordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // 새 비밀번호 확인
        view.addSubview(passwordCheckTitle)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(confirmPasswordErrorLabel)
        passwordCheckTitle.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckTitle.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        confirmPasswordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // 화면전환 버튼
        view.addSubview(nextButton)
        view.addSubview(backButton)
        nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
    }
    
    // 유효한 비밀번호인지 검사
    func isValidPassword(pw: String?) -> Bool {
        let password = pw ?? ""
        return (password.count >= 8) && (password.count <= 16)
    }
    
    @objc private func passwordTextFieldDidChange() {
        if isValidPassword(pw: passwordTextField.text) {
            passwordErrorLabel.textColor = .clear
            nextButton.isEnable = isSamePassword(pw1: passwordTextField.text,
                                                 pw2: confirmPasswordTextField.text) ? true : false
        } else {
            passwordErrorLabel.textColor = .red
            nextButton.isEnable = false
        }
    }
    
    // 동일한 비밀번호를 입력했는지 검사
    func isSamePassword(pw1: String?, pw2: String?) -> Bool {
        return (pw1 ?? "") == (pw2 ?? "")
    }
    
    @objc private func passwordConfirmTextFieldDidChange() {
        if isSamePassword(pw1: passwordTextField.text,
                           pw2: confirmPasswordTextField.text) {
            confirmPasswordErrorLabel.textColor = .clear
            nextButton.isEnable = isValidPassword(pw: passwordTextField.text) ? true : false
        } else {
            confirmPasswordErrorLabel.textColor = .red
            nextButton.isEnable = false
        }
    }
    
    @objc private func goNextPage() {
        //TODO: 비밀번호 변경 요청
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func goBackPage() {
        navigationController?.popViewController(animated: true)
    }
}
