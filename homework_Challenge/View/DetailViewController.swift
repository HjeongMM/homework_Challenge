//
//  DetailViewController.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/6/24.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    private let detailViewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    
    init(pokemon: Pokemon) {
            self.detailViewModel = DetailViewModel(pokemon: pokemon)
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("df")
        view.backgroundColor = .mainRed
        bindViewModel()
        detailViewModel.fetchPokemonInfo().subscribe().disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        if let idLabel = detailView.stackView1.arrangedSubviews[0] as? UILabel {
            detailViewModel.id
                .observe(on: MainScheduler.instance)
                .bind(to: idLabel.rx.text)
                .disposed(by: disposeBag)
        }
        // 이름을 두 번째 UILabel에 바인딩
        if let nameLabel = detailView.stackView1.arrangedSubviews[1] as? UILabel {
            detailViewModel.name
                .observe(on: MainScheduler.instance)
                .bind(to: nameLabel.rx.text)
                .disposed(by: disposeBag)
        }
        

        
        // 에러 처리
        //        detailViewModel.error
        //            .observe(on: MainScheduler.instance)
        //            .subscribe(onNext: { error in
        //                print("Error: \(error)")
        //            })
        //            .disposed(by: disposeBag)
        //    }
    }
}
