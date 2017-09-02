//
//  GameViewController.m
//  AssimpCarthage-iOSDemo
//
//  Created by Deepak Surti on 11/18/16.
//  Copyright © 2016 Ison Apps. All rights reserved.
//

#import "GameViewController.h"
#import <AssimpKit/PostProcessingFlags.h>
#import <AssimpKit/SCNAssimpAnimSettings.h>
#import <AssimpKit/SCNNode+AssimpImport.h>
#import <AssimpKit/SCNScene+AssimpImport.h>

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    NSString *bob = [docsDir stringByAppendingString:@"/Bob.md5mesh"];
    if([[NSFileManager defaultManager] fileExistsAtPath:bob]) {
            // load model
        SCNAssimpScene *scene =
        [SCNScene assimpSceneWithURL:[NSURL URLWithString:bob]
                    postProcessFlags:AssimpKit_JoinIdenticalVertices |
         AssimpKit_Process_FlipUVs |
         AssimpKit_Process_Triangulate];
        
            // load animation
        NSString *bobAnim = [docsDir stringByAppendingString:@"/Bob.md5anim"];
        [SCNScene assimpSceneWithURL:[NSURL URLWithString:bobAnim]
                    postProcessFlags:AssimpKit_JoinIdenticalVertices |
         AssimpKit_Process_FlipUVs |
         AssimpKit_Process_Triangulate];
        NSString *bobId = @"Bob-1";
        SCNAssimpAnimSettings *settings =
        [[SCNAssimpAnimSettings alloc] init];
        settings.repeatCount = 3;
        SCNScene *anim = [scene animationSceneForKey:bobId];
        [scene.modelScene.rootNode addAnimationScene:anim forKey:bobId
                                        withSettings:settings];
        
            // retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        
            // set the scene to the view
        scnView.scene = scene.modelScene;
        
            // allows the user to manipulate the camera
        scnView.allowsCameraControl = YES;
        
            // show statistics such as fps and timing information
        scnView.showsStatistics = YES;
        
            // configure the view
        scnView.backgroundColor = [UIColor blackColor];
        
        scnView.playing = YES;
    } else {
        NSLog(@"[ERROR]: Add bob assets via iTunes file sharing");
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
