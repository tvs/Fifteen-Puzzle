//
//  FifteenPuzzleViewController.h
//  FifteenPuzzle
//
//  Created by Travis Hall on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FifteenBoard.h"

//@class FifteenBoard; // Faster compiles to tell the compiler that the class exists

@interface FifteenPuzzleViewController : UIViewController

@property(weak,nonatomic) IBOutlet UIView *boardView;
@property(strong,nonatomic) FifteenBoard *board;

-(IBAction)tileSelected:(UIButton*)sender;
-(IBAction)scrambleTiles:(id)sender;
-(void)arrangeBoardView;
-(void)showCongratulations;

@end
