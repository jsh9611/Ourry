//
//  Date+Extention.swift
//  Ourry
//
//  Created by SeongHoon Jang on 1/11/24.
//

import Foundation

extension Date {
    
    // 현재 시간과 비교해 시간의 차이를 반환해주는 함수
    func timeAgoString() -> String {
        let now = Date()
        let then = Int(now.timeIntervalSince(self))

        if then <= 60 {
            return "방금"
        } else if then <= 3600 {
            let minutes = then / 60
            return String(format: "%01d분 전", minutes)
        } else if then <= 86400 {
            let hours = then / 3600
            return String(format: "%01d시간 전", hours)
        } else {
            let days = then / 86400
            return String(format: "%01d일 전", days)
        }
    }
}
