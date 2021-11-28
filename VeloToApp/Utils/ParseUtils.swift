//
//  ParseUtils.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 24.11.2021.
//

import Foundation

class ParseUtils {
    
    public static func toInt(_ string: String?) -> Int? {
        return Int(string ?? "0")
    }
    
    public static func toInt(_ string: String?) -> Int {
        return toInt(string) ?? 0
    }
    
    public static func toInt64(_ string: String?) -> Int64 {
        return Int64(toInt(string))
    }
    
}
