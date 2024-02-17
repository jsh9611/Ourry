//
//  ResetEmailVerifyViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/12/09.
//

import UIKit
import SnapKit

class PasswordResetEmailVerificationViewController: UIViewController {
    private let emailVerificationViewModel = EmailVerificationViewModel()
    
    private let emailTitle: UILabel = {
        let title = UILabel()
        title.text = "이메일 인증"
        title.textColor = .black
        title.font = .systemFont(ofSize: 24, weight: .bold)
        return title
    }()
    
    private lazy var emailTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "이메일을 입력해주세요.")
        textField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var authInputTextField: PlaneTextField = {
        let textField = PlaneTextField(placeholder: "인증 번호를 입력해주세요.")
        textField.addTarget(self, action: #selector(authTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var verificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증번호 요청", for: .normal)
        button.isEnabled = false
        button.backgroundColor = .gray
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(verificationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var authConfirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인증번호 확인", for: .normal)
        button.isEnabled = false
        button.backgroundColor = .gray
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(authConfirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var countdownLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .red
        label.textAlignment = .right
        return label
    }()
    
    private lazy var nextButton: LoginNextButton = {
        let button = LoginNextButton()
        button.setTitle("다음화면으로 이동", for: .normal)
        button.addTarget(self, action: #selector(goNextPage), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: LoginBackButton = {
        let button = LoginBackButton()
        button.setTitle("비밀번호 재설정 취소", for: .normal)
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

    private var countdownTimer: Timer?
    private var countdownSeconds = 10
    private var isVerificationButtonEnable = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = "비밀번호 재설정"
        
        self.hideKeyboardWhenTappedAround()
        setupUI()
        
        nextButton.isEnable = false
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        // 이메일 인증 및 인증 재요청
        view.addSubview(emailTitle)
        view.addSubview(emailTextField)
        view.addSubview(verificationButton)
        view.addSubview(countdownLabel)
        emailTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTitle.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(40)
        }

        verificationButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(40)
        }

        countdownLabel.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-28)
        }
        
        // 인증 확인
        view.addSubview(authInputTextField)
        view.addSubview(authConfirmButton)
        authInputTextField.snp.makeConstraints { make in
            make.top.equalTo(verificationButton.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(40)
        }
    
        authConfirmButton.snp.makeConstraints { make in
            make.top.equalTo(authInputTextField.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
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

        // 이메일 인증요청 후에 등장
        hideAuthField()
        
        // 키보드 이벤트 감지
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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

    // 텍스트필드 위에 Done 버튼을 추가
    func makeDoneButton() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIButton.init(type: .custom)
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action:#selector(doneButtonAction), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width:50, height: 30)
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem.init(customView: button)
        
        toolBar.items = [space, done]
        emailTextField.inputAccessoryView = toolBar
        authInputTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction (){
        self.view.endEditing(true)
    }
    
    private func hideAuthField() {
        authInputTextField.isHidden = true
        authConfirmButton.isHidden = true
    }
    
    private func showAuthField() {
        authInputTextField.isHidden = false
        authConfirmButton.isHidden = false
    }

    @objc private func emailTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty, isVerificationButtonEnable {
            verificationButton.isEnabled = true
            verificationButton.backgroundColor = .buttonColor
        } else {
            verificationButton.isEnabled = false
            verificationButton.backgroundColor = .gray
        }
    }
    
    @objc private func authTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            authConfirmButton.isEnabled = true
            authConfirmButton.backgroundColor = .buttonColor
        } else {
            authConfirmButton.isEnabled = false
            authConfirmButton.backgroundColor = .gray
        }
    }

    // 인증번호 요청 버튼 로직
    @objc private func verificationButtonTapped() {
        guard let email = emailTextField.text else { return }
        
        emailVerificationViewModel.requestVerificationCode(email: email) { result in
            switch result {
            case .success(let message):
                print(message)
                self.startCountdown()
                self.showAuthField()
                self.verificationButton.setTitle("인증번호 전송됨", for: .normal)
                self.verificationButton.isEnabled = false
                self.verificationButton.backgroundColor = .gray
            case .failure(let error):
                let errorMessage: String
                switch error {

                case .apiError(let code, let message):
                    // API 에러 처리
                    errorMessage = "\(code): \(message)"

                default:
                    errorMessage = "알 수 없는 에러 발생"
                }
                
                let alert = UIAlertController(title: "변경 오류", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func authConfirmButtonTapped() {
        guard let email = emailTextField.text, let code = authInputTextField.text else { return }
        
        let successAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.emailTextField.isUserInteractionEnabled = false
            self.emailTextField.backgroundColor = .systemGray6
            self.emailTextField.textColor = .systemGray
            
            self.countdownTimer?.invalidate()
            self.countdownLabel.isHidden = true
            self.nextButton.isEnable = true
            self.verificationButton.setTitle("인증 완료", for: .normal)
            self.verificationButton.isEnabled = false
            self.verificationButton.backgroundColor = .gray
            
            self.authInputTextField.isUserInteractionEnabled = false
            self.authInputTextField.backgroundColor = .systemGray6
            self.authInputTextField.textColor = .systemGray
            
            self.authConfirmButton.isEnabled = false
            self.nextButton.isEnable = true
        }
        
        emailVerificationViewModel.verifyCode(email: email, code: code) { result in
            switch result {
            case .success(let message):
                print(message)
                let alert = UIAlertController(title: "인증 완료", message: "인증이 완료되었습니다.", preferredStyle: .alert)
                alert.addAction(successAction)
                
                self.doneButtonAction()
                self.present(alert, animated: true, completion: nil)
                
            // 실패한 경우
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
                let alert = UIAlertController(title: "인증 오류", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    private func startCountdown() {
        countdownSeconds = 5
        isVerificationButtonEnable.toggle()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc private func updateCountdown() {
        guard countdownSeconds >= 0 else {
            countdownTimer?.invalidate()
            verificationButton.isEnabled = true
            verificationButton.backgroundColor = .buttonColor
            verificationButton.setTitle("인증번호 재발송", for: .normal)
            isVerificationButtonEnable.toggle()
            return
        }

        let minutes = countdownSeconds / 60
        let seconds = countdownSeconds % 60
        countdownLabel.text = String(format: "%02d:%02d", minutes, seconds)

        countdownSeconds -= 1
    }
    
    @objc private func goNextPage() {
        guard let email = emailTextField.text else { return }
        
        let passwordInputViewController = PasswordResetNewPasswordViewController()
        passwordInputViewController.email = email
        navigationController?.pushViewController(passwordInputViewController, animated:true)
    }
    
    @objc private func goBackPage() {
        navigationController?.popViewController(animated: true)
    }
}
