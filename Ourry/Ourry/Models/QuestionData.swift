//
//  QuestionData.swift
//  Ourry
//
//  Created by SeongHoon Jang on 5/6/24.
//

import Foundation

// 질문 추가 요청 POST(addQuestion)
struct QuestionData: Encodable {
    let title: String
    let content: String
    let categoryId: Int
    let choices: [Select]
}

struct Select: Encodable {
    let detail: String
    let sequence: Int
}
