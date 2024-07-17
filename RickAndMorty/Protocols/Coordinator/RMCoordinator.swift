//
//  RMCoordinator.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 16/07/2024.
//
import UIKit

protocol RMCoordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [RMCoordinator] { get set }

    func start()
}

protocol RMDetailsCoordinator: RMCoordinator {
    func showCharacterDetails(for character: RMCharacterProtocol)
    func showEpisodeDetails(for episode: RMEpisodeProtocol)
    func showLocationDetails(for location: RMLocationProtocol)
}
