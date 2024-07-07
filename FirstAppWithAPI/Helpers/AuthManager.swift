import Foundation

enum LoginError: Error {
    case tokenNotFound
    case invalidResponse
}

enum APIError: Error {
    case invalidOTP
    case networkError
}

struct AuthManager {
    static let shared = AuthManager()
    
    private let accessTokenKey = "accessToken"
    
    var isLoggedIn: Bool {
        return accessToken != nil
    }
    
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    func clearAccessToken() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        AuthService.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let jwtData = response.data.jwt else {
                        completion(.failure(LoginError.tokenNotFound))
                        return
                    }
                    
                    self.saveAccessToken(jwtData.access_token)
                    completion(.success(jwtData.access_token))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func register(full_name: String, email: String, password: String, password_confirmation: String, completion: @escaping(Result<String, Error>) -> Void) {
        AuthService.shared.register(fullName: full_name, email: email, password: password, passwordConfirmation: password_confirmation) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // Check if response message is "success"
                    if response.message == "success" {
                        completion(.success("User created successfully"))
                    } else {
                        completion(.failure(NSError(domain: "", code: response.status, userInfo: [NSLocalizedDescriptionKey: response.message])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
//    func verifyOTP(email: String, otpCode: String, completion: @escaping(Result<String, Error>) -> Void) {
//       AuthService.shared.verifyOTP(email: email, otpCode: otpCode) { result in
//           DispatchQueue.main.async {
//               switch result {
//               case .success(let response):
//                   completion(.success(response))
//               case .failure(let error):
//                   completion(.failure(error))
//               }
//           }
//       }
//   }
//
    func verifyOTP(email: String, otpCode: String, completion: @escaping(Result<String, Error>) -> Void) {
        AuthService.shared.verifyOTP(email: email, otpCode: otpCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.saveAccessToken(response)
                    completion(.success("OTP verified successfully"))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    func logout() {
        clearAccessToken()
    }
}
