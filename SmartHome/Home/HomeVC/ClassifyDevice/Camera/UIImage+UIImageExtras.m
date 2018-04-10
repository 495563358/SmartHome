//
//  UIImage+UIImageExtras.m
//  ZNJD2
//
//  Created by yaoyaodu on 13-6-21.
//
//

#import "UIImage+UIImageExtras.h"
#define SAFECOLOR(color) MIN(255,MAX(0,color))
@implementation UIImage (UIImageExtras)
- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

- (UIImage*)balhedu:(double)context
{
	CGImageRef inImage = self.CGImage;
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
	
	int length = CFDataGetLength(m_DataRef);
	
	for (int i=0; i < length; i+=4)
	{
		double t = context;
        
        int r = i;
        int g = i+1;
        int b = i+2;
        
        int red = m_PixelBuf[r];
        int green = m_PixelBuf[g];
        int blue = m_PixelBuf[b];
        
        int avg = ( red + green + blue ) / 3;
        
        m_PixelBuf[r] = SAFECOLOR((avg + t * (red - avg)));
        m_PixelBuf[g] = SAFECOLOR((avg + t * (green - avg)));
        m_PixelBuf[b] = SAFECOLOR((avg + t * (blue - avg)));
        
	}
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
											 CGImageGetWidth(inImage),
											 CGImageGetHeight(inImage),
											 CGImageGetBitsPerComponent(inImage),
											 CGImageGetBytesPerRow(inImage),
											 CGImageGetColorSpace(inImage),
											 CGImageGetBitmapInfo(inImage)
											 );
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
	return finalImage;
	
}
@end
