//
//  QuestionDetail.swift
//  Ourry
//
//  Created by SeongHoon Jang on 3/16/24.
//

import Foundation

struct Choice: Codable {
    let sequence: Int
    let detail: String
    let count: Int
}

struct Solution: Codable {
    let sequence: Int
    let opinion: String
    let createdAt: Date?
    let memberId: Int
    let nickname: String
}

struct Reply: Codable {
    let comment: String
    let nickname: String
    let createdAt: Date?
    let solutionId: Int
}

struct QuestionDetail: Codable {
    let title: String
    let content: String
    let category: String
    let nickname: String
    let pollCnt: Int
    let responseCnt: Int
    let createdAt: Date? // 이 부분은 데이터에서 null로 제공될 수 있으므로 옵셔널로 설정합니다.
    let choices: [Choice]
    let solutions: [Solution]
    let replies: [Reply]
}
