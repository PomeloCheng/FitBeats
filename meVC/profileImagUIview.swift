//
//  profileImagUIview.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/14.
//

import UIKit

class CustomOptionsView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "更換大頭照"
        label.textAlignment = .center
        label.backgroundColor = UIColor.tintColor
        label.textColor = .white
        return label
    }()

    let cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("拍照", for: .normal)
        button.setTitleColor(UIColor.tintColor, for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 138/255, blue: 163/255, alpha: 1), for: .highlighted)
        button.backgroundColor = .white
        return button
    }()

    let albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("從相簿選擇", for: .normal)
        button.setTitleColor(UIColor.tintColor, for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 138/255, blue: 163/255, alpha: 1), for: .highlighted)
        button.backgroundColor = .white
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
        // 添加子视图并设置布局
        addSubview(titleLabel)
        addSubview(cameraButton)
    
        addSubview(albumButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        albumButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 标题布局
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            // 拍照按钮布局
            cameraButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cameraButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 48),
            
            // 从相簿选择按钮布局
            albumButton.topAnchor.constraint(equalTo: cameraButton.bottomAnchor),
            albumButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            albumButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}







