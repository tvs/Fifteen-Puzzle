//
//  FifteenBoard.m
//  FifteenPuzzle
//
//  Created by Travis Hall on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FifteenBoard.h"

@implementation FifteenBoard

-(id)init
{
    if (self = [super init]) {
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
                board[i][j] = i*4+(j+1);
        board[3][3] = 0;
    }
    return self;
}

/**
 Refactor - this is awful! Seriously.
 Should "move" the empty space around rather than move spaces into
 the empty one.
 */
-(void)scramble:(int)n
{
    for (int i = 0; i < n; i++) {
        int row, col;
        do {
            row = rand() % 4;
            col = rand() % 4;
        } while(![self canSlideTileAtRow:row Column:col]);
        [self slideTileAtRow:row Column:col];
    }
}

/**
 * Moves the board into a completed configuration
 */
-(void)cheat {
    for (int i = 0; i < 4; i++)
        for (int j = 0; j < 4; j++)
            board[i][j] = i*4+(j+1);
    board[3][3] = 0;
}

-(int)getTileAtRow:(int)row Column:(int)col
{
    return board[row][col];
}

-(void)getRow:(int*)row Column:(int*)col ForTile:(int)tile
{
    for (int i = 0; i < 4; i++)
        for (int j = 0; j < 4; j++)
            if (board[i][j] == tile) {
                (*row) = i; (*col) = j;
            }
                
}

-(BOOL)isSolved;
{
    for (int i = 0; i < 15; i++) {
        int row = i / 4;
        int col = i % 4;
        if (board[row][col] != ((i+1)%16))
            return NO;
    }

    return YES;
}

-(BOOL)canSlideTileAtRow:(int)row Column:(int)col
{
    return [self canSlideTileUpAtRow:row Column:col] ||
        [self canSlideTileDownAtRow:row Column:col] ||
        [self canSlideTileLeftAtRow:row Column:col] ||
        [self canSlideTileRightAtRow:row Column:col];
}

-(BOOL)canSlideTileUpAtRow:(int)row Column:(int)col
{
    return row > 0 && board[row-1][col] == 0;
}

-(BOOL)canSlideTileDownAtRow:(int)row Column:(int)col
{
    return row < 3 && board[row+1][col] == 0;
}

-(BOOL)canSlideTileLeftAtRow:(int)row Column:(int)col
{
    return col > 0 && board[row][col-1] == 0;
}

-(BOOL)canSlideTileRightAtRow:(int)row Column:(int)col
{
    return col < 3 && board[row][col+1] == 0;
}

-(TILE_DIRECTION)slideTileAtRow:(int)row Column:(int)col
{
    int tmp = board[row][col];
    TILE_DIRECTION moved = TILE_NONE;
    if ([self canSlideTileUpAtRow:row Column:col]) {
        board[row][col] = board[row-1][col];
        board[row-1][col] = tmp;
        moved = TILE_UP;
    } else if ([self canSlideTileDownAtRow:row Column:col]) {
        board[row][col] = board[row+1][col];
        board[row+1][col] = tmp;
        moved = TILE_DOWN;
    } else if ([self canSlideTileLeftAtRow:row Column:col]) {
        board[row][col] = board[row][col-1];
        board[row][col-1] = tmp;
        moved = TILE_LEFT;
    } else if ([self canSlideTileRightAtRow:row Column:col]) {
        board[row][col] = board[row][col+1];
        board[row][col+1] = tmp;
        moved = TILE_RIGHT;
    }
    return moved;
}

@end
