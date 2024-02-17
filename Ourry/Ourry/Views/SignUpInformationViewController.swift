//
//  SignUpInformationViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 12/14/23.
//

import UIKit
import SnapKit

class SignUpInformationViewController: UIViewController {
    
    var email: String?
    var password: String?
    
//    private let createAccountViewModel = CreateAccountViewModel()
    
    private let createAccountViewModel: CreateAccountViewModel = {
        let createAccountManager = CreateAccountManager()
        return CreateAccountViewModel(createAccountManager: createAccountManager)
    }()
    
    private let nicknameTitle: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let phoneNumberTitle: UILabel = {
        let label = UILabel()
        label.text = "휴대폰 번호"
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var nicknameTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "홍길동")
        textField.addTarget(self, action: #selector(nicknameTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var phoneNumberTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "01012345678")
        textField.addTarget(self, action: #selector(phoneNumberTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var nickNameErrorLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "닉네임을 다시 확인해주세요"
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .clear
        return label
    }()
    
    private lazy var phoneNumberErrorLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.text = "전화번호를 다시 확인해주세요."
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .clear
        return label
    }()
    
    private lazy var nextButton: LoginNextButton = {
        let button = LoginNextButton()
        button.setTitle("회원가입 완료", for: .normal)
        button.addTarget(self, action: #selector(requestSignUp), for: .touchUpInside)
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
        
        // 닉네임 입력
        view.addSubview(nicknameTitle)
        view.addSubview(nicknameTextField)
        view.addSubview(nickNameErrorLabel)
        nicknameTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTitle.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        nickNameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // 새 비밀번호 확인
        view.addSubview(phoneNumberTitle)
        view.addSubview(phoneNumberTextField)
        view.addSubview(phoneNumberErrorLabel)
        phoneNumberTitle.snp.makeConstraints{ make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTitle.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        phoneNumberErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(6)
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
    
    // 유효한 비밀번호인지 검사
    func isValidPassword(pw: String?) -> Bool {
        let password = pw ?? ""
        return (password.count >= 8) && (password.count <= 16)
    }
    
    // 올바른 닉네임인지 체크
    func isCorrectNickname(nickname: String) -> Bool {
        nickname.count >= 2
    }
    
    
    // 올바른 전화번호인지 체크
    func isCorrectPhoneNumber(phone: String) -> Bool {
        !phone.isEmpty
    }
    
    // 닉네임 텍스트필드가 변경될 때
    @objc private func nicknameTextFieldDidChange() {
        guard let nickname = nicknameTextField.text, let phone = phoneNumberTextField.text else {
            nextButton.isEnable = false
            return
        }
        
        nextButton.isEnable = isCorrectNickname(nickname: nickname) && isCorrectPhoneNumber(phone: phone)
    }
    
    // 휴대폰 번호 텍스트필드가 변경될 때
    @objc private func phoneNumberTextFieldDidChange() {
        guard let nickname = nicknameTextField.text, let phone = phoneNumberTextField.text else {
            nextButton.isEnable = false
            return
        }
        
        nextButton.isEnable = isCorrectNickname(nickname: nickname) && isCorrectPhoneNumber(phone: phone)
    }
    
    @objc private func requestSignUp() {
        // 회원가입 완료하기 버튼
        guard let email = email,
              let password = password,
              let nickname = nicknameTextField.text,
              let phone = phoneNumberTextField.text else { return }
        
        createAccountViewModel.registration(email: email, password: password, nickname: nickname, phone: phone) { result in
            switch result {
            case .success:
                let alert = UIAlertController(title: "회원가입 완료", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
                
            case .failure(let error):
                let errorMessage: String
                switch error {
                case .apiError(code: let code, message: let message):
                    print("API 에러 - 코드: \(code), 메시지: \(message)")
                    errorMessage = "API 에러 - 코드: \(code), 메시지: \(message)"
                    
                case .networkError(let underlyingError):
                    print("네트워크 에러: \(underlyingError)")
                    errorMessage = "네트워크 에러: \(underlyingError)"
                case .parsingError:
                    print("데이터 파싱 에러")
                    errorMessage = "데이터 파싱 에러"
                case .invalidResponse:
                    print("유효하지 않은 응답")
                    errorMessage = "유효하지 않은 응답"
                }
                
                let alert = UIAlertController(title: "회원가입 오류", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            }
        }
    }
    
    @objc private func goBackPage() {
        navigationController?.popViewController(animated: true)
    }
}
