//
//  ProjectsService.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import Foundation
import Combine

protocol ProjectsService {
	
	func fetchProjects() -> [ProjectCoreDataEntity]
	func fetchProject(projectId: String) -> ProjectCoreDataEntity?
	func createNewProject(name: String) -> AnyPublisher<Void, Never>
	func deleteProject(projectId: String)
}

final class ProjectsServiceImpl: ProjectsService {
	
	private let projectsStorage = CoreDataStorageProvider<ProjectCoreDataEntity>()
	
	func createNewProject(name: String) -> AnyPublisher<Void, Never> {
		
		projectsStorage.enqueueBackgroundWritingTaskPublisher { writingContext in
			ProjectCoreDataEntity.insertNewEntity(
				name: name,
				in: writingContext
			)
		}
	}
	
	func fetchProjects() -> [ProjectCoreDataEntity] {
		projectsStorage.entities(.all)
	}
	
	func fetchProject(projectId: String) -> ProjectCoreDataEntity? {
		projectsStorage.entity(projectId)
	}
	
	func deleteProject(projectId: String) {
		guard let project = projectsStorage.entity(projectId) else { return }
		
		projectsStorage.delete(entity: project)
		projectsStorage.saveOrRollback()
	}
}
