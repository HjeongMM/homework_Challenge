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
    // RxSwift의 DisposeBag 인스턴스를 생성하여 메모리 누수를 방지하고 구독을 관리한다.
    private let disposeBag = DisposeBag()
    // Pokemon의 고유 식별자를 저장하는 private 프로퍼티이다. 외부에서 직접 접근할 수 없다.
    private let id: Int
    
    // Pokemon 배열을 관리하는 BehaviorSubject를 생성한다. 초기값은 빈 배열이며, 옵저버들에게 최신 데이터를 제공한다.
    let thumbnailImageSubject = BehaviorSubject<[Pokemon]>(value: [])
    // 이미지 캐싱을 위한 NSCache 인스턴스를 생성한다. 메모리 사용을 최적화하고 네트워크 요청을 줄인다.
    private var imageCache = NSCache<NSString, UIImage>()
    
    // 생성자에서 Pokemon의 id를 받아 저장한다. 이 id는 이후 특정 Pokemon 데이터를 가져올 때 사용될 수 있다.
    init(id: Int) {
        self.id = id
    }
    
    // Pokemon 썸네일 데이터를 API로부터 가져오는 메서드이다.
    func fetchThumbnail() {
        // PokeAPI의 엔드포인트 URL을 생성한다. 최대 20개의 Pokemon 데이터를 요청한다.
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20?offset=0") else { return }
        
        // NetworkManager의 shared 인스턴스를 사용하여 데이터를 비동기적으로 가져온다.
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: PokemonListResponse) in
                // API 호출이 성공하면 받은 Pokemon 목록을 thumbnailImageSubject에 새 값으로 전달한다.
                self?.thumbnailImageSubject.onNext(response.results)
            }, onFailure: { [weak self] error in
                // API 호출이 실패하면 발생한 에러를 thumbnailImageSubject에 전달하여 구독자들에게 알린다.
                self?.thumbnailImageSubject.onError(error)
            }).disposed(by: disposeBag)  // 구독을 disposeBag에 추가하여 메모리 누수를 방지한다.
    }
    
    // 특정 Pokemon의 이미지를 가져오는 메서드이다. 결과를 Observable<UIImage?>로 반환한다.
    func getImage(for pokemon: Pokemon) -> Observable<UIImage?> {
        // Pokemon의 id가 없으면 즉시 nil을 포함한 Observable을 반환한다.
        guard let id = pokemon.id else {
            return Observable.just(nil)
        }
        
        // Pokemon 이미지의 URL 문자열을 생성한다.
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        
        // 이미 캐시된 이미지가 있는지 확인하고, 있다면 해당 이미지를 포함한 Observable을 즉시 반환한다.
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            return Observable.just(cachedImage)
        }
        
        // URL 문자열이 유효한 URL인지 확인한다. 유효하지 않으면 nil을 포함한 Observable을 반환한다.
        guard let url = URL(string: urlString) else {
            return Observable.just(nil)
        }
        
        // 새로운 Observable을 생성하여 이미지를 비동기적으로 로드한다.
        return Observable.create { [weak self] observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let self = self, let data = data, let image = UIImage(data: data) else {
                    // 이미지 로드에 실패하면 nil을 observer에 전달하고 완료를 알린다.
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                
                // 성공적으로 로드된 이미지를 캐시에 저장한다.
                self.imageCache.setObject(image, forKey: NSString(string: urlString))
                // 로드된 이미지를 observer에 전달하고 완료를 알린다.
                observer.onNext(image)
                observer.onCompleted()
            }
            task.resume()  // URLSession 작업을 시작한다.
            
            // Observable이 dispose될 때 실행될 클로저를 반환한다. 이는 진행 중인 네트워크 작업을 취소한다.
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
