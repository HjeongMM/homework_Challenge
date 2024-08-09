//
//  MainView.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/2/24.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemonBall")
        return imageView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .darkRed
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCollectionView(){
        [imageView, collectionView].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(78)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}
