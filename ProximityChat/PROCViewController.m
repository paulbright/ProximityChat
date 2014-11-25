//
//  PROCViewController.m
//  ProximityChat
//
//  Created by Paul Bright on 2014/09/05.
//  Copyright (c) 2014 Paul Bright. All rights reserved.
//

#import "PROCViewController.h"
#import "PROCAppDelegate.h"; 


#define kGameKitSessionID @"proximity chat(1.0)"

@implementation PROCViewController

@synthesize adview;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    lbl_info.text = @"data";
    
    adview.delegate = self;
    /*
    session = [[GKSession alloc] initWithSessionID:kGameKitSessionID displayName:nil sessionMode:GKSessionModePeer];
    
    session.delegate = self;
    
    GKPeerPickerController * picker = [[GKPeerPickerController alloc] init];
    
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby |
                                    GKPeerPickerConnectionTypeOnline;
    
    [picker show];
    
    */
    
    UIImage *image = [UIImage imageNamed:@"zebra.jpg"];
    
    image = [self fixrotation:image];
    
    UIImage *img = [self resizeImage:image resizeTo:imageView.frame];
    
    NSLog(@"w:%f  h:%f", img.size.width, img.size.height);
    
    imageView.image = img;
}

-(UIImage *) resizeImage : (UIImage *) image resizeTo: (CGRect) rect
{
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *imageData = UIImagePNGRepresentation(picture1);
    return [UIImage imageWithData:imageData];
}


-(NSMutableArray *)getImagesFromImage:(UIImage *)image withRow:(NSInteger)rows withColumn:(NSInteger)columns
{
    NSMutableArray *images = [NSMutableArray array];
    CGSize imageSize = image.size;
    CGFloat xPos = 0.0, yPos = 0.0;
    CGFloat width = imageSize.width/columns;
    CGFloat height = imageSize.height/rows;
    
    for (int y = 0; y < rows; y++) {
        xPos = 0.0;
        for (int x = 0; x < columns; x++) {
            
            CGRect rect = CGRectMake(xPos, yPos, width, height);
            CGImageRef cImage = CGImageCreateWithImageInRect([image CGImage],  rect);
            
            UIImage *dImage = [[UIImage alloc] initWithCGImage:cImage];
            [images addObject:dImage];
            xPos += width;
        }
        yPos += height;
    }
    return images;
}

-(IBAction) clickSplitButton : (id) sender
{
    int num_splits = [textNumberOfSplits text].intValue;
    Point startPoint;
    int vgap = 10;
    int hgap = 10;
    int array_index = 0;
    
    imageView.hidden = true;
    startPoint.h = 10; startPoint.v = 10;
    
    NSMutableArray *images = [self getImagesFromImage:imageView.image withRow:num_splits withColumn:num_splits];
    
    for (int r=0; r < num_splits; r++)
    {
        for (int c=0; c < num_splits; c++)
        {
            UIImage *img = ((UIImage *)[images objectAtIndex: array_index]);
            int y = startPoint.v +  (img.size.height * r) + (r * vgap);
            int x = startPoint.h +  (img.size.width * c ) + (c * hgap);
            
            CGRect rect = CGRectMake( x, y, img.size.width, img.size.height);
            
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:rect];
            
            
            //imgV setAutoresizingMask:
            imgV.image = img;
            if(r==2)
            [self.view addSubview:imgV];
            NSLog(@"(%d %d) (%.02f  %.02f) (%.02f  %.02f)", x,y, rect.size.width, rect.size.height,
                  img.size.width, img.size.height);
            testView.image = img;
            
            ++array_index;
            
        }
        
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    adview = [[self appDelegate] adview];
    adview.delegate = self;
    [adview setFrame:CGRectMake(10, 20, 300, 50)];
    [self.view addSubview:adview];
    
}

-(PROCAppDelegate *) appDelegate
{
    return (PROCAppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark iAd delegate methods

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    adview.hidden = true;
    NSLog(@"no ad. hiding");
}

-(void) bannerViewWillLoadAd:(ADBannerView *)banner
{
    
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    adview.hidden = false;
    NSLog(@"has ad. displaying");
}

@end
