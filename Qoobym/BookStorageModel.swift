//
//  BookStorageModel.swift
//  Qoobym
//
//  Created by Anatoliy Petrov on 11. 5. 2025..
//

import Foundation
import CoreData

@objc(BookStorageModel)
public class BookStorageModel: NSManagedObject {
    // Core class - можно добавить логику здесь при необходимости
}

extension BookStorageModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookStorageModel> {
        return NSFetchRequest<BookStorageModel>(entityName: "BookStorageModel")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var quote: String?
    @NSManaged public var cover: Data?
}
