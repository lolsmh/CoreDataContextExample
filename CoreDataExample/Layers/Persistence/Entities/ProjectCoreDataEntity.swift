//
//  ProjectCoreDataEntity.swift
//  
//
//  Created by Daniil on 12/4/23.
//
//

import Foundation
import CoreData

@objc(ProjectCoreDataEntity)
public class ProjectCoreDataEntity: NSManagedObject, CoreDataManaged {
	
	// MARK: - Internal Properties
	
	static var primaryKeyName: String {
		#keyPath(ProjectCoreDataEntity.projectId)
	}
	
	var identity: String {
		projectId
	}
	
	@NSManaged var name: String
	@NSManaged var projectId: String
	
	// MARK: - Internal Methods
	
	@nonobjc
	class func fetchRequest() -> NSFetchRequest<ProjectTaskCoreDataEntity> {
		return NSFetchRequest<ProjectTaskCoreDataEntity>(entityName: "ProjectCoreDataEntity")
	}
	
	@discardableResult
	static func insertNewEntity(
		id: String = UUID().uuidString,
		name: String,
		in writingContext: NSManagedObjectContext
	) -> ProjectCoreDataEntity {
		
		let entity = ProjectCoreDataEntity(context: writingContext)
		
		entity.name = name
		entity.projectId = id
		
		return entity
	}
}
