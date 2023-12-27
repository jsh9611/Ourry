//
//  Login.swift
//  Ourry
//
//  Created by SeongHoon Jang on 12/16/23.
//

import Foundation

struct LoginResponse: Codable {
    let jwt: String?
    let code: String?
    let message: String?
}

struct LoginError: Error {
    let code: String
    let message: String
}

enum AuthError: Error {
    case networkError(Error)
    case apiError(code: String, message: String)
    case parsingError
}
