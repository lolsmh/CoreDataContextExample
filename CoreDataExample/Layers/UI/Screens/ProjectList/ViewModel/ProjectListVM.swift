//
//  ProjectListVM.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import Foundation
import Combine
import UIKit

typealias ProjectListSnapshot = NSDiffableDataSourceSnapshot<ProjectListSection, ProjectListItemVM>

protocol ProjectListVM {
	var snapshotPublisher: AnyPublisher<ProjectListSnapshot, Never> { get }
	
	func createNewProject(name: String)
	func deleteProject(projectId: String)
}

final class ProjectListVMImpl: ProjectListVM {
	
	// MARK: - Internal Properties
	
	var snapshotPublisher: AnyPublisher<ProjectListSnapshot, Never> {
		snapshotSubject.eraseToAnyPublisher()
	}
	
	// MARK: - Private Properties
	
	private let projectsService: ProjectsService
	private let snapshotSubject = CurrentValueSubject<ProjectListSnapshot, Never>(.init())
	private var subscriptions = [AnyCancellable]()
	
	// MARK: - Initialization
	
	init(projectsService: ProjectsService) {
		self.projectsService = projectsService
		
		updateData()
	}
	
	func createNewProject(name: String) {
		projectsService.createNewProject(name: name)
			.sink { [weak self] in
				self?.updateData()
			}
			.store(in: &subscriptions)
	}
	
	func deleteProject(projectId: String) {
		projectsService.deleteProject(projectId: projectId)
			.sink { [weak self] in
				self?.updateData()
			}
			.store(in: &subscriptions)
	}
	
	private func updateData() {
		var snapshot = ProjectListSnapshot()
		let projects = projectsService.fetchProjects()
		let items = projects.map(ProjectListItemVM.init)
		
		snapshot.appendSections([.projects])
		snapshot.appendItems(items, toSection: .projects)
		
		snapshotSubject.send(snapshot)
	}
}
