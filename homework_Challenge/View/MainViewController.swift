//
//  ViewController.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/1/24.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainRed
        setupCollectionView()
        bind()
        viewModel.fetchThumbnail()
    }
    
    private func setupCollectionView() {
        //        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.id)

    }

    private func bind() {
        viewModel.thumbnailImageSubject
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: ListCell.id, cellType: ListCell.self)) { [weak self] (row, pokemon, cell) in
                guard let self = self else { return }
                cell.configure(with: pokemon, viewModel: self.viewModel)
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.modelSelected(Pokemon.self)
            .subscribe(onNext: { [weak self] pokemon in
                self?.showDetailViewController(for: pokemon)
            })
            .disposed(by: disposeBag)
    }
    
    private func showDetailViewController(for pokemon: Pokemon) {
        let detailViewModel = DetailViewModel(pokemon: pokemon)
        let detailViewController = DetailViewController(pokemon: pokemon)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10 // 화면 가장자리 여백
        let availableWidth = view.bounds.width - 20 - (padding * 2)
        let width = availableWidth / 3
        let height = width
        
        return CGSize(width: width, height: height)
    }
}
