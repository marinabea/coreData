//
//  User.swift
//  coreDataTutorial
//
//  Created by Marina Beatriz Santana de Aguiar on 13.10.20.
//

import UIKit
import CoreData

@objc(User)
class User: NSManagedObject {
    @NSManaged var name: String
}
