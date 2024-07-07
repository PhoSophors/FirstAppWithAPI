import Foundation

struct LoginResponse: Codable {
    let data: LoginData
    var status: Int
    
    struct LoginData: Codable {
        let jwt: JWTData?
        
        struct JWTData: Codable {
            let access_token: String
            let token_type: String
            let expires_in: Int
        }
    }
}
