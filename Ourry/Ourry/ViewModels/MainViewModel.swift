//
//  MainViewModel.swift
//  Ourry
//
//  Created by SeongHoon Jang on 3/16/24.
//

import Foundation

import Foundation
import Alamofire

class MainViewModel {
    
    private let session: Session
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    //MARK: - 메인화면 전체 질문 목록 불러오기
    func requestQuestionList(completion: @escaping (Result<[QuestionInfo], AuthError>) -> Void) {
        let url = Endpoint.getQuestionList.url
        let encoding: JSONEncoding = JSONEncoding.default
        let headers: HTTPHeaders =  ["Content-Type": "application/json"]
        
        session
            .request(url, method: .get, parameters: nil, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [QuestionInfo].self) { response in
                switch response.result {
                case .success(let responseData):
                    completion(.success(responseData))
                case .failure(let error):
                    if let data = response.data,
                       let authResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        completion(.failure(.apiError(code: authResponse.code, message: authResponse.message)))
                    } else {
                        completion(.failure(.networkError(error)))
                    }
                }
            }
    }
    
    //MARK: - 질문 상세내용 불러오기
    func requestQuestionDetail(questionId: Int, completion: @escaping (Result<QuestionDetail, AuthError>) -> Void) {
        let url = Endpoint.getQuestionDetail(questionId: questionId).url
        let encoding: JSONEncoding = JSONEncoding.default
        let headers: HTTPHeaders =  ["Content-Type": "application/json"]
        
        session
            .request(url, method: .get, parameters: nil, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: QuestionDetail.self) { response in
                switch response.result {
                case .success(let responseData):
                    completion(.success(responseData))
                case .failure(let error):
                    if let data = response.data,
                       let authResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        completion(.failure(.apiError(code: authResponse.code, message: authResponse.message)))
                    } else {
                        completion(.failure(.networkError(error)))
                    }
                }
            }
    }
}


