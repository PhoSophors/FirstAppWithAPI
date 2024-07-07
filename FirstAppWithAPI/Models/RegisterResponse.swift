import Foundation

struct RegisterResponse: Codable {
    let message: String
    let status: Int
    let data: RegisterData?
    
    struct RegisterData: Codable {
        let password: [String]?
        
        enum CodingKeys: String, CodingKey {
            case password
        }
    }
}
