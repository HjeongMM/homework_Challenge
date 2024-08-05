//
//  NetworkManager.swift
//  homework_Challenge
//
//  Created by 임혜정 on 8/2/24.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create {observer in
            let session = URLSession(configuration: .default)
            session.dataTask(with: URLRequest(url: url)) { data, response, error in
            
                if let error = error {
                    observer(.failure(error))
                }

                guard let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchFail))
                    return
                }
                
                // 받은 JSON 데이터 출력 테스트
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON data: \(jsonString)")
                }
                
                do {
                    let decodeData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decodeData))
                } catch {
                    print("Decoding error: \(error)")
                    observer(.failure(NetworkError.decodingFail))
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}
