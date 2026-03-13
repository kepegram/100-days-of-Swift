//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Kadin Pegram on 3/13/26.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        let Formatter = DateFormatter()
        Formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(Formatter)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(_, _) {
            fatalError("Failed to decode \(file) due to missing key.")
        } catch DecodingError.typeMismatch(_, _) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch")
        } catch DecodingError.valueNotFound(let type, _) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundler")
        }
    }
}
