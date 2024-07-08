import Foundation

struct LoginResponse: Codable {
    let message: String
    let status: Int
    let data: LoginData?

    struct LoginData: Codable {
        let jwt: JWTData?

        struct JWTData: Codable {
            let access_token: String
            let token_type: String
            let expires_in: Int
        }
    }

    // Handle error data when there's a validation error
    struct ErrorData: Codable {
        let message: String
    }

    var errorData: ErrorData? {
        return data.flatMap { data in
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
                return nil
            }
            return try? JSONDecoder().decode(ErrorData.self, from: jsonData)
        }
    }
}
