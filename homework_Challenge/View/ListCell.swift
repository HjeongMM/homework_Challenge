//
//  ListCell.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/3/24.
//

import UIKit
import SnapKit
import RxSwift

class ListCell: UICollectionViewCell {
    static let id = "ListCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
            super.prepareForReuse()
            imageView.image = nil
            disposeBag = DisposeBag()
        }
    
    func configure(with pokemon: Pokemon, viewModel: MainViewModel) {
            viewModel.getImage(for: pokemon)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] image in
                    self?.imageView.image = image
                })
                .disposed(by: disposeBag)
        }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
    
    
}
