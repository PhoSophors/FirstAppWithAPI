
import Foundation

struct VerifyOTPResponse: Codable {
    let message: String
    let status: Int
    let data: VerifyOTPData
    
    struct VerifyOTPData: Codable {
        let message: String
    }
}
