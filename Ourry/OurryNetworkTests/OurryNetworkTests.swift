//
//  OurryNetworkTests.swift
//  OurryNetworkTests
//
//  Created by SeongHoon Jang on 12/30/23.
//

import XCTest
import Alamofire
@testable import Ourry

final class OurryNetworkTests: XCTestCase {
    var sut: LoginManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let session: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        sut = LoginManager(session: session)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_로그인에_성공했을때() {
        print("안녕하세요")
        // given
        MockURLProtocol.responseWithDTO(type: .login)
        MockURLProtocol.responseWithStatusCode(code: 200)
        let email = "asdf@asdf.asdf"
        let password = "asdf"
        let expectation = XCTestExpectation(description: "Performs a request")
        
        // when
        sut.login(email: email, password: password) { result in
            // then
            switch result {
            case .success(let jwt):
                XCTAssertEqual(jwt, "JWT TOKEN 예정", "로그인 성공")
                expectation.fulfill()
            case .failure(let error):
                debugPrint(error)
                XCTFail("에러 발생")
            }
        }
    
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_로그인에_실패했을때() {
        // given
        MockURLProtocol.responseWithDTO(type: .wrongPW)
        MockURLProtocol.responseWithStatusCode(code: 200) // 실패를 나타내는 200 상태 코드로 설정
        let email = "asdf@asdf.asdf"
        let password = "wrong_password"
        let expectation = XCTestExpectation(description: "Performs a request")

        // when
        sut.login(email: email, password: password) { result in
            // then
            switch result {
            case .success:
                XCTFail("로그인이 성공했으나, 성공이 아닌 결과가 나왔습니다.")
            case .failure(let error):
                XCTAssertEqual(error, AuthError.apiError(code: "M003", message: "비밀번호가 일치하지 않습니다."), "예상된 API 에러가 아닙니다.")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_로그인_네트워크오류일때() {
        // given
        MockURLProtocol.responseWithDTO(type: .login)
        MockURLProtocol.responseWithStatusCode(code: 401) // 401 Unauthorized를 설정
        
        let email = "asdf@asdf.asdf"
        let password = "asdf"
        let expectation = XCTestExpectation(description: "Performs a request")
        
        // when
        sut.login(email: email, password: password) { result in
            // then
            switch result {
            case .success(let jwt):
                XCTFail("로그인 성공 - 예상치 않은 성공")
            case .failure(let error):
                // 응답의 status가 400~499이면 성공, 아니면 실패
                if case AuthError.networkError(let networkError) = error,
                   case Alamofire.AFError.responseValidationFailed(reason: Alamofire.AFError.ResponseValidationFailureReason.unacceptableStatusCode(let code)) = networkError {
                    XCTAssertTrue((400...499).contains(code), "예상된 네트워크 에러 코드 범위가 아닙니다.")
                    expectation.fulfill()
                } else {
                    XCTFail("예상치 않은 에러 형식")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
