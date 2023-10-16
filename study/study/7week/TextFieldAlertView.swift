//
//  TextFieldAlertView.swift
//  study
//
//  Created by zumin you on 2023/10/16.
//

import SwiftUI
import UIKit

struct TextFieldAlertView: UIViewControllerRepresentable {
    @EnvironmentObject var webViewModel: WebViewModel
    
    var title: String
    var message: String
    
    @Binding var textString: String
    @Binding var showAlert: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlertView>) -> some UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<TextFieldAlertView>) {
        
        // uiAlertController가 없을 때만 띄움
        guard context.coordinator.uiAlertController == nil else { return }
        if !self.showAlert { return }
        
        let uiAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        uiAlertController.addTextField { textField in
            textField.placeholder = "전달할 값을 입력하세요."
            textField.text = textString
        }
        
        uiAlertController.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { _ in
            print("취소")
            self.textString = ""
        }))
        
        uiAlertController.addAction(UIAlertAction(title: "보내기", style: .default, handler: { _ in
            print("보내기")
            if let textField = uiAlertController.textFields?.first,
               let inputText = textField.text {
                self.textString = inputText
            }
            uiAlertController.dismiss(animated: true) {
                print("alert dismissed, send button clicked")
                self.webViewModel.nativeToJSEvent.send(textString)
//                self.showAlert = false // TODO: ?
            }
        }))
        
        DispatchQueue.main.async {
            uiViewController.present(uiAlertController, animated: true) {
                self.showAlert = false
                context.coordinator.uiAlertController = nil
            }
        }
    }
    
    func makeCoordinator() -> TextFieldAlertView.Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject {
        var uiAlertController: UIAlertController?
        var textFieldAlertView: TextFieldAlertView
        
        init(_ textFieldAlertView: TextFieldAlertView) {
            self.textFieldAlertView = textFieldAlertView
        }
    }
}

extension TextFieldAlertView.Coordinator: UITextFieldDelegate {
    /// 글자가 입력될때 실행
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as? NSString {
            self.textFieldAlertView.textString = text.replacingCharacters(in: range, with: string)
        } else {
            self.textFieldAlertView.textString = ""
        }
        
        return true
    }
}
