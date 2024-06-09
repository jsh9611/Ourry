//
//  QuestionDetail.swift
//  Ourry
//
//  Created by SeongHoon Jang on 3/16/24.
//

import Foundation

struct Solution: Codable, Identifiable {
    let id: Int
    let sequence: Int
    let opinion: String
    let createdAt: String?
    let memberId: Int
    let nickname: String
}

struct Reply: Codable {
    let comment: String
    let nickname: String
    let createdAt: String?
    let solutionId: Int
}

struct QuestionDetail: Codable {
    let title: String
    let content: String
    let category: String
    let nickname: String
    let polled: String  // "polled": "A"
    let pollCnt: Int
    let responseCnt: Int
    let createdAt: String?
    let choices: [Choice]
    let solutions: [Solution]
    let replies: [Reply]
}
