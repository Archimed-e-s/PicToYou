import UIKit
import Alamofire

final class ConfigAlamofire {
    
    let decoder = JSONDecoder()
    enum CustomError: Error {
        case invalidItemsCount
        case invalidParametersCount
        case invalidURL
        case AFError(Error)
    }

    func getRandomPhotosAlamofire(count: Int, completion: @escaping (Result<[NetworkImageModel]?, CustomError>)  -> Void)  {

        guard count > 0 else {
            completion(.failure(.invalidItemsCount))
            return
        }

        let apiKey = "LChG-Rp9cG7HTdzP8LW1LspsaV6772fUCNVA-yh3e3M"
        let url = "https://api.unsplash.com/photos/random"
        let parameters: [String: Any] = [
            "count" :count,
            "client_id" :apiKey
        ]

        guard parameters.count >= 2 else {
            completion(.failure(.invalidParametersCount))
            return
        }

        AF.request(
        url,
        method: .get,
        parameters: parameters
        ).responseDecodable(of: [NetworkImageModel].self) { response in
            switch response.result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(.AFError(error)))
            }
        }
    }
    
    func getRandomPhotos(count: Int) async throws -> [NetworkImageModel] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random"
        components.queryItems = [
            URLQueryItem(name: "count", value: "\(count)"),
            URLQueryItem(name: "client_id", value: "LChG-Rp9cG7HTdzP8LW1LspsaV6772fUCNVA-yh3e3M")
        ]
        guard let url = components.url else {
            throw CustomError.invalidURL
        }
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let model = try decoder.decode([NetworkImageModel].self, from: data)
        return model
    }
}

