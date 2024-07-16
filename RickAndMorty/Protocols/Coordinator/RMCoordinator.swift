//
//  RMCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//
import UIKit

protocol RMCoordinator: AnyObject {
    var parentCoordinator: RMCoordinator? { get set }
    var childCoordinators: [RMCoordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
