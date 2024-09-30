//
//  LoginService.swift
//  ABZTest
//
//  Created by Anna Radoutska on 27.09.2024.
//

import Foundation
import Combine
import Alamofire

class NetworkService {
    enum RequestsUrl {
        case users(page: Int)
        case user(id: String)
        case token
        case create
        case positions
        
        var baseUrl: String {
            "https://frontend-test-assignment-api.abz.agency/api/v1/"
        }
        
        var url: URL? {
            switch self {
            case .users(let page):
                guard let url = URL(string: baseUrl + "users" + "?page=\(page)&count=6") else { return nil }
                return url
            case .user(let id):
                guard let url = URL(string: baseUrl + "users/" + id) else { return nil}
                return url
            case .token:
                guard let url = URL(string: baseUrl + "token") else { return nil}
                return url
            case .create:
                guard let url = URL(string: baseUrl + "users") else { return nil}
                return url
            case .positions:
                guard let url = URL(string: baseUrl + "positions") else { return nil}
                return url
            }
        }
    }
    
    private let networkClient = NetworkClient()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUsers(page: Int) -> AnyPublisher<UserResponse, Error> {
        guard let url = RequestsUrl.users(page: page).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        return networkClient.performRequest(url: url)
    }
    
    func downloadImage(from url: String, completion: @escaping (UIImage) -> Void) {
        guard let imageURL = URL(string: url) else {
            print("Invalid URL")
            completion(UIImage())
            return
        }
        
        AF.request(imageURL).responseData { response in
            switch response.result {
            case .success(let data):
                // Check if the data can be converted to a UIImage
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    print("Data could not be converted to UIImage")
                    completion(UIImage())
                }
            case .failure(let error):
                print("Error downloading image: \(error)")
                completion(UIImage())
            }
        }
    }
    
    func registerUser(name: String, email: String, phone: String, positionId: Int, photo: Data, completion: @escaping (Result<String, Error>) -> Void) {
        renewToken()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error getting token: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { (response: AuthResponse) in
                print(response.token)
                let headers = HTTPHeaders([
                    HTTPHeader(name: "Content-Type", value: "multipart/form-data"),
                    HTTPHeader(name: "accept", value: "application/json"),
                    HTTPHeader(name: "token", value: response.token)
                ])
                
                AF.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append(Data(name.utf8), withName: "name")
                        multipartFormData.append(Data(email.lowercased().utf8), withName: "email")
                        multipartFormData.append(Data(phone.utf8), withName: "phone")
                        multipartFormData.append("\(positionId)".data(using: .utf8)!, withName: "position_id")
                        multipartFormData.append(photo, withName: "photo", fileName: "profile.jpg", mimeType: "image/jpeg")
                    },
                    to: RequestsUrl.create.url!,
                    method: .post,
                    headers: headers
                )
                .validate()
                .responseDecodable(of: UserCreationResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        completion(.success(result.message))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            )
            .store(in: &cancellables)
    }
    
    func getPositions() -> AnyPublisher<PositionsResponse, Error> {
        guard let url = RequestsUrl.positions.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        return networkClient.performRequest(url: url)
    }
    
    func renewToken() -> AnyPublisher<AuthResponse, Error> {
        guard let url = RequestsUrl.token.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        return networkClient.performRequest(url: url)
    }
}

class NetworkClient {
    func performRequest<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data) // Extract data from response
            .decode(type: T.self, decoder: JSONDecoder()) // Decode the data into specified model
            .receive(on: DispatchQueue.main) // Switch back to the main thread
            .eraseToAnyPublisher() // Erase the type to AnyPublisher for flexibility
    }
}

enum NetworkError: Error {
    case decodingError
    case unknownError
    case validationFailed
    case tokenExpired
}
