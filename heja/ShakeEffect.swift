//
//  ShakeEffect.swift
//  hiajaa_challenge 3
//
//  Created by najd aljarba on 16/06/1447 AH.
//


import SwiftUI

struct HorizontalShakeEffect: GeometryEffect {
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = 10 * sin(animatableData * .pi * 2)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

