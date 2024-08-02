//
//  MainViewModel.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/2/24.
//

import Foundation
import RxSwift

class MainViewModel {
    private let disposeBag = DisposeBag()
    private let id: Int
    
    let thumbnailImageSubject = PublishSubject<Data>()
    
    init(id: Int) {
        self.id = id
    }
    
    func fetchThumbnail() {
        guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png") else {
            thumbnailImageSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (imageData: Data) in
                self?.thumbnailImageSubject.onNext(imageData)
            }, onFailure: { [weak self] error in
                self?.thumbnailImageSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
