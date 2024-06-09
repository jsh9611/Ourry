//
//  ModalViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 4/21/24.
//

import UIKit
import SnapKit

class ModalViewController: UIViewController {
    
    private lazy var replyTextField: BlueShadowTextField = {
        let textField = BlueShadowTextField(placeholder: "답글을 입력해주세요")
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = .systemGray2
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        return button
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 18
        textView.backgroundColor = .white
        textView.tintColor = .blueShadowColor
        textView.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        textView.isScrollEnabled = false
        
        textView.autocapitalizationType = .none
        textView.layer.masksToBounds = false
        textView.layer.shadowColor = UIColor.blueShadowColor.cgColor
        textView.layer.shadowOffset = CGSize(width: 0, height: 1)
        textView.layer.shadowOpacity = 1.0
        textView.layer.shadowRadius = 4.0
        return textView
    }()

//    let button = UIButton(type: .custom)
//    button.setTitle("로그인", for: .normal)
//    button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
//    button.backgroundColor = .buttonColor
//    button.layer.masksToBounds = true
    
    private lazy var subbmitButton: UIButton = {
        
        let button = UIButton(type: .custom)
        button.setTitle("답글 작성하기", for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blueShadowColor.cgColor
        button.setTitleColor(.black, for: .normal)
        
        
//        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
//        button.tintColor = .systemGray2
//        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        return button
    }()
//    backgroundColor = .white
//    titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//    setTitleColor(.loginNextButtonColor, for: .normal)
//    layer.cornerRadius = 8
//    layer.borderWidth = 2
//    layer.borderColor = UIColor.loginNextButtonColor.cgColor
    
    
    var data: ReplyCellData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUI()
        self.hideKeyboardWhenTappedAround()

        
        if let data = data {
            replyTextField.text = "@\(data.nickname) "
            descriptionTextView.text = "@\(data.nickname) "
        }
    }
    
    func setUI() {
        self.view.backgroundColor = UIColor.backgroundColor.withAlphaComponent(0.9)

        self.view.addSubview(dismissButton)
        self.view.addSubview(descriptionTextView)
        self.view.addSubview(subbmitButton)
        
        dismissButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(16)
            $0.width.height.equalTo(30)
        }
        
//        replyTextField.snp.makeConstraints {
//            $0.top.equalTo(dismissButton.snp.bottom).offset(16)
//            $0.left.right.equalToSuperview().inset(16)
//            $0.height.equalToSuperview().multipliedBy(0.5)
//        }
        
        subbmitButton.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(dismissButton.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalToSuperview().multipliedBy(0.48)
        }
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func submitButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
