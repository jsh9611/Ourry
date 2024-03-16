//
//  QuestionInfo.swift
//  Ourry
//
//  Created by SeongHoon Jang on 3/16/24.
//

import Foundation

struct QuestionInfo: Codable {
    let title: String
    let content: String
    let nickname: String
    let pollCnt: Int
    let responseCnt: Int
    let createdAt: String?
}
