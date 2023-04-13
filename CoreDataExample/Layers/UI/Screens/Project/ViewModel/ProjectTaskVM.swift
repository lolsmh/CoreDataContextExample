//
//  ProjectTaskVM.swift
//  CoreDataExample
//
//  Created by Daniil on 13/4/23.
//

import Foundation

struct ProjectTaskVM: Hashable, Equatable, Identifiable {
	let title: String
	let description: String?
	let id: String
	
	init(task: ProjectTaskCoreDataEntity) {
		title = task.name
		description = task.taskDescription
		id = task.taskId
	}
}
