//
//  RMCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//
import UIKit

protocol RMCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [RMCoordinatorProtocol] { get set }

    func start()
}

protocol RMDetailsCoordinator: RMCoordinatorProtocol {
    func showCharacterDetails(for character: RMCharacterProtocol)
    func showEpisodeDetails(for episode: RMEpisodeProtocol)
    func showLocationDetails(for location: RMLocationProtocol)
}

protocol RMSearchCoordinator: RMDetailsCoordinator {
    func showSearchScene()
}
