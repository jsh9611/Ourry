//
//  LoginViewModel.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/30.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func loginDidSucceed(jwt: String)
    func loginDidFail(message: String)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    private let loginManager: LoginManager
    
    init(delegate: LoginViewModelDelegate, loginManager: LoginManager) {
        self.delegate = delegate
        self.loginManager = loginManager
    }

    func login(email: String, password: String) {
         
        loginManager.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return } // 메모리 누구 방지

            switch result {
            case .success(let jwtToken):
                // 로그인 성공
                self.delegate?.loginDidSucceed(jwt: jwtToken)
            case .failure(let error):
                // 로그인 실패
                let errorMessage: String
                switch error {
                case .networkError(let networkError):
                    errorMessage = networkError.localizedDescription
                case .apiError(code: let code, message: let message):
                    errorMessage = "에러코드 \(code): \(message)"
                case .parsingError:
                    errorMessage = "잘못된 서버 응답입니다."
                default:
                    errorMessage = "알 수 없는 오류가 발생했습니다."
                }
                
                self.delegate?.loginDidFail(message: errorMessage)
            }
        }
    }
    

}
