//
//  Networkable.swift
//  GoodLifeApplocation
//
//  Created by heba isaa on 27/08/2022.
//

import Foundation
import Moya


protocol Networkable{
    associatedtype targetType:TargetType
    var provider: MoyaProvider<targetType> { get }
    func request<T:Decodable>(target:targetType,completion: @escaping (Result<T, Error>) -> ())
}
extension Networkable{

    func request<T: Decodable>(target: targetType, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
              switch result {
             case let .success(response):
                if  response.statusCode == 401 {
                   
                    if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//                         delegate.setRootVC(vc: SplashScreen())
                     }
                    
                } else if  response.statusCode == 200 {
                    do {
                        print(String(data: response.data, encoding: .utf8))
                        let results = try JSONDecoder().decode(T.self, from: response.data)
                        completion(.success(results))
                    } catch let error {
                        print(error)
                        completion(.failure(error))
                    } }
            case let .failure(error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
}
