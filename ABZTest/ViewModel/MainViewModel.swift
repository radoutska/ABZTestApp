//
//  MainViewModel.swift
//  ABZTest
//
//  Created by Anna Radoutska on 27.09.2024.
//

import Foundation
import Combine
import SwiftUI

final class MainViewModel: ObservableObject {
    @Published var users: [FullUserModel] = []
    @Published var positions: [Position] = []
    @Published var isLoading: Bool = false
    @Published var image: Image? = nil
    @Published var allUsersLoaded: Bool = false
    var page: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkService = NetworkService()
    
    init() {
        fetchUsers()
        fetchPositions()
    }
    
    func fetchUsers() {
        if !allUsersLoaded {
            networkService.fetchUsers(page: page)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching users: \(error)")
                    case .finished:
                        self?.page += 1
                        break
                    }
                }, receiveValue: { [weak self] response in
                    response.users.forEach { user in
                        self?.networkService.downloadImage(from: user.photo) { image in
                            if let image = image {
                                self?.users.append(FullUserModel(user: user, photo: image))
                            }
                        }
                    }
                    if response.links.nextURL == nil { self?.allUsersLoaded = true }
                }
                )
                .store(in: &cancellables)
        }
    }
    
    func registerUser(name: String, email: String, phone: String, positionId: Int, photo: UIImage, completion: @escaping (Bool, String) -> ()) {
        guard isValidImage(photo), let compressedPhoto = photo.jpegData(compressionQuality: 0.7) else {
            return /*add error*/
        }
        networkService.registerUser(name: name, email: email, phone: phone, positionId: positionId, photo: compressedPhoto) { result in
            switch result {
            case .success(let success):
                completion(true, success)
            case .failure(let failure):
                print(failure.localizedDescription)
                completion(false, failure.localizedDescription)
            }
        }
    }
    
    func fetchPositions() {
        networkService.getPositions()
            .sink {completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching users: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.positions = response.positions
            }
            .store(in: &cancellables)
    }
    
    // Function to check image size and dimensions
    private func isValidImage(_ image: UIImage) -> Bool {
        guard let jpegData = image.jpegData(compressionQuality: 0.7) else {
            return false
        }
        let sizeInMB = Double(jpegData.count) / (1024.0 * 1024.0)
        if sizeInMB > 5 {
            return false
        }
        // Check image dimensions
        let width = image.size.width
        let height = image.size.height
        if width < 70 || height < 70 {
            return false
        }
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // RFC 2822 compliant regex for email validation
        let emailRegex = """
        ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$
        """
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    func isValidUkrainianPhoneNumber(_ phoneNumber: String) -> Bool {
        // Regular expression for Ukrainian phone numbers starting with +380
        let phoneRegex = "^\\+380\\d{9}$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: phoneNumber)
    }
}
