//
//  DetailView.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/6/24.
//

import UIKit
import SnapKit

class DetailView: UIView {
    
    private let darkRedstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .darkRed
        stackView.layer.cornerRadius = 20
        return stackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let stackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private func detailLargeLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }
    
    private func detailSmallLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDetailView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDetailView() {
        self.backgroundColor = .darkRed
        [darkRedstackView].forEach {
            self.addSubview($0)
        }
        
        darkRedstackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(400)
        }
        
        setupStackView()
    }
    
    private func setupStackView() {
        [imageView, stackView1, stackView2].forEach {
            self.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(darkRedstackView.snp.top).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(160)
        }
        
        stackView1.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(30)
        }
        
        stackView2.snp.makeConstraints {
            $0.top.equalTo(stackView1.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(160)
        }
        
        addLargeLabel()
        addSmallLabel()
    }

    private func addLargeLabel() {
        (1...2).forEach { label in
            let label = detailLargeLabel()
            stackView1.addArrangedSubview(label)
        }
    }
    
    private func addSmallLabel() {
        (1...3).forEach { label in
            let label = detailSmallLabel()
            stackView2.addArrangedSubview(label)
        }
    }
}
