//
//  EndPoint.swift
//  mvvmRickAndMorty
//
//  Created by Макар Тюрморезов on 30.11.2023.
//

import Foundation

// MARK: - Api request

class NetworkManager {
    
    func getResult(page: Int, completion: @escaping(Result<CharactersModel?, Error>) -> Void) {
        let url = URL(string: URLManager.rickURLCreator(page: page))
        URLSession.shared.dataTask(with: url!) { data, _, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            do {
                let result = try JSONDecoder().decode(CharactersModel.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func getCharName(name: String, completion: @escaping(Result<CharactersModel?, Error>) -> Void)
    {
        let url = URL(string: URLManager.charNameFinder(name: name))
        URLSession.shared.dataTask(with: url!) { data, _, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            do {
                let result = try JSONDecoder().decode(CharactersModel.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
