//
//  SignUpViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/12/04.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {

    //MARK: - UI
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음화면으로 이동", for: .normal)
        button.setTitleColor(.loginNextButtonColor, for: .normal)
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.loginNextButtonColor.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = UIColor.loginNextButtonColor
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("뒤로가기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .black
        return button
    }()
        
    let emailInputView = EmailVerificationView()
    let passwordView = PasswordView()
    let additionalInfoView = AdditionalInfoView()
    
    // 보여줄 화면을 지정하기 위한 변수
    private var views: [UIView] = []
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        // 상단 사용자 입력 영역
        createView(newView: emailInputView)
        createView(newView: passwordView)
        createView(newView: additionalInfoView)
        
        showView(at: currentIndex)
        createButtons()
        changeButton(at: currentIndex)
        // 하단 버튼 영역
    }
    
    override func viewWillAppear(_ animated: Bool) {
      navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
    }
    
    
    //MARK: - Functions
    /// 회원가입 화면을 빠져나올 때 사용
    func popToLoginViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 뒤로가기/다음화면에 대한 버튼을 생성
    func createButtons() {
        view.addSubview(nextButton)
        view.addSubview(backButton)
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(view.frame.height * 0.8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // 로그인에 필요한 화면들을 생성
    func createView(newView: UIView) {
        view.addSubview(newView)
        
        newView.snp.makeConstraints { make in
            make.top.equalTo(view.frame.height * 0.2)
            make.height.equalTo(view.frame.height * 0.6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        newView.isHidden = true
        views.append(newView)
    }
    
    // 해당 index의 view만 활성화
    func showView(at index: Int) {
        for i in 0..<views.count {
            views[i].isHidden = (i != index)
        }
    }
    
    // 특정 index에 해당되는 경우 버튼의 텍스트를 변경
    func changeButton(at index: Int) {
        if index == 0 {
            backButton.setTitle("회원가입 취소", for: .normal)
        } else {
            backButton.setTitle("뒤로가기", for: .normal)
        }
    
        if index == views.count-1 {
            nextButton.setTitle("회원가입 완료", for: .normal)
        } else {
            nextButton.setTitle("다음화면으로 이동", for: .normal)
        }
    }

    @objc func nextAction() {
        currentIndex += 1
        if currentIndex >= views.count {
            print("회원가입 완료")
            popToLoginViewController()
        } else {
            
            showView(at: currentIndex)
            changeButton(at: currentIndex)
        }
    }

    @objc func backAction() {
        currentIndex -= 1
        if currentIndex < 0 {
            print("회원가입 취소")
            popToLoginViewController()
        } else {
            showView(at: currentIndex)
            changeButton(at: currentIndex)
        }
    }

}
