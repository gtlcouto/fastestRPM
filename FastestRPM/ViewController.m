//
//  ViewController.m
//  FastestRPM
//
//  Created by Gustavo Couto on 2016-05-12.
//  Copyright © 2016 Gustavo Couto. All rights reserved.
//

#import "ViewController.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0) //NOT WORKING??

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


#define MIN_DEGREES      -135.0
#define MAX_DEGREES      135.0
#define RANGE_DEGREES    (MAX_DEGREES - MIN_DEGREES)

#define LIMIT_VELOCITY           1000.0 // Points per second
#define LIMIT_VELOCITY_DELTA 10.0 // Points per second

#define RESET_DELAY      0.1 // Seconds
#define VELOCITY_DELAY   0.1 // Seconds


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *speedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *needleImageView;

//not needed because Im always adding 140 to the angle to offset needle(easier to read and understand)
@property (nonatomic)CGAffineTransform transform;

//not being used
@property CGFloat currVelocity;
@property CGFloat maxVelocity;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //INITIAL SETUP
    self.needleImageView.center = self.speedImageView.center;
    //Set needle to the initial point
    self.needleImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(140));
;
    //ADD GESTURE

    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBegins:)];
    [self.view addGestureRecognizer:panGesture];


}

-(void)panBegins:(UIPanGestureRecognizer*)sender
{
    //get velocity
    CGPoint componentVelocity = [sender velocityInView:self.view];
    CGFloat velocity = sqrt(pow(componentVelocity.x, 2) + pow(componentVelocity.y, 2));

    //call function to move needle
    [self moveNeedleWithVelocity:velocity];

    //if pan ends we reset the needle
    //TO-DO: FIX rotation angle so it doesnt go clockwise
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        self.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.5 animations:^{
             self.needleImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(140));
        }];
    }

}

- (void)moveNeedleWithVelocity:(CGFloat)velocity {

    //never used?
    self.currVelocity = velocity;
    //never used, could use to limit velocity but it looks really strange
    self.maxVelocity = MAX(self.maxVelocity, velocity);

    // Calculate proportion of current velocity to velocity limit
    CGFloat velocityProportion = velocity / LIMIT_VELOCITY;

    // Calculate proportion of RPM needle degree range
    CGFloat degrees = MIN(RANGE_DEGREES * velocityProportion, RANGE_DEGREES);

    // Move needle in degree range proportionate to velocity
    self.needleImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees + 140.0));



}




@end
