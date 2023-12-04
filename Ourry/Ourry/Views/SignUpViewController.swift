//
//  SignUpViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/12/04.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        let myFirstView = UIButton()
        myFirstView.setTitle("확인", for: .normal)
//        myFirstView.addTarget(self, action: nil, for: .touchUpInside)
        myFirstView.translatesAutoresizingMaskIntoConstraints = false
        myFirstView.backgroundColor = .green
        self.view.addSubview(myFirstView)

        myFirstView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        myFirstView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true

        myFirstView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        myFirstView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        myFirstView.layer.cornerRadius = 30
    }
    
}
