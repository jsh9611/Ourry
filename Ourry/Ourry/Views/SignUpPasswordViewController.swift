//
//  SignUpPasswordViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 12/14/23.
//

import UIKit
import SnapKit

class SignUpPasswordViewController: UIViewController {
    
    var email: String?
    
    private let passwordTitle: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let passwordCheckTitle: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호 확인"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var passwordTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "비밀번호를 입력해주세요.")
        textField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var passwordConfirmTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "비밀번호를 한번 더 입력해주세요.")
        textField.addTarget(self, action: #selector(passwordConfirmTextFieldDidChange), for: .editingChanged)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "숫자와 대소문자, 특수문자를 포함해 8자리에서 16자리를 입력해야 합니다."
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .clear
        return label
    }()
    
    private lazy var passwordConfirmErrorLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.text = "입력한 비밀번호와 일치하지 않습니다. 다시 확인해주세요."
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .clear
        return label
    }()
    
    private lazy var passwordVisibleButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonImage = UIImage(systemName: "eye")
        button.tag = 1
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(showPassword), for: .touchDown)
        button.addTarget(self, action: #selector(hidePassword), for: .touchUpInside)
        return button
    }()
    
    private lazy var passwordConfirmVisibleButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonImage = UIImage(systemName: "eye")
        button.tag = 2
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(showPassword), for: .touchDown)
        button.addTarget(self, action: #selector(hidePassword), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: LoginNextButton = {
        let button = LoginNextButton()
        button.setTitle("다음화면으로 이동", for: .normal)
        button.addTarget(self, action: #selector(goNextPage), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: LoginBackButton = {
        let button = LoginBackButton()
        button.setTitle("뒤로가기", for: .normal)
        button.addTarget(self, action: #selector(goBackPage), for: .touchUpInside)
        return button
    }()
    
    // 화면전환 버튼
    let pushAndPop: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = "회원가입"
        
        setupUI()
        
        // 키보드 이벤트 감지
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.hideKeyboardWhenTappedAround()
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

        // 비밀번호 visible 토글 버튼
        view.addSubview(passwordVisibleButton)
        passwordVisibleButton.snp.makeConstraints {
            $0.centerY.equalTo(passwordTextField)
            $0.trailing.equalTo(passwordTextField).inset(8)
            $0.width.height.equalTo(20)
        }
        
        // 새 비밀번호 확인
        view.addSubview(passwordCheckTitle)
        view.addSubview(passwordConfirmTextField)
        view.addSubview(passwordConfirmErrorLabel)
        passwordCheckTitle.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        passwordConfirmTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckTitle.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        passwordConfirmErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // 비밀번호 확인 visible 토글 버튼
        view.addSubview(passwordConfirmVisibleButton)
        passwordConfirmVisibleButton.snp.makeConstraints {
            $0.centerY.equalTo(passwordConfirmTextField)
            $0.trailing.equalTo(passwordConfirmTextField).inset(8)
            $0.width.height.equalTo(20)
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
        
        // stackView에 View 추가
        pushAndPop.addArrangedSubview(nextButton)
        pushAndPop.addArrangedSubview(backButton)
        view.addSubview(pushAndPop)
        
        pushAndPop.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(88)
        }
    }
    
    // 키보드가 올라올 때 레이아웃 조정
        @objc func keyboardWillShow(_ notification: Notification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                pushAndPop.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardHeight + 20)
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    
    // 키보드가 내려갈 때 레이아웃 조정
    @objc func keyboardWillHide(_ notification: Notification) {
        pushAndPop.snp.updateConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 키보드를 보이게 할 때 사용
    @objc private func showPassword(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            passwordTextField.isSecureTextEntry = false
        default:
            passwordConfirmTextField.isSecureTextEntry = false
        }
    }

    // 키보드를 안보이게 할 때 사용
    @objc private func hidePassword(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            passwordTextField.isSecureTextEntry = true
        default:
            passwordConfirmTextField.isSecureTextEntry = true
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
                                                 pw2: passwordConfirmTextField.text) ? true : false
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
                           pw2: passwordConfirmTextField.text) {
            passwordConfirmErrorLabel.textColor = .clear
            nextButton.isEnable = isValidPassword(pw: passwordTextField.text) ? true : false
        } else {
            passwordConfirmErrorLabel.textColor = .red
            nextButton.isEnable = false
        }
    }
    
    @objc private func goNextPage() {
        let signUpInformationViewController = SignUpInformationViewController()
        guard let email = email, let password = passwordTextField.text else { return }
        
        signUpInformationViewController.email = email
        signUpInformationViewController.password = password
        navigationController?.pushViewController(signUpInformationViewController, animated:true)
    }
    
    @objc private func goBackPage() {
        navigationController?.popViewController(animated: true)
    }
}
