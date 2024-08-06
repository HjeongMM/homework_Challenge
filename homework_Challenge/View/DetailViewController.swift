//
//  DetailViewController.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/6/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("df")
        view.backgroundColor = .mainRed
    }
}
