
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import "FaceDetection.h"

#define NUMBER_OF_FACE_POINTS 3


@implementation Face
@end


@interface FaceDetection ()

@property(nonatomic, strong) UIImage *originalImage;

@end


@implementation FaceDetection

#pragma mark - Singleton
+ (instancetype)sharedInstance
{
    static FaceDetection *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


#pragma mark - Face Detector
- (NSMutableArray*)faceDetector:(UIImage*)originalImage
{
    // Execute the method used to markFaces in background
    //    [self performSelectorInBackground:@selector(markFaces:) withObject:self.image];
    
    self.originalImage = originalImage;
    
    NSArray *faces = [self detectFacesOnImage:originalImage];
    [self markFaces:faces fromImage:originalImage];
    
    NSMutableArray *facesToSwap = [NSMutableArray arrayWithArray:faces];
    return facesToSwap;
}

- (NSArray *)detectFacesOnImage:(UIImage *)image
{
  // draw a CI image with the previously loaded face detection picture
  CIImage* ciImage = [CIImage imageWithCGImage:image.CGImage];

  NSDictionary *opts = @{CIDetectorAccuracy : CIDetectorAccuracyHigh};

  // create a face detector - since speed is not an issue we'll use a high
  // accuracy detector
  CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                            context:nil
                                            options:opts];


  // create an array containing all the detected faces from the detector
  NSArray* features = [detector featuresInImage:ciImage];

  // Create basic coordinates system transform.
  CGAffineTransform coordinatesTransform = CGAffineTransformMakeScale(1, -1);
  coordinatesTransform = CGAffineTransformTranslate(coordinatesTransform,
                                                    0,
                                                    -image.size.height);

  NSArray* faces = @[];

  // we'll iterate through every detected face.  CIFaceFeature provides us
  // with the width for the entire face, and the coordinates of each eye
  // and the mouth if detected.  Also provided are BOOL's for the eye's and
  // mouth so we can check if they already exist.
  for(CIFaceFeature* faceFeature in features)
  {
    if (!faceFeature.hasLeftEyePosition
        || !faceFeature.hasRightEyePosition
        || !faceFeature.hasMouthPosition)
      continue;

    // Invert the face bounds to match the current coordinate space.
    CGRect invertedBounds = CGRectApplyAffineTransform(faceFeature.bounds,
                                                       coordinatesTransform);

    CGPoint facePoints[NUMBER_OF_FACE_POINTS] =
    {
      faceFeature.leftEyePosition,
      faceFeature.rightEyePosition,
      faceFeature.mouthPosition
    };

    // Transform the detected features to the correct coordinate space and
    // set them relative to the face bounds.
    for (NSUInteger n = 0; n < NUMBER_OF_FACE_POINTS; n++)
    {
      CGPoint facePoint = facePoints[n];
      facePoint = CGPointApplyAffineTransform(facePoint,
                                              coordinatesTransform);
      facePoint.x -= invertedBounds.origin.x;
      facePoint.y -= invertedBounds.origin.y;

      facePoints[n] = facePoint;
    }

    // Create and fill a |Face| object.
    Face *face = [[Face alloc] init];
    face.bounds = invertedBounds;
    face.leftEyePosition = facePoints[0];
    face.rightEyePosition = facePoints[1];
    face.mouthPosition = facePoints[2];

    CGFloat xDiff = face.leftEyePosition.x - face.rightEyePosition.x;
    CGFloat yDiff = face.leftEyePosition.y - face.rightEyePosition.y;
    face.rotationAngle = - atan(yDiff / xDiff);

    faces = [faces arrayByAddingObject:face];
  }

  return faces;
}

-(void)markFaces:(NSArray *)faces fromImage:(UIImage*)image
{
  // we'll iterate through every detected face.  CIFaceFeature provides us
  // with the width for the entire face, and the coordinates of each eye
  // and the mouth if detected.  Also provided are BOOL's for the eye's and
  // mouth so we can check if they already exist.
  for(Face* face in faces)
  {
    CGImageRef originalImage = image.CGImage;
    CGImageRef faceCGImageSrc = CGImageCreateWithImageInRect(originalImage,
                                                             face.bounds);
    CGImageRef faceCGImage = CGImageCreateCopy(faceCGImageSrc);
    UIImage *faceImage = [UIImage imageWithCGImage:faceCGImage];
    faceImage = [self fixOrientationOfImage:faceImage];
    faceImage = [self rotatedImage:faceImage withAngle:-face.rotationAngle];


    CGPoint faceCenter = CGPointMake(face.bounds.size.width / 2,
                                     face.bounds.size.height / 2);

    // FIXME: Not sure why the rotation angle is different to the image.
    CGAffineTransform transform = CGAffineTransformMakeTranslation(faceCenter.x,
                                                                   faceCenter.y);
    transform = CGAffineTransformRotate(transform, face.rotationAngle);
    transform = CGAffineTransformTranslate(transform,
                                           -faceImage.size.width / 2,
                                           -faceImage.size.height / 2);


    CGSize sizeDiff = CGSizeMake(faceImage.size.width - face.bounds.size.width,
                                 faceImage.size.height - face.bounds.size.height);

    CGPoint facePoints[] = {
      face.leftEyePosition,
      face.rightEyePosition,
      face.mouthPosition
    };

    // Convert face points to the current coordinate space.
    for (NSUInteger n = 0; n < NUMBER_OF_FACE_POINTS; n++)
    {
      CGPoint facePoint = facePoints[n];

      facePoint = CGPointApplyAffineTransform(facePoint, transform);
      facePoint.x += sizeDiff.width;
      facePoint.y += sizeDiff.height;

      facePoints[n] = facePoint;
    }

    CGSize faceSize = faceImage.size;

    // Create the path to obtain the face area.
    UIBezierPath *path = [self createFacePathForFaceWidth:faceSize.width
                                          leftEyePosition:facePoints[0]
                                         rightEyePosition:facePoints[1]
                                                    mouth:facePoints[2]];

    CGFloat shadowRadius = 6;
    face.image = [self faceImageForImage:faceImage.CGImage
                                withPath:path
                               andRadius:shadowRadius
                                  points:facePoints];
  }
}

- (UIImage *)faceImageForImage:(CGImageRef)image
                      withPath:(UIBezierPath *)path
                     andRadius:(CGFloat)shadowRadius
                        points:(CGPoint *)points
{
  CGSize imageSize = CGSizeMake(CGImageGetWidth(image) /*+ shadowRadius * 2*/,
                                CGImageGetHeight(image) /*+ shadowRadius * 2*/);
  UIImage *loadedImage = [UIImage imageWithCGImage:image];

  CGRect pathBounds = CGPathGetPathBoundingBox(path.CGPath);
  CGPoint pathOrigin = pathBounds.origin;

  UIGraphicsBeginImageContextWithOptions(pathBounds.size, NO, 1);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetInterpolationQuality(context, kCGInterpolationHigh);

  NSLog(@"Path bounding box: %@", NSStringFromCGRect(pathBounds));

  CGAffineTransform translate = CGAffineTransformMakeTranslation(-pathOrigin.x,
                                                                 -pathOrigin.y);
//  translate = CGAffineTransformTranslate(translate, shadowRadius*2, shadowRadius*2);

//  CGContextAddPath(context, path.CGPath);
//  CGContextClip(context);

//  translate = CGAffineTransformMakeTranslation(-shadowRadius*2, -shadowRadius*2);
//  translate = CGAffineTransformTranslate(translate,
//                                         pathOrigin.x,
//                                         pathOrigin.y);
//
  CGContextConcatCTM(context, translate);

  [path addClip];

  [loadedImage drawInRect:(CGRect){{0,0}, imageSize}];

//  CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
//
//  CGContextStrokeRect(context, CGRectMake(points[0].x - 5, points[0].y - 5, 10, 10));
//  CGContextStrokeRect(context, CGRectMake(points[1].x - 5, points[1].y - 5, 10, 10));
//  CGContextStrokeRect(context, CGRectMake(points[2].x - 5, points[2].y - 5, 10, 10));

  UIImage *faceImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return faceImage;
}

- (UIBezierPath *)createFacePathForFaceWidth:(CGFloat)faceWidth
                             leftEyePosition:(CGPoint)leftEyePosition
                            rightEyePosition:(CGPoint)rightEyePosition
                                       mouth:(CGPoint)mouthPosition
{
  CGFloat eyeRadius = faceWidth * 0.15;

  UIBezierPath *path = [UIBezierPath bezierPath];

  CGPoint initialPoint = CGPointMake(leftEyePosition.x,
                                     leftEyePosition.y + eyeRadius);
  CGPoint endPoint = CGPointMake(leftEyePosition.x,
                                 leftEyePosition.y - eyeRadius);
  CGPoint controlPoint = CGPointMake(leftEyePosition.x - (eyeRadius * 2),
                                     leftEyePosition.y);


//  [path moveToPoint:initialPoint];

//  [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
  [path addArcWithCenter:leftEyePosition radius:eyeRadius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];

  initialPoint = path.currentPoint;
  endPoint = CGPointMake(rightEyePosition.x, rightEyePosition.y - eyeRadius);
  controlPoint = CGPointMake(initialPoint.x + ((endPoint.x - initialPoint.x) / 2),
                             initialPoint.y + eyeRadius * 0.25);

  [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];

  initialPoint = [path currentPoint];
  endPoint = CGPointMake(rightEyePosition.x, rightEyePosition.y + eyeRadius);
  controlPoint = CGPointMake(rightEyePosition.x + eyeRadius * 2,
                             rightEyePosition.y);

//  [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
  [path addArcWithCenter:rightEyePosition radius:eyeRadius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(90) clockwise:YES];


  CGFloat mouthXRadius = faceWidth * 0.2;
  CGFloat mouthYRadius = mouthXRadius * 0.65;

  // Add the right side line from eye to mouth.
  initialPoint = CGPointMake(rightEyePosition.x, rightEyePosition.y + eyeRadius);
  endPoint = CGPointMake(rightEyePosition.x, mouthPosition.y - mouthYRadius * 0.45);

  CGFloat x1 = MAX(initialPoint.x, endPoint.x);
  CGFloat x2 = MIN(initialPoint.x, endPoint.x);


  controlPoint = CGPointMake(x2 + ((x1 - x2) / 2) - eyeRadius * 0.5,
                             initialPoint.y + ((endPoint.y - initialPoint.y) / 2));

  [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];

  initialPoint = path.currentPoint;
  endPoint = CGPointMake(mouthPosition.x - mouthXRadius, initialPoint.y);

  CGPoint offset = CGPointMake(mouthXRadius * 1.25, mouthYRadius * 1.25);
  CGPoint controlPoint1 = CGPointMake(mouthPosition.x + offset.x,
                                      mouthPosition.y + offset.y);
  CGPoint controlPoint2 = CGPointMake(mouthPosition.x - offset.x,
                                      mouthPosition.y + offset.y);

//  [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
  [path addCurveToPoint:endPoint
          controlPoint1:controlPoint1
          controlPoint2:controlPoint2];


  // Add the left side line from mouth to left eye.
  initialPoint = path.currentPoint;
  endPoint = CGPointMake(leftEyePosition.x, leftEyePosition.y + eyeRadius);

  x1 = MAX(initialPoint.x, endPoint.x);
  x2 = MIN(initialPoint.x, endPoint.x);


  controlPoint = CGPointMake(x2 - ((x1 - x2) / 2) + eyeRadius * 0.5,
                             initialPoint.y + ((endPoint.y - initialPoint.y) / 2));

  [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];

  return path;
}

- (UIImage *)transformImage:(UIImage *)image
                      angle:(CGFloat)angle
                     scaleX:(CGFloat)scaleX
                     scaleY:(CGFloat)scaleY
{
  CGPoint imageCenter = CGPointMake(image.size.width / 2,
                                    image.size.height / 2);

  CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
  transform = CGAffineTransformScale(transform, scaleX, scaleY);

  CGRect sourceRect = CGRectMake(0, 0, image.size.width, image.size.height);
  CGRect newFrame = CGRectApplyAffineTransform(sourceRect, transform);

  UIGraphicsBeginImageContext(newFrame.size);

  CGContextRef bitmap = UIGraphicsGetCurrentContext();

  CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);

  CGAffineTransform bitmapTransform = CGContextGetCTM(bitmap);
  bitmapTransform = CGAffineTransformTranslate(bitmapTransform,
                                               newFrame.size.width / 2,
                                               newFrame.size.height / 2);
  bitmapTransform = CGAffineTransformRotate(bitmapTransform, angle);
  bitmapTransform = CGAffineTransformScale(bitmapTransform, scaleX, scaleY);

  CGContextConcatCTM(bitmap, bitmapTransform);

  CGRect imageFrame = CGRectMake(-imageCenter.x,
                                 -imageCenter.y,
                                 image.size.width,
                                 image.size.height);

  CGContextDrawImage(bitmap, imageFrame, image.CGImage);

  UIImage *transformedImage = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  return transformedImage;
}

- (UIImage *)rotatedImage:(UIImage *)image withAngle:(CGFloat)angle
{
  UIImage *outputImage;

  if (angle == 0)
    outputImage = image;
  else
    outputImage = [self transformImage:image angle:angle scaleX:1 scaleY:1];

  return outputImage;
}

- (UIImage *)scaledImage:(UIImage *)sourceImage
                  scaleX:(CGFloat)scaleX
                  scaleY:(CGFloat)scaleY
{
  if (scaleX == 1 && scaleY == 1) {
    return sourceImage;
  }

  CGAffineTransform transform = CGAffineTransformMakeScale(scaleX, scaleY);

  CGSize transformSize = CGSizeApplyAffineTransform(sourceImage.size, transform);

  UIGraphicsBeginImageContextWithOptions(transformSize, NO, sourceImage.scale);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetInterpolationQuality(context, kCGInterpolationHigh);

  [sourceImage drawInRect:(CGRect){{0, 0}, transformSize}];

  UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return output;
}

- (UIImage *)fixOrientationOfImage:(UIImage *)image
{
  if (image.imageOrientation == UIImageOrientationUp) return image;

  UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
  [image drawInRect:(CGRect){0, 0, image.size}];
  UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return normalizedImage;
}

- (UIImage *)transformFace:(Face *)face1 intoFace:(Face *)face2
{
  CGSize imageSize = self.originalImage.size;

  // Create the scale transform.
//  CGFloat scaleX = self.image.bounds.size.width / imageSize.width;
//  CGFloat scaleY = self.image.bounds.size.height / imageSize.height;

  CGFloat scaleX = self.originalImage.size.width / imageSize.width;
  CGFloat scaleY = self.originalImage.size.height / imageSize.height;

  CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scaleX,
                                                                scaleY);


  CGPoint face2Center = face2.imageView.center;
  CGPoint face2Offset = face2.imageView.frame.origin;

  // Transform the measures of face 2.
  CGAffineTransform face2Transform = CGAffineTransformIdentity;
  face2Transform = CGAffineTransformTranslate(face2Transform,
                                              -face2Center.x,
                                              -face2Center.y);
  face2Transform = CGAffineTransformConcat(face2Transform, scaleTransform);
  face2Transform = CGAffineTransformRotate(face2Transform, -face2.rotationAngle);
  face2Transform = CGAffineTransformRotate(face2Transform, face1.rotationAngle);

//  face2Transform = CGAffineTransformRotate(face2Transform,
//                                           -face2.rotationAngle);

  CGPoint face2LeftEye = {face2.leftEyePosition.x + face2Offset.x,
                          face2.leftEyePosition.y + face2Offset.y};
  face2LeftEye = CGPointApplyAffineTransform(face2LeftEye, face2Transform);

  CGPoint face2RightEye = {face2.rightEyePosition.x + face2Offset.x,
                           face2.rightEyePosition.y + face2Offset.y};
  face2RightEye = CGPointApplyAffineTransform(face2RightEye, face2Transform);

//  CGPoint face2Mouth = CGPointApplyAffineTransform(face2.mouthPosition,
//                                                   face2Transform);

  NSLog(@"F2 FRAME: %@ - IMG SIZE: %@", NSStringFromCGRect(face2.imageView.frame), NSStringFromCGSize(face2.imageView.image.size));
  NSLog(@"F2 SRC LE: %@  LE %@", NSStringFromCGPoint(face2.leftEyePosition), NSStringFromCGPoint(face2LeftEye));
  NSLog(@"F2 SRC RE: %@  RE %@", NSStringFromCGPoint(face2.rightEyePosition), NSStringFromCGPoint(face2RightEye));
//  NSLog(@"F2 SRC MO: %@  MO %@", NSStringFromCGPoint(face2.mouthPosition), NSStringFromCGPoint(face2Mouth));


  CGPoint face1Center = face1.imageView.center;
  CGPoint face1Offset = face1.imageView.frame.origin;

  // Transform the measures of face 1.
  CGAffineTransform face1Rotation = CGAffineTransformIdentity;
  face1Rotation = CGAffineTransformTranslate(face1Rotation,
                                             -face1Center.x,
                                             -face1Center.y);
  face1Rotation = CGAffineTransformConcat(face1Rotation, scaleTransform);

//  face1Rotation = CGAffineTransformRotate(face1Rotation, -face1.rotationAngle);

  CGPoint face1LeftEye = {face1.leftEyePosition.x + face1Offset.x,
                          face1.leftEyePosition.y + face1Offset.y};
  face1LeftEye = CGPointApplyAffineTransform(face1LeftEye, face1Rotation);

  CGPoint face1RightEye = {face1.rightEyePosition.x + face1Offset.x,
                           face1.rightEyePosition.y + face1Offset.y};
  face1RightEye = CGPointApplyAffineTransform(face1RightEye, face1Rotation);
  
//  CGPoint face1Mouth = CGPointApplyAffineTransform(face1.mouthPosition,
//                                                   face1Rotation);

  CGFloat face1Diff = face1RightEye.x - face1LeftEye.x;
  CGFloat face2Diff = face2RightEye.x - face2LeftEye.x;

  CGFloat diffScale = face1Diff / face2Diff;

  NSLog(@"F1 FRAME: %@", NSStringFromCGRect(face1.imageView.frame));
  NSLog(@"F1 SRC LE: %@  LE %@", NSStringFromCGPoint(face1.leftEyePosition), NSStringFromCGPoint(face1LeftEye));
  NSLog(@"F1 SRC RE: %@  RE %@", NSStringFromCGPoint(face1.rightEyePosition), NSStringFromCGPoint(face1RightEye));
//  NSLog(@"F1 SRC MO: %@  MO %@", NSStringFromCGPoint(face1.mouthPosition), NSStringFromCGPoint(face1Mouth));


  NSLog(@"SCALE X: %f", diffScale);

  CGSize face2Size = face2.imageView.image.size;

  CGPoint imageCenter = CGPointMake(face2Size.width / 2, face2Size.height / 2);


  face2Transform = CGAffineTransformMakeTranslation(-face2Center.x, -face2Center.y);
  face2Transform = CGAffineTransformScale(face2Transform, diffScale, diffScale);
  face2Transform = CGAffineTransformRotate(face2Transform, -face2.rotationAngle);
  face2Transform = CGAffineTransformRotate(face2Transform, face1.rotationAngle);

//  face2LeftEye = CGPointApplyAffineTransform(face2.leftEyePosition,
//                                             face2Transform);

  CGFloat xDiff = face1LeftEye.x - face2LeftEye.x;
  CGFloat yDiff = face1LeftEye.y - face2LeftEye.y;

  NSLog(@"DIFF X: %f - Y: %f", xDiff, yDiff);

  face2Transform = CGAffineTransformTranslate(face2Transform,
                                              face2Center.x,
                                              face2Center.y);

  CGRect sourceRect = CGRectMake(0, 0, face2Size.width, face2Size.height);
  CGRect newFrame = CGRectApplyAffineTransform(sourceRect, face2Transform);

  NSLog(@"New frame: %@", NSStringFromCGRect(newFrame));

  CGPoint imageOrigin = {-imageCenter.x, -imageCenter.y};
  CGRect imageFrame = (CGRect){imageOrigin, face2Size};
  NSLog(@"Image frame: %@", NSStringFromCGRect(imageFrame));


  // Create the transformed bitmap.
  UIGraphicsBeginImageContext(newFrame.size);
  CGContextRef bitmap = UIGraphicsGetCurrentContext();
  CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);

  CGAffineTransform bitmapTransform = CGContextGetCTM(bitmap);
  bitmapTransform = CGAffineTransformTranslate(bitmapTransform,
                                               newFrame.size.width / 2,
                                               newFrame.size.height / 2);
  bitmapTransform = CGAffineTransformScale(bitmapTransform,
                                           diffScale,
                                           diffScale);
  bitmapTransform = CGAffineTransformRotate(bitmapTransform,
                                            -face2.rotationAngle);
  bitmapTransform = CGAffineTransformRotate(bitmapTransform,
                                            face1.rotationAngle);

  CGContextConcatCTM(bitmap, bitmapTransform);
  CGContextDrawImage(bitmap, imageFrame, face2.imageView.image.CGImage);

  UIImage *transformedImage = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  return transformedImage;

}

@end
