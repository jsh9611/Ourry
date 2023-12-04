//
//  AuthService.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/30.
//

import Foundation

class AuthService {
    func login(user: User, completion: @escaping (Bool) -> Void) {
        // 실제 로그인 로직을 수행하고 결과를 completion handler를 통해 전달
        // 이 부분은 실제 서버와 통신이 발생하는 부분입니다.
        // 여기에서는 간단히 성공만을 시뮬레이션합니다.
        completion(true)
    }
}
