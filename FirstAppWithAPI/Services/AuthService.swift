//import Foundation
//
//class AuthService {
//    static let shared = AuthService()
//    
//    private init() {}
//
//    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
//        guard let url = URL(string: Constants.API.baseURL + Constants.API.loginEndpoint) else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let parameters = ["email": email, "password": password]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(LoginResponse.self, from: data)
//                completion(.success(response))
//            } catch {
//                print("Decoding error: \(error)")
//                print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
//                completion(.failure(error))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func register(full_name: String, email: String, password: String, password_confirmation: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
//        guard let url = URL(string: Constants.API.baseURL + Constants.API.registerEndpoint) else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let parameters = ["full_name": full_name, "email": email, "password": password, "password_confirmation": password_confirmation]
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//        } catch {
//            completion(.failure(error))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(RegisterResponse.self, from: data)
//                completion(.success(response))
//            } catch {
//                print("Decoding error: \(error)")
//                print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
//                completion(.failure(error))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func verifyOTP(email: String, otpCode: String, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let url = URL(string: Constants.API.baseURL + Constants.API.regsterOTP) else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let parameters = ["email": email, "otp_code": otpCode]
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//        } catch {
//            completion(.failure(error))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(VerifyOTPResponse.self, from: data)
//                if response.message == "success" {
//                    completion(.success(response.data.message))
//                } else {
//                    completion(.failure(NSError(domain: "", code: response.status, userInfo: [NSLocalizedDescriptionKey: response.data.message])))
//                }
//            } catch {
//                print("Decoding error: \(error)")
//                print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
//                completion(.failure(error))
//            }
//        }
//        
//        task.resume()
//    }
//
//
//}
//
//


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
}
