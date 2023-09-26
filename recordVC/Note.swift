//
//  Note.swift
//  myTableApp6
//
//  Created by YuCheng on 2023/7/5.
//

import Foundation
import CoreData
import UIKit
import HealthKit

class Note: NSManagedObject {
    
    @NSManaged var text : String
    @NSManaged var noteID : String
    @NSManaged var worOut : HKWorkout
    @NSManaged var date : String
    
    override func awakeFromInsert() {
        noteID = UUID().uuidString
    }
    

}
