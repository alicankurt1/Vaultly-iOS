//
//  TransferConfirmationTransitioningDelegate.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

// Present/dismiss animatörlerini ve kart sunum controller'ını tek yerden sağlar;
// UIViewController.transitioningDelegate weak olduğu için bunu tutan VC güçlü referans saklamalı
final class TransferConfirmationTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        CardPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        TransferPresentationAnimator()
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        TransferDismissalAnimator()
    }
}
