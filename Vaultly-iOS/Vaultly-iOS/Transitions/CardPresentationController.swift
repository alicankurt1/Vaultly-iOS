//
//  CardPresentationController.swift
//  Vaultly-iOS
//
//  Created by Alicank on 16.09.2026.
//

import UIKit

// Sunulan ekranı alt yarıda yuvarlak köşeli bir kart gibi konumlandırır,
// arkasındaki ekranı karartır — standart .pageSheet/.formSheet yerine tamamen özel yerleşim
final class CardPresentationController: UIPresentationController {

    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0
        return view
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else { return .zero }
        let height = containerView.bounds.height * 0.45
        return CGRect(
            x: 0,
            y: containerView.bounds.height - height,
            width: containerView.bounds.width,
            height: height
        )
    }

    override func presentationTransitionWillBegin() {
        guard let containerView else { return }
        dimmingView.frame = containerView.bounds
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.insertSubview(dimmingView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 1
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 0
        })
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 20
        presentedView?.layer.cornerCurve = .continuous
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedView?.clipsToBounds = true
    }
}
