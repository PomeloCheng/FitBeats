//
//  HKWorkoutTransformer.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/10.
//

import Foundation
import HealthKit

@objc(HKWorkoutTransformer)
class HKWorkoutTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        return super.allowedTopLevelClasses + [HKWorkout.self]
    }
    
    override class func transformedValueClass() -> AnyClass {
        return HKWorkout.self
    }
}
