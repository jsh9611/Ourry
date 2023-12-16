//
//  UIViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/30.
//

import Foundation

//MARK: - Previews 사용
/*
 
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct LoginViewPreviews: PreviewProvider {
    static var previews: some View {
        LoginViewController().toPreview()
    }
}
#endif

*/

//MARK: - UI를 작업에 도움을 주는 extension
#if canImport(SwiftUI) && DEBUG
import SwiftUI
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif

// 탭해서 키보드 숨기기
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
