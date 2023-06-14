import Foundation
import CryptoKit

protocol CryptoServiceProtocol: AnyObject {
    func createHash(_ timestamp: String, publicKey: String, privateKey: String) -> String
}

final class CryptoService: CryptoServiceProtocol {
    
    func createHash(_ timestamp: String, publicKey: String, privateKey: String) -> String {
        let hash = formatedMD5(string: timestamp + privateKey + publicKey)
        
        return hash
    }
    
    private func formatedMD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))
        
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}

