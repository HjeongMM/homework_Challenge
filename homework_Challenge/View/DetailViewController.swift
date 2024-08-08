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
    private let viewModel = MainViewModel()
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
        view.backgroundColor = .mainRed
        bindViewModel()
        detailViewModel.fetchPokemonInfo().subscribe().disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        detailViewModel.image
            .observe(on: MainScheduler.instance)
            .bind(to: detailView.imageView.rx.image)
            .disposed(by: disposeBag)
        
        if let idLabel = detailView.stackView1.arrangedSubviews[0] as? UILabel {
            detailViewModel.id
                .observe(on: MainScheduler.instance)
                .bind(to: idLabel.rx.text)
                .disposed(by: disposeBag)
        }
        // 이름을 두 번째 UILabel에 바인딩
        if let nameLabel = detailView.stackView1.arrangedSubviews[1] as? UILabel {
            Observable.combineLatest(detailViewModel.name, detailViewModel.koreanName)
                .map { englishName, koreanName in
                    "\(koreanName)"
                }
                .observe(on: MainScheduler.instance)
                .bind(to: nameLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let typeLabel = detailView.stackView2.arrangedSubviews[0] as? UILabel {
            detailViewModel.types
                .map { $0.first ?? "" }
                .observe(on: MainScheduler.instance)
                .bind(to: typeLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let heightLabel = detailView.stackView2.arrangedSubviews[1] as? UILabel {
            detailViewModel.height
                .observe(on: MainScheduler.instance)
                .bind(to: heightLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let weightLabel = detailView.stackView2.arrangedSubviews[2] as? UILabel {
            detailViewModel.weight
                .observe(on: MainScheduler.instance)
                .bind(to: weightLabel.rx.text)
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
