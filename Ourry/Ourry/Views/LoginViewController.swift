//
//  ViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/28.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    private lazy var loginViewModel: LoginViewModel = {
        let loginManager = LoginManager()
        return LoginViewModel(delegate: self, loginManager: loginManager)
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = .systemGray2
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)

        return button
    }()

    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "OURRY"
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .brandLogoColor
        label.numberOfLines = 0

        return label
    }()
    
    private lazy var emailErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 형식을 확인해주세요."
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .clear
        return label
    }()
    
    private lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호를 확인해주세요."
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .clear
        return label
    }()
    

    private lazy var emailTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "이메일을 입력하세요")
        return textField
    }()

    private lazy var passwordTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "비밀번호를 입력하세요")
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("로그인", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.backgroundColor = .buttonColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()

    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("회원가입", for: .normal)
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        button.backgroundColor = .buttonColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()

    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비밀번호 재설정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nonMemberLogin: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비회원으로 로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(nonMemberLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(dismissButton)
        view.addSubview(logoLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailErrorLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordErrorLabel)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(nonMemberLogin)

        setupConstraints()
        self.hideKeyboardWhenTappedAround()
    }

    //MARK: - Constraints
    func setupConstraints() {
        
        dismissButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(emailTextField.snp.top).offset(-64)
        }

        emailTextField.snp.makeConstraints { make in
            make.bottom.equalTo(passwordTextField.snp.top).offset(-40)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        emailErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        passwordTextField.snp.makeConstraints { make in
            make.bottom.equalTo(signupButton.snp.top).offset(-80)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        passwordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        signupButton.snp.makeConstraints { make in
            make.bottom.equalTo(forgotPasswordButton.snp.top).offset(-32)
            make.right.equalTo(passwordTextField.snp_centerXWithinMargins).offset(-8)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(50)
        }

        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(forgotPasswordButton.snp.top).offset(-32)
            make.left.equalTo(passwordTextField.snp_centerXWithinMargins).offset(8)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(50)
        }

        forgotPasswordButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().multipliedBy(0.80)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        nonMemberLogin.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    
    //MARK: - functions
    // 창닫기 버튼 로직
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    // 비회원 버튼 로직
    @objc func nonMemberLoginButtonTapped() {
//        dismiss(animated: true)
        print("로그아웃 하기")
        
        
    }

    // 로그인 버튼 로직
    @objc func loginButtonTapped() {
        
        // 유효성 검사
        guard let email = emailTextField.text, isValidEmail(email: email) else {
            // 유효하지 않은 이메일 또는 비밀번호 형식일 경우 처리
            emailErrorLabel.textColor = .red
            return
        }
        emailErrorLabel.textColor = .clear
        
        guard let password = passwordTextField.text, isValidPassword(pw: password) else {
            // 유효하지 않은 이메일 또는 비밀번호 형식일 경우 처리
            passwordErrorLabel.textColor = .red
            return
        }
        passwordErrorLabel.textColor = .clear

        // 뷰 모델을 통해 로그인 요청 보내기
        loginViewModel.login(email: email, password: password)
        
        //TODO: 로그인 로직
        // dismiss(animated: true)
    }

    // 회원가입 버튼 로직
    @objc func signupButtonTapped() {
        let signUpEmailViewController = SignUpEmailViewController()
        navigationController?.pushViewController(signUpEmailViewController, animated:true)
    }

    // 비밀번호 재설정 로직
    @objc func forgotPasswordButtonTapped() {
        let emailVerificationViewController = PasswordResetEmailVerificationViewController()
        navigationController?.pushViewController(emailVerificationViewController, animated:true)
    }
    
    // 이메일 유효성 검사
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // 비밀번호 유효성 검사
    func isValidPassword(pw: String) -> Bool {
        return pw.count > 4
    }
}

extension LoginViewController: LoginViewModelDelegate {
    
    func loginDidSucceed(jwt: String) {
        // 로그인 성공
        print("Login successful")
    }
    
    func loginDidFail(message: String) {
        let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - 디버깅
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct LoginViewPreviews: PreviewProvider {
    static var previews: some View {
        LoginViewController().toPreview()
    }
}
#endif
