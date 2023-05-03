//
//  TasksService.swift
//  CoreDataExample
//
//  Created by Daniil on 13/4/23.
//

import Foundation
import Combine

protocol TasksService {
	
	func fetchTasks(projectId: String) -> [ProjectTaskCoreDataEntity]
	func createNewTask(projectId: String, name: String) -> AnyPublisher<Void, Never>
	func changeTaskName(taskId: String, name: String) -> AnyPublisher<Void, Never>
	func changeTaskDescription(taskId: String, description: String?) -> AnyPublisher<Void, Never>
	func deleteTask(taskId: String) -> AnyPublisher<Void, Never>
}

final class TasksServiceImpl: TasksService {
	
	private let tasksStorage = CoreDataStorageProvider<ProjectTaskCoreDataEntity>()
	
	func createNewTask(projectId: String, name: String) -> AnyPublisher<Void, Never> {
		
		tasksStorage.enqueueBackgroundWritingTaskPublisher { writingContext in
			ProjectTaskCoreDataEntity.insertNewEntity(
				projectId: projectId,
				name: name,
				taskDescription: nil,
				in: writingContext
			)
		}
	}
	
	func changeTaskName(
		taskId: String,
		name: String
	) -> AnyPublisher<Void, Never> {
		
		tasksStorage.enqueueBackgroundWritingTaskPublisher { [weak self] writingContext in
			let entity = self?.tasksStorage.entity(taskId, in: writingContext)
			entity?.name = name
		}
	}
	
	func changeTaskDescription(
		taskId: String,
		description: String?
	) -> AnyPublisher<Void, Never> {
		
		tasksStorage.enqueueBackgroundWritingTaskPublisher { [weak self] writingContext in
			let entity = self?.tasksStorage.entity(taskId, in: writingContext)
			entity?.taskDescription = description
		}
	}
	
	func fetchTasks(projectId: String) -> [ProjectTaskCoreDataEntity] {
		let projectPredicate = NSPredicate(
			format: "%K BEGINSWITH[cd] %@",
			#keyPath(ProjectTaskCoreDataEntity.projectId),
			projectId
		)
		
		return tasksStorage.entities(.filtered(predicate: projectPredicate))
	}
	
	func deleteTask(taskId: String) -> AnyPublisher<Void, Never> {
		
		tasksStorage.enqueueBackgroundWritingTaskPublisher { [weak self] writingContext in
			guard let self, let task = self.tasksStorage.entity(taskId, in: writingContext) else { return }
			
			self.tasksStorage.delete(entity: task, in: writingContext)
		}
	}
}
