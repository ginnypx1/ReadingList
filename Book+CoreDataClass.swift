//
//  Book+CoreDataClass.swift
//  ReadingList
//
//  Created by Ginny Pennekamp on 4/20/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import CoreData


public class Book: NSManagedObject {
    
    convenience init(title: String = "New Book", context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Book", in: context) {
            self.init(entity: ent, insertInto: context)
            self.title = title
        } else {
            fatalError("Unable to find Book Entity!")
        }
    }

}
