//
//  VelotoUtils.swift
//  Veloto
//
//  Created by Максим Газимзянов on 31.07.2022.
//

import Foundation

class VelotoUtils {
    
    // On server side we store the amount of km to pass to trigger card activation.
    // Thus need to display the difference between total ("every") and "remain"
    static func taskRequiresMaintenance(_ task: AthleteTask) -> Bool {
        return calculateRemainKmForTask(task) <= 0
    }
    
    static func calculateRemainKmForTask(_ task: AthleteTask) -> Int64 {
        return (task.every - task.remain) / 1000
    }
    
}
