//
//  NSManagedObjectContext+saveOrRollback.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
	@discardableResult
	public func saveOrRollback() -> Bool {
		do {
			try save()
			return true
		} catch {
			print("CoreData saving error: \(error)")
			rollback()
			return false
		}
	}
	
	func performChanges(block: @escaping () -> Void) {
		performAndWait {
			block()
		}
	}
}
