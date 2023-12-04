//
//  TempViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/29.
//

import UIKit

//MARK: - 테스트를 위한 임시 화면
class TempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myFirstView = UIButton()
        myFirstView.setTitle("로그인", for: .normal)
        myFirstView.addTarget(self, action: #selector(requestLoginAlert), for: .touchUpInside)
        myFirstView.translatesAutoresizingMaskIntoConstraints = false
        myFirstView.backgroundColor = .systemPink
        self.view.addSubview(myFirstView)

        myFirstView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        myFirstView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true

        myFirstView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        myFirstView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        myFirstView.layer.cornerRadius = 30
        
    }
    
    @objc func navigateToNewViewController() {
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    // Alert를 통해 로그인 화면으로 이동
    @objc func requestLoginAlert() {
        let alert = UIAlertController(title: "로그인이 필요합니다.", message: "투표를 하기 위해선 로그인를 해주세요.", preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "로그인 하기", style: .default) { [weak self] _ in
            self?.navigateToNewViewController()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(loginAction)
        
        present(alert, animated: true, completion: nil)
    }
}
