//
//  QuestionDetailViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 4/20/24.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {

    private let mainViewModel: MainViewModel
    
    init(vm: MainViewModel) {
        self.mainViewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var questionId: Int?
    private var dataSource = QuestionDetail(
        title: "",
        content: "",
        category: "",
        nickname: "",
        polled: "",
        pollCnt: 0,
        responseCnt: 0,
        createdAt: "2022-03-13",
        choices: [],
        solutions: [],
        replies: []
    )

//    private var replies: [Int:[Reply]] = [:]
    
    private let profileCollectionView =  UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(profileCollectionView)
        profileCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let id = questionId else { return }
        loadQuestion(questionId: id)
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    private func setupCollectionView() {
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.separatorStyle = .none
        
        profileCollectionView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        profileCollectionView.register(ChartHeaderCell.self, forCellReuseIdentifier: ChartHeaderCell.identifier)
        profileCollectionView.register(ChartBarCell.self, forCellReuseIdentifier: ChartBarCell.identifier)
        profileCollectionView.register(CommentsHeaderCell.self, forCellReuseIdentifier: CommentsHeaderCell.identifier)
        profileCollectionView.register(SolutionCell.self, forCellReuseIdentifier: SolutionCell.identifier)
        profileCollectionView.register(ReplyCell.self, forCellReuseIdentifier: ReplyCell.identifier)
        profileCollectionView.register(ReplyTextFieldCell.self, forCellReuseIdentifier: ReplyTextFieldCell.identifier)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let choices = dataSource.choices
        let solutions = dataSource.solutions
        let replies = dataSource.replies

        if section == 0 {
            return 3 + choices.count + solutions.count
        } else {
            return replies.filter { $0.solutionId == solutions[section-1].id }.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let choicesCount = dataSource.choices.count
        
        switch row {
        case 0:         // 본문
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PostCell.identifier,
                for: indexPath) as? PostCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            cell.selectionStyle = .none
            cell.configure(
                title: dataSource.title,
                content: dataSource.content,
                category: dataSource.category,
                nickname: dataSource.nickname,
                createdAt: dataSource.createdAt ?? "2022-04-04"
            )
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChartHeaderCell.identifier,
                for: indexPath) as? ChartHeaderCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            
            cell.configure(pollCnt: dataSource.pollCnt, resCnt: dataSource.responseCnt)
            return cell
            
        case 2..<choicesCount + 2:  // 차트
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChartBarCell.identifier,
                for: indexPath) as? ChartBarCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            cell.selectionStyle = .none
            let choice = dataSource.choices[row - 2]
            cell.configure(seq: choice.sequence, name: choice.detail, cnt: choice.count, total: dataSource.pollCnt)
            return cell
        
        case choicesCount + 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentsHeaderCell.identifier,
                for: indexPath) as? CommentsHeaderCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            cell.selectionStyle = .none
            return cell
            
        default:    // 댓글
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SolutionCell.identifier,
                for: indexPath) as? SolutionCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            
            cell.selectionStyle = .none
            
            let solition = dataSource.solutions[row - (choicesCount + 3)]
            cell.configure(
                id: solition.id,
                seq: solition.sequence,
                nickname: solition.nickname,
                createdAt: solition.createdAt ?? "2022-02-02",
                content: solition.opinion
            )
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section > 0,
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SolutionCellHeader.identifier) as? SolutionCellHeader else {
            return nil
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let cell = tableView.cellForRow(at: indexPath) as? SolutionCell,
           let data = cell.getSolutionCellData() {
            presentHalfModal(with: data)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? ReplyCell,
           let data = cell.getReplyCellData() {
            presentHalfModal(with: data)
        }
        
    }
    
    func presentHalfModal(with data: ReplyCellData) {
        let modalViewController = ModalViewController()
        modalViewController.data = data
        modalViewController.isModalInPresentation = true
        
        if let sheet = modalViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 15
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    // answer
    func loadQuestion(questionId: Int?) {
        guard let id = questionId, id > 0 else {

            self.navigationController?.popViewController(animated: true)
            return
        }
//        activityIndicator.startAnimating()
        
        mainViewModel.requestQuestionDetail(questionId: id) { result in
            switch result {
            case .success(let responseData):
                var replies: [Int:[Reply]] = [:]
                
                for reply in responseData.replies {
                    let id = reply.solutionId
                    if replies.keys.contains(id) {
                        replies[id]?.append(reply)
                    } else {
                        replies[id] = [reply]
                    }
                }
                
                DispatchQueue.main.async {
                    self.dataSource = responseData
//                    self.activityIndicator.stopAnimating()
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
    
}
