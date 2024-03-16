//
//  MainViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 1/5/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    // view model
    private let mainViewModel = MainViewModel()
    
    private var questionList: [QuestionInfo] = []
    
    // tltle view
    private let mainTitleView = MainTitleView()
    
    // category collection view
    private let categories = ["전체", "내 질문", "가정/육아", "결혼/연애", "부동산/경제", "사회생활", "학업", "커리어"]
    private var selectedCategoryIndex = 0
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        
        return collectionView
    }()
    
    // main table view
//    private var questions: [String] = ["가나다라마", "가나다라마바사아자차가나다라마바사아자차가나다라마바사아자차가나다라마바사아자차", "가나다라마바사아자차가나다라마바사아자차가나다라마바사아자차가나다라마바사아자차"]
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 112
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuestionTableCell.self, forCellReuseIdentifier: QuestionTableCell.reuseIdentifier)
        
        return tableView
    }()
    
    // floating button
    private lazy var addQuestionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "question_request_button.pdf"), for: .normal)
        button.addTarget(self, action: #selector(addQuestionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupMainTitleView()
        setupMainTableView()
        setupCategoryUI()
        setupAddQuestionButton()
        
        loadData()
    }
    
    // MARK: - Helpers
    func selectCategory(at index: Int) {
        selectedCategoryIndex = index
        categoryCollectionView.reloadData()
        categoryCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    //MARK: - Constraints
    func setupMainTitleView() {
        view.addSubview(mainTitleView)
        
        mainTitleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
    }
    
    func setupCategoryUI() {
        let categoryView = UIView(frame: CGRect(x: 0, y: 0, width: mainTableView.frame.width, height: 48))
        categoryView.addSubview(categoryCollectionView)
        
        categoryCollectionView.snp.makeConstraints {
            $0.edges.equalTo(categoryView)
        }
        
        mainTableView.tableHeaderView = categoryView
        
        // Initially, select the first category
        selectCategory(at: selectedCategoryIndex)
    }
    
    func setupMainTableView() {
        view.addSubview(mainTableView)
        
        mainTableView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.equalTo(mainTitleView.snp.bottom)
            $0.bottom.equalTo(view)
        }
    }
    
    func setupAddQuestionButton() {
        view.addSubview(addQuestionButton)
        
        addQuestionButton.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(-42)
            $0.trailing.equalTo(view).offset(-16)
            $0.width.height.equalTo(52)
        }
    }
    
    // MARK: - Actions
    func loadData() {
        mainViewModel.requestQuestionList() { result in
            switch result {
            case .success(let responseData):
                self.questionList = responseData
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
                
            case .failure(let error):
                let errorMessage: String
                switch error {
                case .apiError(code: let code, message: let message):
                    errorMessage = "에러코드 \(code): \(message)"
                case .networkError(let networkError):
                    errorMessage = networkError.localizedDescription
                default:
                    errorMessage = "알 수 없는 에러가 발생했습니다."
                }
                
                let alert = UIAlertController(title: "인증 오류", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func addQuestionButtonTapped() {
        let addQuestionViewController = AddQuestionViewController()
        let navigationController = UINavigationController(rootViewController: addQuestionViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func reloadDataForCurrentButton() {
        //TODO: - 현재 버튼에 맞게 서버에 데이터 요청 및 갱신
        //        dataToShow = [
        //            "Item \(currentButtonTag)"
        //        ]
        
        
        
        switch selectedCategoryIndex {
        case 0:
            loadData()
        default:
            print(selectedCategoryIndex, categories[selectedCategoryIndex])
            // loadCategoryData \(selectedCategoryIndex)
        }
        print("reload main table view")
        
        // 토큰이 만료되었을 때 로그인화면으로
        if "SUCCESS" == "Failure" {
            KeychainHelper.delete(forAccount: "access_token")
            KeychainHelper.delete(forAccount: "refresh_token")

            let alert = UIAlertController(title: "로그인 만료", message: "로그인이 만료되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                let loginViewController = LoginViewController()
                self.navigationController?.setViewControllers([loginViewController], animated: true)
            })
            
            present(alert, animated: true, completion: nil)
            
        } else {
            mainTableView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        cell.configure(with: categories[indexPath.item], isSelected: indexPath.item == selectedCategoryIndex)
        return cell
    }
    
    // 카테고리별 길이에 맞게 Cell 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let category = categories[indexPath.item]
        let size = category.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])
        
        return CGSize(width: size.width + 24, height: 32)// CGSize(width: 100, height: collectionView.bounds.height)
    }
    
    // 카테고리 변경 및 데이터 갱신
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCategory(at: indexPath.item)
        reloadDataForCurrentButton()
    }
}

// MARK: - 질문 목록 / UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableCell.reuseIdentifier, for: indexPath) as! QuestionTableCell
        let question = questionList[indexPath.row]
        
        cell.separatorInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        cell.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cell.selectionStyle = .none
        
        cell.configure(
            title: question.title,
            content: question.content,
            author: question.nickname,
            answer: question.pollCnt,
            comment: question.responseCnt,
            date: Date(timeIntervalSinceNow: -72000)
        )
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedQuestion = questions[indexPath.item]
        let selectedQuestion = questionList[indexPath.item]
        
        //MARK: - 질문 내용에 대한 상세 페이지를 push로 이동
        let questionViewController = QuestionViewController()
        //TODO: - selectedQuestion.questionId
        questionViewController.questionId = 2
        print(selectedQuestion.title)
        
        self.navigationController?.pushViewController(questionViewController, animated: true)
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
}
