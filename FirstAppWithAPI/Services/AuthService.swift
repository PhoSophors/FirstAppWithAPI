import Foundation

class AuthService {
    static let shared = AuthService()
    private let apiService = APIService.shared
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let endpoint = Constants.API.loginEndpoint
        let parameters = ["email": email, "password": password]
        
        apiService.request(endpoint: endpoint, method: "POST", parameters: parameters) { (result: Result<LoginResponse, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func register(fullName: String, email: String, password: String, passwordConfirmation: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        let endpoint = Constants.API.registerEndpoint
        let parameters = [
            "full_name": fullName,
            "email": email,
            "password": password,
            "password_confirmation": passwordConfirmation
        ]
        
        apiService.request(endpoint: endpoint, method: "POST", parameters: parameters) { (result: Result<RegisterResponse, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func verifyOTP(email: String, otpCode: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = Constants.API.regsterOTP
        let parameters = ["email": email, "otp_code": otpCode]
        
        apiService.request(endpoint: endpoint, method: "POST", parameters: parameters) { (result: Result<VerifyOTPResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.message == "success" {
                        completion(.success("OTP verified successfully"))
                    } else {
                        completion(.failure(NSError(domain: "", code: response.status, userInfo: [NSLocalizedDescriptionKey: response.message])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchUserInfo(completion: @escaping (Result<User, Error>) -> Void) {
            guard let accessToken = AuthManager.shared.accessToken else {
                completion(.failure(LoginError.tokenNotFound))
                return
            }
            
            let endpoint = Constants.API.userInfoEndpoint
            let headers = ["Authorization": "Bearer \(accessToken)"]
            
            apiService.request(endpoint: endpoint, method: "POST", headers: headers) { (result: Result<UserResponse, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let userResponse):
                        completion(.success(userResponse.data.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
}
