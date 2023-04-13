//
//  CoreDataManaged.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import CoreData

protocol CoreDataManaged: AnyObject, NSFetchRequestResult {
	static var entityName: String { get }
	static var primaryKeyName: String { get }
	
	var identity: String { get }
	var primaryKeyPredicate: NSPredicate { get }
	
	static func primaryKeyPredicate(for identity: String) -> NSPredicate
}

extension CoreDataManaged {
	var primaryKeyPredicate: NSPredicate {
		return Self.primaryKeyPredicate(for: self.identity)
	}
	
	static func primaryKeyPredicate(for identity: String) -> NSPredicate {
		return NSPredicate(format: "%K =[c] %@", Self.primaryKeyName, identity)
	}
}

extension CoreDataManaged where Self: NSManagedObject {
	static var entityName: String {
		return String(describing: self)
	}
}

extension CoreDataManaged where Self: NSManagedObject {
	//swiftlint:disable force_try
	static func fetch(
		in context: NSManagedObjectContext,
		configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }
	) -> [Self] {
		
		let request = NSFetchRequest<Self>(entityName: Self.entityName)
		request.includesPropertyValues = true
		configurationBlock(request)
		
		return (try? context.fetch(request)) ?? []
	}
	
	static func create(
		in context: NSManagedObjectContext,
		configure: (Self) -> Void
	) -> Self {
		let newObject: Self = context.insertObject()
		configure(newObject)
		return newObject
	}

	static func findOrFetch(
		in context: NSManagedObjectContext,
		matching predicate: NSPredicate
	) -> Self? {
		return fetch(in: context) { request in
			request.predicate = predicate
			request.returnsObjectsAsFaults = false
			request.fetchLimit = 1
		}.first
	}
	

	static func deleteAll(in context: NSManagedObjectContext) {
		guard let fetchRequest = NSFetchRequest<Self>(entityName: Self.entityName) as? NSFetchRequest<NSFetchRequestResult> else {
			return
		}
		
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		
		do {
			_ = try context.execute(deleteRequest)
		} catch {
			print("Core Data deleteAll error: \(error)")
		}
	}
}
