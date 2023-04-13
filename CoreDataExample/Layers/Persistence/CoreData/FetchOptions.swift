//
//  FetchOptions.swift
//  CoreDataExample
//
//  Created by Daniil on 12/4/23.
//

import Foundation
import CoreData

public enum FetchOptions {
	case all
	case filtered(predicate: NSPredicate)
	case sorted(sortDescriptors: [NSSortDescriptor])
	case filteredAndSorted(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor])
}
