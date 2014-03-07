//
//  SMUCustomAnnotationView.m
//  SetMeUp
//
//  Created by ArulRaj on 1/28/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCustomAnnotationView.h"

@implementation SMUCustomAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation {
    self = [super initWithAnnotation:annotation reuseIdentifier:@"JPSThumbnailAnnotationView"];
    if (self) {
    // NSLog(@"state:%u",_state);
    self.canShowCallout = YES;
    UIView *anView=[[UIView alloc] init];
    anView.backgroundColor=[UIColor clearColor];
    
    UIImageView *bgImg=[[UIImageView alloc] init];
    bgImg.image=[UIImage imageNamed:@""];
    bgImg.backgroundColor=[UIColor clearColor];
    
    UIImageView *imgView=[[UIImageView alloc] init];
    //imgView.tag=myAnnotation.ann_tag;
    
    UILabel *lblName=[[UILabel alloc] init];
    lblName.font=[UIFont systemFontOfSize:12];
    lblName.textAlignment=NSTextAlignmentCenter;
    lblName.textColor=[UIColor whiteColor];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.text=@"Colachel" ;
    
    self.frame=CGRectMake(0, 0, 70, 212);
    anView.frame=CGRectMake(0, 0, 70, 212);
    bgImg.frame=CGRectMake(0, 0, 80, 40);
    bgImg.image=[UIImage imageNamed:@"checkin_icon"];
    
    imgView.frame=CGRectMake(8,25,55,48);
    imgView.image=[UIImage imageNamed:@"checkin_icon"];
    lblName.frame=CGRectMake(5,79,60,10);
    
    
    
    [anView addSubview:bgImg];
    //[bgImg release];
    //   [anView addSubview:imgView];
    // [imgView release];
    [self addSubview:anView];
    // [anView release];
    
    self.canShowCallout=YES;
    [self setEnabled:YES];
    
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 100)];
    vw.backgroundColor = [UIColor clearColor];
    UIImageView *placeImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 35)];
    //NSLog(@"selected image url:%@",myAnnotation.placeImageUrl);
    // placeImage.image = [UIImage imageNamed:@"checkin_icon"];
    //[placeImage setImageWithURL:[NSURL URLWithString:myAnnotation.placeImageUrl] placeholderImage:nil];
    [vw addSubview:placeImage];
    
    UIView *vw1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 100)];
    vw1.backgroundColor = [UIColor greenColor];
    //
    self.leftCalloutAccessoryView = vw;
    self.rightCalloutAccessoryView = vw1;
}

return self;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
