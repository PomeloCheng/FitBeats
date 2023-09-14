//
//  profileAlertUIview.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/14.
//

import UIKit


class CustomAlertView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "111"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let textField:UITextField = {
        
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 40)) // 设置左侧间距的宽度
        // 将左侧间距视图设置为 leftView
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always // 始终显示 leftView
        return textField
    }()

    let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.tintColor // 设置 OK 按钮的背景颜色
        button.setTitleColor(UIColor.white, for: .normal) // 设置文字颜色
        button.setTitle("確定", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 138/255, blue: 163/255, alpha: 1), for: .highlighted)
        button.layer.cornerRadius = 20
        return button
    }()

    let cancleButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1.0 // 设置取消按钮的边框宽度
        button.layer.borderColor = UIColor.tintColor.cgColor // 设置取消按钮的边框颜色
        button.setTitleColor(UIColor.tintColor, for: .normal) // 设置文字颜色
        button.setTitleColor(UIColor(red: 0, green: 138/255, blue: 163/255, alpha: 1), for: .highlighted)
        button.setTitle("取消", for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
    private func setupUI() {
        
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(okButton)
        addSubview(cancleButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        cancleButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            // 标题布局
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            // 拍照按钮布局
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            
            cancleButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            cancleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cancleButton.trailingAnchor.constraint(equalTo: okButton.leadingAnchor, constant: -16),
            cancleButton.heightAnchor.constraint(equalToConstant: 40),
            
            
            okButton.topAnchor.constraint(equalTo: textField.bottomAnchor,constant: 16),
            okButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            okButton.heightAnchor.constraint(equalToConstant: 40),
            okButton.widthAnchor.constraint(equalTo: cancleButton.widthAnchor)
            
            
            
        ])
        
    }
}
