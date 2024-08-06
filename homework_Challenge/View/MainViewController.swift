//
//  ViewController.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel(id: 0)
    private let disposeBag = DisposeBag()
    private var pokemonList = [Pokemon]()
    
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
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.id)
    }
    
    private func bind() {
        viewModel.thumbnailImageSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.mainView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout()
    }
    
    
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // numberOfItemsInsection = 아이템을 몇개 불러올거냐
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            return try viewModel.thumbnailImageSubject.value().count
        } catch {
            return 0
        }
    }
    //cellForItemAt 재사용가능한 셀 가져오기, 데이터 구성, 셀 반환 역할
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.id, for: indexPath) as? ListCell else {
            fatalError("Failed to dequeue ListCell")
        }
        
        do {
            let pokemons = try viewModel.thumbnailImageSubject.value()
            let pokemon = pokemons[indexPath.item]
            cell.configure(with: pokemon, viewModel: viewModel)
        } catch {
            print("Error getting pokemon: \(error)")
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedItem =
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
