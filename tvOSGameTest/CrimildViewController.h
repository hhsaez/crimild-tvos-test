//
//  CrimildViewController.h
//  tvOSGameTest
//
//  Created by Hernan Saez on 11/20/15.
//  Copyright © 2015 Hernan Saez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import <Crimild.hpp>

@interface CrimildViewController : GLKViewController

@property (nonatomic, readonly) crimild::Simulation *simulation;

@end
