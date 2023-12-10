//
//  ResetEmailVerifyViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/12/09.
//

import UIKit
import SnapKit

class ResetEmailVerifyViewController: UIViewController {
    
    private let emailTitle: UILabel = {
        let title = UILabel()
        title.text = "이메일 인증"
        title.textColor = .black
        title.font = .preferredFont(forTextStyle: .headline)
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
        button.setTitle("취소하기", for: .normal)
        button.addTarget(self, action: #selector(goBackPage), for: .touchUpInside)
        return button
    }()

    private var countdownTimer: Timer?
    private var countdownSeconds = 10
    private var isVerificationButtonEnable = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
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
        
        // 화면 전환 버튼
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
        
        // 이메일 인증요청 후에 등장
        hideAuthField()
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

    @objc private func verificationButtonTapped() {
        //TODO: 인증 코드 전송 로직 구현
        startCountdown()
        showAuthField()
        verificationButton.setTitle("인증번호 재발송", for: .normal)
        verificationButton.isEnabled = false
        verificationButton.backgroundColor = .gray
    }
    
    @objc private func authConfirmButtonTapped() {
        let alert = UIAlertController(title: "인증이 완료되었습니다.", message: nil, preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "확인", style: .default) { _ in
            //TODO: 인증 코드 확인 로직 구현
            print("인증 코드 확인 로직 구현")
            self.emailTextField.isUserInteractionEnabled = false
            self.emailTextField.backgroundColor = .systemGray6
            self.emailTextField.textColor = .systemGray
            
            self.countdownTimer?.invalidate()
            self.countdownLabel.isHidden = true
            self.nextButton.isEnable = true
            self.verificationButton.setTitle("인증 완료", for: .normal)
            self.verificationButton.isEnabled = false
            self.verificationButton.backgroundColor = .gray
            
        }
        
        alert.addAction(loginAction)
        present(alert, animated: true, completion: nil)
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
            isVerificationButtonEnable.toggle()
            return
        }

        let minutes = countdownSeconds / 60
        let seconds = countdownSeconds % 60
        countdownLabel.text = String(format: "%02d:%02d", minutes, seconds)

        countdownSeconds -= 1
    }
    
    @objc private func goNextPage() {
        let passwordInputViewController = ResetPasswordInputViewController()
        navigationController?.pushViewController(passwordInputViewController, animated:true)
    }
    
    @objc private func goBackPage() {
        navigationController?.popViewController(animated: true)
    }
}

