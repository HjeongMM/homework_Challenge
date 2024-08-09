//
//  MainViewModel.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/2/24.
//

import UIKit
import RxSwift

class MainViewModel {
    private let disposeBag = DisposeBag()
    private var imageCache = NSCache<NSString, UIImage>()
    let thumbnailImageSubject = BehaviorSubject(value: [Pokemon]())
    // limit = 20 페이지네이션 학습
    private var offset = 0
    private var isLoading = false
    
    
    func fetchThumbnail() {
        guard !isLoading else { return }
        isLoading = true
        
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=\(offset)"
        guard let url = URL(string: urlString) else { return }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: PokemonListResponse) in
                guard let self = self else { return }
                let currentList = try? self.thumbnailImageSubject.value()
                let newList = (currentList ?? []) + response.results
                self.thumbnailImageSubject.onNext(newList)
                self.offset += response.results.count
                self.isLoading = false
            }, onFailure: { [weak self] error in
                self?.thumbnailImageSubject.onError(error)
                self?.isLoading = false
            }).disposed(by: disposeBag)
    }
    
    func loadMore(currentIndex: Int) {
        let thresholdIndex = self.offset - 5
        if currentIndex == thresholdIndex {
            fetchThumbnail()
        }
    }
    
    func getImage(for pokemon: Pokemon) -> Observable<UIImage?> {
        let id = pokemon.id
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            return Observable.just(cachedImage)
        }
        
        guard let url = URL(string: urlString) else {
            return Observable.just(nil)
        }
        
        return Observable.create { [weak self] observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let self = self, let data = data, let image = UIImage(data: data) else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                
                self.imageCache.setObject(image, forKey: NSString(string: urlString))
                observer.onNext(image)
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
