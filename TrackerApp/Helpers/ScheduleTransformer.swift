//
//  ScheduleTransformer.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 21.06.2025.
//

import Foundation

@objc(ScheduleTransformer)
final class ScheduleTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool { true }
    
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let set = value as? Set<WeekDay> else { return nil }
        let rawValues = set.map { $0.rawValue }
        
        do {
            return try NSKeyedArchiver.archivedData(
                withRootObject: rawValues,
                requiringSecureCoding: true
            )
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let rawValues = try NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [NSArray.self, NSString.self],
                from: data
            ) as? [String]
            
            return Set(rawValues?.compactMap { WeekDay(rawValue: $0) } ?? [])
        } catch {
            return nil
        }
    }
}
