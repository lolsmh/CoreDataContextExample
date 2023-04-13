//
//  HasRootView.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import UIKit

// MARK: - Interface

public protocol HasRootView {
	associatedtype RootView
	
	var rootView: RootView { get }
}

// MARK: - Default implementation

public extension HasRootView where Self: UIViewController {
	var rootView: RootView {
		guard let rootView = view as? RootView else {
			fatalError(
				"""
				Unable to cast '\(String(describing: view))' to the type '\(RootView.self)', \
				check 'loadView()' method implementation.
				"""
			)
		}
		
		return rootView
	}
}

