import Foundation

struct UserResponse: Codable {
    let message: String
    let status: Int
    let data: UserData
}

struct UserData: Codable {
    let user: User
}

struct User: Codable {
    let id: String
    let full_name: String
    let email: String
    let username: String
    let profile_image_path: String?
    let created_at: String
    let updated_at: String
    let is_email_verified: Bool
    let status: String
}
