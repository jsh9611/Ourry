//
//  UITableView+Extention.swift
//  Ourry
//
//  Created by SeongHoon Jang on 4/20/24.
//

import UIKit

extension UITableView {
    // tableView의 Separator 제거
    func removeExtraCellLines() {
        tableFooterView = UIView(frame: .zero)
    }
}
