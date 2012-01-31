//
//  FifteenPuzzleViewController.m
//  FifteenPuzzle
//
//  Created by Travis Hall on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FifteenPuzzleViewController.h"
#import "FifteenBoard.h"

@implementation FifteenPuzzleViewController

@synthesize boardView;
@synthesize board;

// Added to respond to shake events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.board = [[FifteenBoard alloc] init];
    [board scramble:NUM_SHUFFLES];
    [self arrangeBoardView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

// Changed to respond to shake events
- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)tileSelected:(UIButton*)sender
{
    const int tag = [sender tag];
    int row, col;
    [board getRow:&row Column:&col ForTile:tag];
    NSLog(@"tileSelected - tag: %2d @ (%2d, %2d)", tag, row, col);
    CGRect buttonFrame = sender.frame;
    
    if ([board canSlideTileAtRow:row Column:col]) {
        TILE_DIRECTION direction = [board slideTileAtRow:row Column:col];
        switch (direction) {
            case TILE_UP:
                buttonFrame.origin.y = (row-1)*buttonFrame.size.height;
                break;
            case TILE_DOWN:
                buttonFrame.origin.y = (row+1)*buttonFrame.size.height;
                break;
            case TILE_LEFT:
                buttonFrame.origin.x = (col-1)*buttonFrame.size.width;
                break;
            case TILE_RIGHT:
                buttonFrame.origin.x = (col+1)*buttonFrame.size.width;
                break;
            default:
                break;
        }
        [UIView animateWithDuration:0.5 animations:^{sender.frame = buttonFrame;}];
        
        if ([board isSolved]) {
            [self showCongratulations];
            NSLog(@"Congratulations!");
        }
    }
}

/* TODO: Should probably make this UIAlertView a constant? Instead of generating each time? */
-(void)showCongratulations {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                      message:@"You have won!"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

// Shake events cause the game to "cheat" and move into a winning configuration
// Mostly for testing, also because I wanted to win for once.
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Cheater!"
                                                          message:@"I hope you can live with yourself..."
                                                         delegate:nil
                                                cancelButtonTitle:@"Ugh"
                                                otherButtonTitles:nil];
        [message show];
        
        [board cheat];
        [self arrangeBoardView];
    }
}

-(IBAction)scrambleTiles:(id)sender
{
    [board scramble:NUM_SHUFFLES];
    [self arrangeBoardView];
}

-(void)arrangeBoardView
{
    const CGRect boardBounds = boardView.bounds;
    const CGFloat tileWidth = boardBounds.size.width / 4.0;
    const CGFloat tileHeight = boardBounds.size.width / 4.0;
    for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
            const int tile = [board getTileAtRow:row Column:col];
            if (tile > 0) {
                __weak UIButton *button = (UIButton *)[boardView viewWithTag:tile];
                button.frame = CGRectMake(col*tileWidth, row*tileHeight, tileWidth, tileHeight);
            }
        }
    }
}

@end
