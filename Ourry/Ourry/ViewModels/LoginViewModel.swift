//
//  LoginViewModel.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/30.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func loginDidSucceed(jwtToken: String)
    func loginDidFail(error: AuthError)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?

    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }

    func login(email: String, password: String) {
        // 서버에 로그인 요청 보내기
        LoginManager.shared.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let jwtToken):
                // 로그인 성공
                self.delegate?.loginDidSucceed(jwtToken: jwtToken)
            case .failure(let error):
                // 로그인 실패
                self.delegate?.loginDidFail(error: error)
            }
        }
    }
    

}
