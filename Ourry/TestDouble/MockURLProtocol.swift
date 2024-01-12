//
//  MockURLProtocol.swift
//  Ourry
//
//  Created by SeongHoon Jang on 1/1/24.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse?, Data?, Error?))?
    
    enum ResponseType {
        case error(Error)
        case success(HTTPURLResponse)
    }
    
    static var responseType: ResponseType!
    static var dtoType: MockDTOType!
    
    private lazy var session: URLSession = {
        // Ephemeral session: 비공개 세션으로, 쿠키나 세션정보가 남아있지 않기 위함
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration)
    }()
    
    private(set) var activeTask: URLSessionTask?
    
    /// 프로토콜이 파라미터로 전달받은 요청을 처리할 수 있는지 검사하는 메소드
    ///
    /// 테스트를 하기 위해 무조건 처리할 수 있다라는 true로 설정
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    /// 표준 버전의 URLRequest를 반환
    ///
    /// 요청 그대로 전달
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /// 캐시 처리 목적으로 두 요청이 동일한지를 판단하는 메소드
    ///
    /// 캐싱이 필요한 순간이 아니라 false를 반환하도록 설정
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    /// 요청에 대해 피드백을 해주는 메소드
    ///
    /// 가짜 데이터를 반환하기 위해 가짜 데이터를 내보내는 코드.
    /// 세션을 비공개 세션으로 만든 뒤, dataTask를 실행하도록 구현.
    override func startLoading() {
//        guard let handler = MockURLProtocol.requestHandler else {
//          fatalError()
//        }
//        let (response, data, error) = handler(request)
        let response = setUpMockResponse()
        let data = setUpMockData()
        
        // 저장한 가짜 response를 client에게 전달
        if let response = response {
              client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        
        // 저장한 가짜 data를 clinet에게 전달
        if let data = data {
          client?.urlProtocol(self, didLoad: data)
        }
        
        // request가 완료된 것을 알림
        self.client?.urlProtocolDidFinishLoading(self)
        
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel()
    }

    
    private func setUpMockResponse() -> HTTPURLResponse? {
        var response: HTTPURLResponse?
        switch MockURLProtocol.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let newResponse)?:
            response = newResponse
        default:
            fatalError("No fake responses found.")
        }
        return response!
    }
    
    private func setUpMockData() -> Data? {
        let fileName: String = MockURLProtocol.dtoType.fileName

       // 번들에 있는 json 파일로 Data 객체를 뽑아내는 과정.
        guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return Data()
        }
        return try? Data(contentsOf: file)
    }
    
    // 실제 네트워크 요청이 아닌 가짜 Response를 받기 위한 과정이므로 task가 시작하자마자 cancel한다.
    override func stopLoading() {
        activeTask?.cancel()
    }
}

extension MockURLProtocol {
    
    enum MockError: Error {
        case none
    }
    
    static func responseWithFailure() {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.error(MockError.none)
    }
    
    static func responseWithStatusCode(code: Int) {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!)
    }
    
    static func responseWithDTO(type: MockDTOType) {
        MockURLProtocol.dtoType = type
    }
}

extension MockURLProtocol {
    
    enum MockDTOType {
        case success
        case login
        case signup
        case dupeEmail
        case wrongEmailType
        case wrongPW
        case noMember
        case noVerify
        case wrongCode
        case timeout
        
        var fileName: String {
            switch self {
            case .success: return "mock_authRequest.json"
            case .login: return "mock_login.json"
            case .signup: return "mock_signup.json"
            case .dupeEmail: return "mock_m001.json"
            case .wrongEmailType: return "mock_m002.json"
            case .wrongPW: return "mock_m003.json"
            case .noMember: return "mock_m004.json"
            case .noVerify: return "mock_m005.json"
            case .wrongCode: return "mock_m006.json"
            case .timeout: return "mock_m007.json"
            }
        }
    }
    
    
}
