//
//  AddQuestionViewModel.swift
//  Ourry
//
//  Created by SeongHoon Jang on 5/6/24.
//

import Foundation
import Alamofire

class AddQuestionViewModel {
    
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
        guard let jwt = KeychainHelper.read(forAccount: "access_token") else {
            completion(.failure(.invalidResponse))
            return
        }
        //        KeychainHelper.create(token: authorization, forAccount: "access_token")
        let headers: HTTPHeaders =  ["Authorization" : jwt]
        
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
    
    func addQuestionRequest(questionData: QuestionData, completion: @escaping (Result<String, AuthError>) -> Void) {
        let url = Endpoint.addQuestion.url
        let encoder: ParameterEncoder = JSONParameterEncoder.default
        guard let authorization = KeychainHelper.read(forAccount: "access_token") else {
            completion(.failure(.invalidResponse))
            return
        }
        
        let headers: HTTPHeaders =  ["Authorization" : authorization]
        
        session
            .request(url, method: .post, parameters: questionData, encoder: encoder, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Empty.self, emptyResponseCodes: [200]) { response in
                switch response.result {
                case .success:
                    completion(.success("성공"))
                case .failure:
                    if let data = response.data,
                       let authResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data),
                       authResponse.code == "A002" {
                        completion(.failure(.expiredToken))
                    } else {
                        completion(.failure(.invalidResponse))
                    }
                }
            }
    }
}
