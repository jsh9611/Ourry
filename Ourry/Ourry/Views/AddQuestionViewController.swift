//
//  AddQuestionViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 1/13/24.
//

import UIKit
import SnapKit

class AddQuestionViewController: UIViewController {
    //MARK: - Properties
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // Bar Button Item
    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        button.tintColor = .black
        button.isEnabled = true
        return button
    }()
    
    private lazy var finishButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped))
        button.tintColor = .black
        button.isEnabled = false
        return button
    }()
    // 카테고리 선택
    private lazy var categoryButton2: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "카테고리를 선택해주세요."
        configuration.image = UIImage(systemName: "chevron.right")

        let button = UIButton(configuration: configuration, primaryAction: UIAction(handler: { _ in
            print("Button tapped!")
            let selectCategoryViewController = SelectCategoryViewController()
            selectCategoryViewController.delegate = self
            self.navigationController?.pushViewController(selectCategoryViewController, animated:true)
            
            
        }))
        
        button.contentHorizontalAlignment = .left   // 왼쪽 정렬
        button.semanticContentAttribute = .forceRightToLeft // 버튼과 타이틀의 순서 변경
        button.imageView?.snp.makeConstraints {
            $0.centerY.equalTo(button.snp.centerY)
            $0.trailing.equalTo(button.snp.leading).offset(24)
        }
        
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.tintColor = .black
        
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.blueShadowColor.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 4.0
        
        return button
    }()
    
//    var categoryButtonTitle: String = "카테고리를 선택하세요123"
//    
//    private lazy var categoryButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .black
//        button.backgroundColor = .white
//        button.setTitle(categoryButtonTitle, for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 16)
//        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
//        
//        button.layer.masksToBounds = false
//        button.layer.shadowColor = UIColor.blueShadowColor.cgColor
//        button.layer.shadowOffset = CGSize(width: 1, height: 1)
//        button.layer.shadowOpacity = 1.0
//        button.layer.shadowRadius = 4.0
//        
//        return button
//    }()
    
    // 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var titleTextField: BlueShadowTextField = {
        let textField = BlueShadowTextField(placeholder: "제목을 입력해주세요")
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()

    // 설명
    let placeholder = "설명을 작성해주세요."
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
    
    let letterNumLabel: UILabel = {
        let label = UILabel()
        label.text = "0/150"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray3
        label.textAlignment = .right
        return label
    }()
    
    // 선택지
    var chunks: [Chunk] = []  // 각 덩어리에 대한 정보를 저장하는 배열
    private lazy var optionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setupUI()
        setupTextView()
        addNewChunk()
        addNewChunk()
    }
    
    //MARK - UI
    func configUI() {
        self.title = "질문 등록하기"
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = finishButton
        
        scrollView.backgroundColor = .backgroundColor
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }

        scrollView.addSubview(contentView)
//        contentView.backgroundColor = .green
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
//            $0.leading.trailing.top.equalTo(scrollView)
//            $0.leading.equalToSuperview() (scrollView.snp.leading)
//            $0.trailing.equalToSuperview()(scrollView.snp.trailing)
//            $0.top.equalToSuperview()
            $0.width.height.equalTo(view)
//            $0.height.equalTo(view)
        }
    }
    
    func setupUI() {
        /// 카테고리 선택
        contentView.addSubview(categoryButton2)
        categoryButton2.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.height.equalTo(36)
            $0.leading.trailing.equalTo(view).inset(16)
        }
        
        /// 제목 입력
        let titleView = UILabel()
        titleView.text = "제목"
        titleView.textColor = .darkGray
        titleView.font = UIFont.boldSystemFont(ofSize: 17)

        contentView.addSubview(titleView)

        titleView.snp.makeConstraints {
            $0.top.equalTo(categoryButton2.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view).inset(16)
        }
        
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(view).inset(16)
        }
        
        /// 설명 입력
        let descriptionView = UILabel()
        descriptionView.text = "설명"
        descriptionView.textColor = .darkGray
        descriptionView.font = UIFont.boldSystemFont(ofSize: 17)
        
        contentView.addSubview(descriptionView)
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view).inset(16)
        }
        
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(letterNumLabel)
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(view).inset(16)
            make.height.greaterThanOrEqualTo(150)
        }
        
        letterNumLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(28)
        }
        
        // 선택지 입력
        let selectView = UILabel()
        selectView.text = "선택지"
        selectView.textColor = .darkGray
        selectView.font = UIFont.boldSystemFont(ofSize: 17)

        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.top.equalTo(letterNumLabel.snp.bottom).offset(16)
            $0.leading.equalTo(16)
        }
        
        //MARK: - 선택지
        contentView.addSubview(optionStackView)
        optionStackView.snp.makeConstraints {
            $0.top.equalTo(selectView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(contentView).inset(16)
        }
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = "선택지 추가하기"

        let tempButton = UIButton(configuration: configuration, primaryAction: UIAction(handler: { _ in
            self.addNewChunk()
            self.view.endEditing(true)
        }))
        tempButton.tintColor = .darkGray
        tempButton.backgroundColor = .white

        tempButton.layer.shadowColor = UIColor.blueShadowColor.cgColor
        tempButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        tempButton.layer.shadowOpacity = 1.0
        tempButton.layer.shadowRadius = 4.0
        
        
        contentView.addSubview(tempButton)
        tempButton.snp.makeConstraints {
            $0.top.equalTo(optionStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(36)
        }
        
    }
    
    func setupTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.text = placeholder /// 초반 placeholder 생성
        descriptionTextView.textColor = .systemGray /// 초반 placeholder 색상 설정
    }
    
    //MARK: - Action
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func finishButtonTapped() {
        print("finish")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func categoryButtonTapped() {
        let signUpEmailViewController = SignUpEmailViewController()
        navigationController?.pushViewController(signUpEmailViewController, animated:true)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) /// 화면을 누르면 키보드 내려가게 하는 것
    }
}


//MARK: - UITextViewDelegate
extension AddQuestionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        /// 텍스트뷰 입력 시 테두리 생기게 하기
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.borderColor = UIColor.blueShadowColor.cgColor
        
        /// 플레이스홀더
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            descriptionTextView.textColor = .systemGray
            descriptionTextView.text = placeholder
        } else if textView.text == placeholder {
            descriptionTextView.textColor = .black
            descriptionTextView.text = nil
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // 글자 수 제한
        if descriptionTextView.text.count > 300 {
            descriptionTextView.deleteBackward()
        }
        
        // 텍스트필드 크기 조절
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if estimatedSize.height > 200 && constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            } else {
                constraint.constant = 150
            }
        }

        // 아래 글자 수 표시되게 하기
        letterNumLabel.text = "\(descriptionTextView.text.count)/150"
        
        // 글자 수 부분 색상 변경
        let attributedString = NSMutableAttributedString(string: "\(descriptionTextView.text.count)/150")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: ("\(descriptionTextView.text.count)/150" as NSString).range(of:"\(descriptionTextView.text.count)"))
        letterNumLabel.attributedText = attributedString
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // 텍스트뷰 입력 완료시 테두리 없애기
        descriptionTextView.layer.borderWidth = 0
        
        /// 플레이스홀더
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == placeholder {
            descriptionTextView.textColor = .systemGray
            descriptionTextView.text = placeholder
            letterNumLabel.textColor = .systemGray /// 텍스트 개수가 0일 경우에는 글자 수 표시 색상이 모두 gray 색이게 설정
            letterNumLabel.text = "0/300"
        }
    }
}

//MARK: - 선택지 추가 및 삭제
extension AddQuestionViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text
        textField.text = text
    }
    
    // "X" 버튼을 눌렀을 때 호출되는 함수
    @objc func removeChunk(sender: UIButton) {
        if let chunkIndex = chunks.firstIndex(where: { $0.deleteButton == sender }) {
            chunks.remove(at: chunkIndex)
            sender.superview?.removeFromSuperview()
        }
    }

    // 덩어리(텍스트필드+삭제버튼)를 추가하는 함수
    func addNewChunk() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            var chunk = Chunk()

            let chunkView = UIView()

            let textField = BlueShadowTextField(placeholder: "선택지를 입력해주세요.")
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            textField.delegate = self
            
            chunk.textField = textField  // 덩어리에 텍스트 필드 저장

            let deleteButton = UIButton(type: .system)
            deleteButton.setTitle("X", for: .normal)
            deleteButton.tintColor = .darkGray
            deleteButton.addTarget(self, action: #selector(removeChunk), for: .touchUpInside)
            chunk.deleteButton = deleteButton  // 덩어리에 삭제 버튼 저장

            chunkView.addSubview(textField)
            chunkView.addSubview(deleteButton)

            // Auto Layout 설정
            textField.snp.makeConstraints {
                $0.leading.trailing.top.bottom.equalToSuperview()
                $0.height.equalTo(36)
            }

            deleteButton.snp.makeConstraints {
                $0.centerY.equalTo(textField)
                $0.trailing.equalTo(textField.snp.trailing).offset(-10)
                $0.width.equalTo(30)
            }

            // Stack View에 추가
            self.optionStackView.addArrangedSubview(chunkView)
            self.chunks.append(chunk)
        }
        
        
    }

    struct Chunk {
        var textField: UITextField?
        var deleteButton: UIButton?
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
//        self.optionStackView =
    }
}

//MARK: - SelectCategoryVCDelegate
extension AddQuestionViewController: SelectCategoryVCDelegate {
    func didSelectCategory(_ category: String) {
        categoryButton2.setTitle(category, for: .normal)
        navigationController?.popViewController(animated: true)
    }
}
