//
//  Engine.m
//  Phone-Crawl
//
//  Created by Austin Kelley on 1/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Engine.h"

#import "Dungeon.h"
#import "Creature.h"
//#import "LevelGen.h"
#import "ItemGen.h"

#import "Tile.h"

// Engine Tile Quick References
#define NoTileImage [UIImage imageNamed:@"BlackSquare.png"]


@interface Engine (Private)

@end


@implementation Engine

#pragma mark -
#pragma mark Life Cycle
- (id) init
{
	if(self = [super init])
	{
		liveEnemies = [[NSMutableArray alloc] init];
		deadEnemies = [[NSMutableArray alloc] init];
		player = [[Creature alloc] init];
		currentDungeon = [[Dungeon alloc] initWithType:town];
		
		return self;
	}
	return nil;
}

- (void) releaseResources
{
	[liveEnemies release];
	[deadEnemies release];
	[player release];
	[currentDungeon release];
}

- (void) dealloc
{
	[self releaseResources];
	[super dealloc];
	
}

- (void) loadDungeon:(Dungeon *)dungeon
{
	
}

- (void) updateWorldView:(WorldView*) wView
{
	Coord *center = [Coord newCoordWithX:2 Y:2 Z:0];
	//Coord *center = [player location];
	int xInd, yInd;
	int squaresWide = 10, squaresHigh = 10;
	
	CGRect bounds = wView.mapImageView.bounds;
	int imageWidth = bounds.size.width/squaresWide;
	int imageHeight = bounds.size.height/squaresHigh;
	
	UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	int halfWide = squaresWide/2, halfHigh = squaresHigh/2;
	
	CGPoint lowerRight = CGPointMake(center.X+halfWide-1, center.Y+halfHigh-1);
	CGPoint upperLeft = CGPointMake(center.X-halfWide, center.Y-halfHigh);
	
	UIGraphicsPushContext(context);
	
	for (xInd = upperLeft.x; xInd <= lowerRight.x; ++xInd)
	{
		for(yInd = upperLeft.y; yInd <= lowerRight.y; ++yInd)
		{
			UIImage *img;
			Tile *t = [currentDungeon tileAtX:xInd Y:yInd Z:center.Z];
			if(t)
				img = [Tile imageForType:t.type]; //Get tile from array by index if it exists
			else
				img = [Tile imageForType:tileNone]; //Black square if the tile doesn't exist

			[img drawInRect:CGRectMake((xInd-upperLeft.x)*imageWidth, (yInd-upperLeft.y)*imageHeight, imageWidth, imageHeight)];
			// Draw each tile in the proper place
			//CGContextDrawImage(context, CGRectMake((xInd-upperLeft.x)*imageWidth, (yInd-upperLeft.y)*imageHeight, imageWidth, imageHeight), img.CGImage);
			// Draw each tile in inverted place. Is useless because image is upside down, not inverted.
			//CGContextDrawImage(context, CGRectMake((lowerRight.x - xInd)*imageWidth, (lowerRight.x - yInd)*imageHeight, imageWidth, imageHeight), img.CGImage);
		}
	}
	
	// Draw the player on the proper tile.
	UIImage *playerSprite = [UIImage imageNamed:@"human.png"];
	[playerSprite drawInRect:CGRectMake((center.X-upperLeft.x)*imageWidth, (center.Y-upperLeft.y)*imageHeight, imageWidth, imageHeight)];
	//CGContextDrawImage(context, CGRectMake((center.X-upperLeft.x)*imageWidth, (center.Y-upperLeft.y)*imageHeight, imageWidth, imageHeight), playerSprite.CGImage);
	// Draws player tile on proper tile for inverted view. Is useless.
	//CGContextDrawImage(context, CGRectMake((lowerRight.x - center.X)*imageWidth, (lowerRight.y - center.Y)*imageHeight, imageWidth, imageHeight), playerSprite.CGImage);
	
	UIGraphicsPopContext();
	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	wView.mapImageView.image = result;
}



@end
