//
//  CoreDataStorageProvider.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import Foundation
import CoreData
import Combine

final class CoreDataStorageProvider<T> where T: NSManagedObject & CoreDataManaged {}

extension CoreDataStorageProvider: ReadableStore {
	public typealias Storable = T
	
	public func entities(
		_ fetchOptions: FetchOptions,
		in context: NSManagedObjectContext
	) -> [T] {
		
		let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
		
		switch fetchOptions {
		case let .filtered(predicate):
			fetchRequest.predicate = predicate
		case let .sorted(sortDescriptors):
			fetchRequest.sortDescriptors = sortDescriptors
		case let .filteredAndSorted(predicate, sortDescriptors):
			fetchRequest.predicate = predicate
			fetchRequest.sortDescriptors = sortDescriptors
		case .all:
			fetchRequest.sortDescriptors = []
		}
		
		fetchRequest.returnsObjectsAsFaults = false
		fetchRequest.includesPropertyValues = true
		
		return (try? context.fetch(fetchRequest)) ?? []
	}
	
	public func entity(
		_ primaryKey: String,
		in context: NSManagedObjectContext
	) -> T? {
		let predicate = T.primaryKeyPredicate(for: primaryKey)
		return T.findOrFetch(in: context, matching: predicate)
	}
	
	
	public func entity(_ primaryKey: String) -> T? {
		entity(primaryKey, in: CoreDataContextProvider.provider.readContext)
	}
	
	public func entities(_ fetchOptions: FetchOptions) -> [T] {
		entities(fetchOptions, in: CoreDataContextProvider.provider.readContext)
	}
}

extension CoreDataStorageProvider: WritableStore {
	public func delete(entity: T, in context: NSManagedObjectContext) {
		context.performChanges {
			context.delete(entity)
		}
	}
	
	public func delete(entities: [T], in context: NSManagedObjectContext) {
		context.performChanges {
			for entity in entities {
				context.delete(entity)
			}
		}
	}
	
	public func delete(entity: T) {
		delete(entity: entity, in: CoreDataContextProvider.provider.readContext)
	}
	
	public func delete(entities: [T]) {
		delete(entities: entities, in: CoreDataContextProvider.provider.readContext)
	}
	
	public func deleteAll(in writableContext: NSManagedObjectContext) {
		T.deleteAll(in: writableContext)
	}
	
	public func deleteAll() {
		T.deleteAll(in: CoreDataContextProvider.provider.readContext)
	}
	
	public func saveOrRollback() {
		CoreDataContextProvider.provider.readContext.saveOrRollback()
	}
	
	public func enqueueBackgroundWritingTaskPublisher(
		block: @escaping (_ writingContext: NSManagedObjectContext) -> Void
	) -> AnyPublisher<Void, Never> {
		CoreDataContextProvider
			.provider
			.enqueueBackgroundWriteBlockPublisher(block: block)
	}
}
