//
//  MainHeaderView.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/4/24.
//

import UIKit
import SnapKit

class MainHeaderView: UIView {
    static let id = "MainHeaderView"
    
    let titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .cyan
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeaderUI() {
        self.addSubview(titleImage)
        
        titleImage.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(60)
        }
    }
}
