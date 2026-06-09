import Foundation

enum APIKey{
    static var `default`: String{
        let value = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
        return value
    }
}
