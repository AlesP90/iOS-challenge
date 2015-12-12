//
//  ViewController.h
//  iOS challenge
//
//  Created by Ales Pintaric on 11/12/15.
//  Copyright © 2015 Ales Pintaric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSMutableArray *MoviePicture;
    NSMutableArray *Trailer;
    NSMutableArray *Movie_Name;
    NSMutableArray *Release_date;
    NSMutableArray *Run_time;
    NSMutableArray *Revenue;
    NSMutableArray *Tagline;
    NSMutableArray *Vote_average;
    NSMutableArray *Vote_count;
    NSMutableArray *Genres;
    NSMutableArray *Overview;

    IBOutlet UIScrollView *scroller;
    IBOutlet UIScrollView *scroller_genre;

    IBOutlet UIImageView *Image;
    IBOutlet UIButton *Playbutton;
    IBOutlet UIView *animate_play;
    IBOutlet UIImageView *animate_play_img;

    IBOutlet UILabel *lb_movie_name;
    IBOutlet UILabel *lb_rating;
    IBOutlet UILabel *lb_release;
    IBOutlet UILabel *lb_run;
    IBOutlet UILabel *lb_revenue;
    IBOutlet UILabel *lb_imdb;

    IBOutlet UILabel *lb_movie_release;
    IBOutlet UILabel *lb_movie_run;
    IBOutlet UILabel *lb_movie_revenue;
    
    IBOutlet UILabel *lb_movie_tagline;
    IBOutlet UILabel *lb_movie_vote_average;
    IBOutlet UILabel *lb_movie_vote_count;

    IBOutlet UIView *view_genre;
    UIButton *btn_genre;
    
    IBOutlet UILabel *lb_cast;
    IBOutlet UILabel *lb_story;
    IBOutlet UITextView *txt_story;

    IBOutlet UIButton *btn_buy;
    IBOutlet UIButton *btn_share;


}

-(IBAction)play_button;



@end

