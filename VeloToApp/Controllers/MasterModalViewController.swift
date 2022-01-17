//
//  MasterModalViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 17.01.2022.
//

import Foundation

protocol ModalViewControllerDelegate {
    func updateInModalViewController(_ sender: ModalViewController)
}

protocol ModalViewController {
    var masterDelegate: ModalViewControllerDelegate? { get set }
}
