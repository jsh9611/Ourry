//
//  QuestionInfo.swift
//  Ourry
//
//  Created by SeongHoon Jang on 3/16/24.
//

import Foundation

struct QuestionInfo: Codable, Identifiable {
    let id: Int
    let title: String
    let content: String
    let nickname: String
    let pollCnt: Int
    let responseCnt: Int
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "questionId"
        case title
        case content
        case nickname
        case pollCnt
        case responseCnt
        case createdAt
    }
}

