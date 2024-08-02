//
//  ViewController.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/1/24.
//

import UIKit

class MainViewController: UIViewController {

    private var mainView: MainView?
    private let viewModel = MainViewModel(id: 0)
    private var pokemonList = [Pokemon]()
    
    override func loadView() {
        mainView = MainView()
        view = mainView
    }
    
//    private lazy var collectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero), collectionViewLayout: createLayout
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

