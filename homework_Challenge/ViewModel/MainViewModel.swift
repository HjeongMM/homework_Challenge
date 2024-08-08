//
//  MainViewModel.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/2/24.
//

import Foundation
import RxSwift
import UIKit

class MainViewModel {
    private let disposeBag = DisposeBag()
    
    let thumbnailImageSubject = BehaviorSubject(value: [Pokemon]())
    private var imageCache = NSCache<NSString, UIImage>()
    
    func fetchThumbnail() {
        // limit=20개, offset = 0 까지만
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20?offset=0") else { return }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: PokemonListResponse) in //리스폰스 타입을 잘봐라
                self?.thumbnailImageSubject.onNext(response.results)
            }, onFailure: { [weak self] error in
                self?.thumbnailImageSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func getImage(for pokemon: Pokemon) -> Observable<UIImage?> {
        let id = pokemon.id
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            return Observable.just(cachedImage)
        } // 이미지 캐싱처리하여 두번째부터는 빠르게 처리
        
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
