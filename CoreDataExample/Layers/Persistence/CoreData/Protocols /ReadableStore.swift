//
//  ReadableStore.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import CoreData

public protocol ReadableStore {
	
	associatedtype Storable: NSManagedObject
	
	func entities(
		_ fetchOptions: FetchOptions,
		in context: NSManagedObjectContext
	) -> [Storable]
	
	func entity(
		_ primaryKey: String,
		in context: NSManagedObjectContext
	) -> Storable?

	func entities(
		_ fetchOptions: FetchOptions
	) -> [Storable]
	
	func entity(
		_ primaryKey: String
	) -> Storable?
}
