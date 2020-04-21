//
//  UIImageExtention.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/4/20
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    func changeColor(_ color: UIColor) -> UIImage?
    {
        let size = self.size
        
        UIGraphicsBeginImageContextWithOptions(size, true, self.scale)
        UIColor.white.setFill()
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsGetCurrentContext()?.fill(rect)
        self.draw(in: rect)
        let compositedMaskImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        var unscaledSize = size
        unscaledSize.width *= self.scale;
        unscaledSize.height *= self.scale;
        
        UIGraphicsBeginImageContext(unscaledSize)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        
        let unscaledRect = CGRect(x: 0, y: 0, width: unscaledSize.width, height: unscaledSize.height)
        context?.fill(unscaledRect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let compositedMaskImageRef = compositedMaskImage?.cgImage
        let mask = CGImage(
            maskWidth: Int(unscaledSize.width),
            height: Int(unscaledSize.height),
            bitsPerComponent: (compositedMaskImageRef?.bitsPerComponent)!,
            bitsPerPixel: (compositedMaskImageRef?.bitsPerPixel)!,
            bytesPerRow: (compositedMaskImageRef?.bytesPerRow)!,
            provider: (compositedMaskImageRef?.dataProvider!)!,
            decode: nil,
            shouldInterpolate: false
        );
        
        let masked = colorImage?.cgImage?.masking(mask!)
        return UIImage(cgImage:masked!, scale:(compositedMaskImage?.scale)!, orientation:UIImage.Orientation.up)
    }
    
}
