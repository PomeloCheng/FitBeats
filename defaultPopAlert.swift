//
//  defaultPopAlert.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/23.
//

import UIKit

class popAlertView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "popMark.png")
        imageView.image = image
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "提示"
        label.textColor = UIColor.tintColor
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.tintColor // 设置 OK 按钮的背景颜色
        button.setTitleColor(UIColor.white, for: .normal) // 设置文字颜色
        button.setTitle("確定", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 138/255, blue: 163/255, alpha: 1), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 8
        return button
    }()

    let cancleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 225/255, green: 227/255, blue: 234/255, alpha: 1)
        button.setTitleColor(UIColor.black, for: .normal) // 设置文字颜色
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private func setupUI() {
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(okButton)
        addSubview(cancleButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        cancleButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
            // 标题布局
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            cancleButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            cancleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cancleButton.trailingAnchor.constraint(equalTo: okButton.leadingAnchor, constant: -8),
            cancleButton.heightAnchor.constraint(equalToConstant: 40),
            
            
            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor,constant: 16),
            okButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            okButton.heightAnchor.constraint(equalToConstant: 40),
            okButton.widthAnchor.constraint(equalTo: cancleButton.widthAnchor)
            
        ])
        
    }
    
}
