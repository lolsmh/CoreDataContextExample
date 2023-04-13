//
//  NSManagedObjectContext.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import CoreData

extension NSManagedObjectContext {
	func insertObject<T: NSManagedObject & CoreDataManaged>() -> T {
		guard let newObj = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T else {
			// TODO: Alexander Kiyaykin - throw error here instead of fatalError
			fatalError()
		}
		
		return newObj
	}
}
