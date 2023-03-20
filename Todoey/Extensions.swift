//
//  Color.swift
//  Todoey
//
//  Created by Yerzhan Syzdyk on 06.03.2023.
//

import Foundation
import UIKit

//MARK: - Custom views

final class ViewTextField: UIView {
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.textColor = .label
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        layer.borderWidth = 2
        layer.cornerRadius = 10
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Priority: Int16, CaseIterable {
    case high = 1, medium = 2, low = 3
}

extension Date {
    
    static func toString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
