//
//  ProjectTaskCoreDataEntity.swift
//  
//
//  Created by Daniil on 12/4/23.
//
//

import Foundation
import CoreData

@objc(ProjectTaskCoreDataEntity)
public class ProjectTaskCoreDataEntity: NSManagedObject, CoreDataManaged {
	
	// MARK: - Internal Properties
	
	@NSManaged var projectId: String
	@NSManaged var name: String
	@NSManaged var taskDescription: String?
	@NSManaged var taskId: String
	
	static var primaryKeyName: String {
		#keyPath(ProjectTaskCoreDataEntity.taskId)
	}
	
	var identity: String {
		taskId
	}
	
	// MARK: - Internal Methods
	
	@nonobjc class func fetchRequest() -> NSFetchRequest<ProjectCoreDataEntity> {
		return NSFetchRequest<ProjectCoreDataEntity>(entityName: "ProjectTaskCoreDataEntity")
	}
	
	@discardableResult
	static func insertNewEntity(
		id: String = UUID().uuidString,
		projectId: String,
		name: String,
		taskDescription: String?,
		in writingContext: NSManagedObjectContext
	) -> ProjectTaskCoreDataEntity {
		
		let entity = ProjectTaskCoreDataEntity(context: writingContext)
		
		entity.taskId = id
		entity.projectId = projectId
		entity.name = name
		entity.taskDescription = taskDescription
		
		return entity
	}
}
