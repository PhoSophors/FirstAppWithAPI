import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func request<T: Decodable>(endpoint: String, method: String = "GET", headers: [String: String]? = nil, parameters: [String: Any] = [:], completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: Constants.API.baseURL + endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if method == "POST" || method == "PUT" {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                print("Decoding error: \(error)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                completion(.failure(error))
            }
        }.resume()
    }
}
