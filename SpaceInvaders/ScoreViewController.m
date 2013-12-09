//
//  ScoreViewController.m
//  SpaceInvaders
//
//  Created by Rave on 08/12/13.
//  Copyright (c) 2013 M. All rights reserved.
//


#import "ScoreViewController.h"
#import "MyScene.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController {
    NSMutableArray *scores;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize table data
    NSString *fileName = @"Scores.plist";
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:finalPath];
    
    if (fileExists) {
        
        scores = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
        NSLog(@"%@", scores);

    }
//    else {
//             scores = [NSMutableArray arrayWithObjects:@"Score 1", @"Score 2", @"Score 3",@"Score 4", @"Score 5", @"Score 6",@"Score 7", @"Score 8", @"Score 9",@"Score 10", nil];
//    }
    
    NSSortDescriptor *sortedScores = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [scores sortUsingDescriptors:[NSArray arrayWithObject:sortedScores]];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [scores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ScoreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSLog(@"%@", indexPath);
    cell.textLabel.text = [NSString stringWithFormat:@"%d",[[scores objectAtIndex:indexPath.row] integerValue]];

    return cell;
}

@end