//
//  WritableStore.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import CoreData

public protocol WritableStore {
	associatedtype Writable: NSManagedObject
	
	func delete(entity: Writable)
	func delete(entities: [Writable])
	func deleteAll()
	func deleteAll(in writableContext: NSManagedObjectContext)
	func delete(
		entity: Writable,
		in writableContext: NSManagedObjectContext
	)
	
	func delete(
		entities: [Writable],
		in writableContext: NSManagedObjectContext
	)
}
