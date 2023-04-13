//
//  CoreDataContextProvider.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import Foundation
import CoreData
import Combine

class CoreDataContextProvider {
	
	// MARK: - Singletone
	
	static let provider = CoreDataContextProvider()
	
	// MARK: - Internal properties
	
	lazy var readContext: NSManagedObjectContext = {
		let viewContext = persistentContainer.viewContext
		viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
		return viewContext
	}()
	
	func enqueueBackgroundWriteBlock(
		block: @escaping (_ writeContext: NSManagedObjectContext) -> Void,
		receiveCompletionOn queue: DispatchQueue = .main,
		completion: (() -> Void)? = nil
	) {
		operationQueue.addOperation() { [weak self] in
			let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
			context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
			context.persistentStoreCoordinator = self?.persistentContainer.persistentStoreCoordinator
			self?.observeChanges(in: context, completion: completion)
			
			context.performAndWait {
				block(context)
				context.saveOrRollback()
			}
		}
	}
	
	func enqueueBackgroundWriteBlockPublisher(
		block: @escaping (_ writeContext: NSManagedObjectContext) -> Void
	) -> AnyPublisher<Void, Never> {
		Future<Void, Never> { [weak self] promise in
			self?.enqueueBackgroundWriteBlock(block: block) {
				promise(.success(()))
			}
		}
		.eraseToAnyPublisher()
	}
	
	// MARK: - Private properties
	
	private let operationQueue: OperationQueue = {
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		return queue
	}()
	
	private lazy var persistentContainer: NSPersistentContainer = {
		let managedObjectModelURL = Bundle.main.url(forResource: "CoreDataExample", withExtension: "momd")!
		let managedObjectModel = NSManagedObjectModel(contentsOf: managedObjectModelURL)!
		let container = NSPersistentContainer(name: "CoreDataExample", managedObjectModel: managedObjectModel)
		
		container.loadPersistentStores { _, error in
			if let error = error {
				print(error)
				fatalError("CoreData loadPersistentStored ended with error: \(error.localizedDescription)")
			}
		}
				
		return container
	}()
	
	private func observeChanges(
		in context: NSManagedObjectContext,
		receiveCompletionOn queue: DispatchQueue = .main,
		completion: (() -> Void)? = nil
	) {
		NotificationCenter
			.default
			.addObserver(
				forName: .NSManagedObjectContextDidSave,
				object: context,
				queue: nil
			) { [weak self] notification in
				self?.readContext.perform {
					self?.readContext.mergeChanges(fromContextDidSave: notification)
					queue.async {
						completion?()
					}
				}
			}
	}
}
