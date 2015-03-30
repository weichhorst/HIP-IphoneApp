//
//  SignatureView.m
//  Conasys
//
//  Created by abhi on 6/27/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "SignatureView.h"
#import <QuartzCore/QuartzCore.h>

@interface SignatureView()
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic, strong) UIImage* oldImage;
@end



#define TEMP_IMAGE_NAME @"temp.png"

@implementation SignatureView
@synthesize signatureImg,callview,editImg,finalEditImg,getSignatureView;

- (IBAction)btnClose:(id)sender
{

    [Utility removeImage:TEMP_IMAGE_NAME];
    completionBlock(self.base64String, nil, 0, _isBuilder);
}



- (void)setCustomerSignText:(NSString *)signatureText
{
    
}

- (IBAction)btnSignatureClear:(UIButton*)sender
{

    [Utility removeImage:TEMP_IMAGE_NAME];
    
    signatureImg.alpha=0.0;
    [signatureImg setImage:[UIImage imageNamed:@""]];
}


- (void)setImageForView:(NSString *)image64String andName:(NSString *)name{
    
    if(image64String.length>10){
        

        [signatureImg setImage:[UIImage imageWithData:[NSData dataFromBase64String:image64String]]];
        
    }
        
    self.base64String = image64String;
    
    [textFieldUserNickName setText:name];
        
    [textFieldUserNickName addLeftLabelToMyTextField:@"            " andWidth:100.0f];
    
    [self setFonts];
}

- (void)setTitleForLabel:(NSString *)title{
    
    [lblTitle setText:title];
}

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id imageString, id data, int buttonTag, BOOL builder))myBlock
{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        completionBlock = myBlock;
         if(myBlock){
             myBlock=nil;
         }
        red = 0.0/255.0;
        green = 0.0/255.0;
        blue = 0.0/255.0;
        brush = 2.0;
        opacity = 1.0;
    }
    return self;
}


- (IBAction)btnSave:(UIButton*)sender
{
    if (newImage) {

        self.base64String = [self getImageBase64StringFromImageName:TEMP_IMAGE_NAME];
    }
    
    if(signatureImg.image){
    
        completionBlock(self.base64String, textFieldUserNickName.text, (int)sender.tag, _isBuilder);;
    }
    else{
        
        completionBlock(@"", textFieldUserNickName.text, (int)sender.tag, _isBuilder);;
    }
    
    [Utility removeImage:TEMP_IMAGE_NAME];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    mouseSwiped = NO;
    newImage = YES;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:getSignatureView];
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    newImage = YES;
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:getSignatureView];
    UIGraphicsBeginImageContext(getSignatureView.frame.size);
    [signatureImg.image drawInRect:CGRectMake(0, 0, getSignatureView.frame.size.width, getSignatureView.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    signatureImg.image = UIGraphicsGetImageFromCurrentImageContext();
    [signatureImg setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    newImage = YES;
    if(!mouseSwiped)
    {
        
        UIGraphicsBeginImageContext(getSignatureView.frame.size);
        [signatureImg.image drawInRect:CGRectMake(0, 0, getSignatureView.frame.size.width, getSignatureView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        signatureImg.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    UIGraphicsBeginImageContext(finalEditImg.frame.size);
    [finalEditImg.image drawInRect:CGRectMake(0, 0, getSignatureView.frame.size.width,getSignatureView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lastPoint.x);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    [self saveImage:signatureImg.image andImageName:TEMP_IMAGE_NAME];

}



- (void)saveImage: (UIImage*)image andImageName:(NSString *)myImageName
{
    

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          myImageName];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];

}



// getting base 64 string for image.
- (NSString *)getImageBase64StringFromImageName:(NSString *)imageName{
    
    
    NSData * data = UIImagePNGRepresentation([Utility loadImageFromDD:[Utility getImagePath:imageName]]);
    
    return [data base64EncodedString];
    
}


- (void)setFonts{
    
    [btnSignatureClear.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    [btnSignatureSave.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    [textFieldUserNickName setFont:[UIFont regularWithSize:13.0f]];
    [lblPlaceHolder setFont:[UIFont semiBoldWithSize:11.0f]];
    [lblHeader setFont:[UIFont semiBoldWithSize:18.0f]];
    [lblTitle setFont:[UIFont semiBoldWithSize:13.0f]];
    
    [btnSignatureClear roundedBorderWithWidth:0.0 radius:4.0f andColor:[UIColor clearColor]];
    [btnSignatureSave roundedBorderWithWidth:0.0 radius:4.0f andColor:[UIColor clearColor]];
    
    [btnSignatureClear setBackgroundColor:COLOR_BLUE_APP];
    [btnSignatureSave setBackgroundColor:COLOR_BLUE_APP];
    
}


@end
