//
//  StorageManager.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/6.
//

import Foundation

final class StorageManager {
    
    static let shared: StorageManager = StorageManager()
    
    /// Storage Key
    enum StorageKeys: String {
        // Object Array: Activities
        case articles
        
    }
    
    private init() {
        
    }
    
    /// Load value from UserDefault
    ///
    /// - Parameter key: UserDefault key
    /// - Returns: return UserDefault value
    func load<T>(for key: StorageKeys) -> T? {
        
        let value: T? = UserDefaults.standard.value(forKey: key.rawValue) as? T
        
        debugPrint("\(#function) \(String(describing: value))")
        return value
    }
    
    /// Load codable object from UserDefault
    ///
    /// - Parameter key: UserDefault key
    /// - Returns: return UserDefault value
    func loadObject<T: Codable>(for key: StorageKeys) -> T? {
        
        guard let data = UserDefaults.standard.value(forKey: key.rawValue) as? Data else {
            return nil
        }
        
        guard let object: T = data.toObject() else {
            return nil
        }
        
        return object
    }
    
    /// Load codable object array from UserDefault
    ///
    /// - Parameter key: UserDefault key
    /// - Returns: return UserDefault value
    func loadObjectArray<T: Codable>(for key: StorageKeys) -> [T]? {
        
        guard let data = UserDefaults.standard.value(forKey: key.rawValue) as? [Data] else {
            return nil
        }
        
        let objectArray = data.map { (data) -> T? in
            
            guard let object: T = data.toObject() else {
                return nil
            }
            
            return object
        }.compactMap { $0 }
        
        debugPrint("\(#function) \(objectArray)")
        return objectArray
    }
    
    /// Save value in UserDefault
    ///
    /// - Parameters:
    ///   - key: UserDefault key
    ///   - value: UserDefault value
    func save(for key: StorageKeys, value: Any?) {
        
        debugPrint("\(#function) \(value ?? "")")
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    /// Save codable object in UserDefault
    ///
    /// - Parameters:
    ///   - key: UserDefault key
    ///   - value: UserDefault value
    func saveObject(for key: StorageKeys, value: Codable?) {
        
        if let value = value,
           let data = value.toJSONData() {
            
            debugPrint("\(#function) \(value)")
            UserDefaults.standard.set(data, forKey: key.rawValue)
        }
    }
    
    /// Save codable object array in UserDefault
    ///
    /// - Parameters:
    ///   - key: UserDefault key
    ///   - value: UserDefault value
    func saveObjectArray(for key: StorageKeys, value: [Codable]?) {
        
        if let value = value {
            
            let dataArray: [Data] = value.map { object -> Data? in
                return object.toJSONData()
            }.compactMap { $0 }
            
            debugPrint("\(#function) \(value)")
            UserDefaults.standard.set(dataArray, forKey: key.rawValue)
        }
    }
    
    /// Delete single key-value pair
    ///
    /// - Parameter key: UserDefault key
    func remove(for key: StorageKeys) {
        
        debugPrint("\(#function) \(key)")
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    /// Delete key-value pairs which key contain certain text
    ///
    /// - Parameter key: UserDefault key
    func removeAll(containsKey: String) {
        
        let dictionary: [String: Any] = UserDefaults.standard.dictionaryRepresentation()
        
        for (key, _) in dictionary where key.contains(containsKey) {
            
            debugPrint("\(#function) \(containsKey)")
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    /// Delete all key-value pairs
    func removeAll() {
        
        let dictionary: [String: Any] = UserDefaults.standard.dictionaryRepresentation()
        
        for (key, _) in dictionary {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        guard let id: String = Bundle.main.bundleIdentifier else {
            return
        }
        
        debugPrint("\(#function)")
        UserDefaults.standard.removePersistentDomain(forName: id)
    }
}

extension Encodable {
    
    func toJSONData() -> Data? {
        
        do {
            let data = try JSONEncoder().encode(self)
            return data
            
        } catch {
            debugPrint("Save \(self) failed")
        }
        return nil
    }
}

extension Data {
    
    func toObject<Ｔ: Decodable>() -> Ｔ? {
        do {
            let object = try JSONDecoder().decode(Ｔ.self, from: self)
            debugPrint("\(#function) \(object)")
            
            return object
        } catch {
            
            debugPrint("Decode \(self) failed")
            return nil
        }
    }
    
    /// HEX format string for token data, e.g. Push Token
    var tokenString: String {
        return map( { String(format: "%02x", $0) }).joined()
    }
}
