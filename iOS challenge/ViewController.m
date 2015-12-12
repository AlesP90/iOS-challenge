//
//  ViewController.m
//  iOS challenge
//
//  Created by Ales Pintaric on 11/12/15.
//  Copyright © 2015 Ales Pintaric. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scroller.contentSize=CGSizeMake(320,1200);
    scroller_genre.contentSize=CGSizeMake(1000,60);

    [self movie];


   

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)movie
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData* kivaData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/264660?api_key=ea793354ae0aae7ec17fd6d6f5f692a2"]
                            ];
        NSDictionary* json = nil;
        if (kivaData) {
            json = [NSJSONSerialization
                    JSONObjectWithData:kivaData
                    options:kNilOptions
                    error:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self movie_parse: json];
            [self movie_credits];

        });
        
    });
}

-(void)movie_parse:(NSDictionary*)json {
    
    MoviePicture = [[NSMutableArray alloc]init];
    Movie_Name = [[NSMutableArray alloc]init];
    Release_date = [[NSMutableArray alloc]init];
    Run_time = [[NSMutableArray alloc]init];
    Revenue = [[NSMutableArray alloc]init];
    Tagline = [[NSMutableArray alloc]init];
    Vote_average = [[NSMutableArray alloc]init];
    Vote_count = [[NSMutableArray alloc]init];
    Genres = [[NSMutableArray alloc]init];
    Overview = [[NSMutableArray alloc]init];

    [MoviePicture addObject:[json valueForKeyPath:@"poster_path"]];
    [Movie_Name addObject:[json valueForKeyPath:@"title"]];
    [Release_date addObject:[json valueForKeyPath:@"release_date"]];
    [Run_time addObject:[json valueForKeyPath:@"runtime"]];
    [Revenue addObject:[json valueForKeyPath:@"revenue"]];
    [Tagline addObject:[json valueForKeyPath:@"tagline"]];
    [Vote_average addObject:[json valueForKeyPath:@"vote_average"]];
    [Vote_count addObject:[json valueForKeyPath:@"vote_count"]];
    [Genres addObjectsFromArray:[[json valueForKeyPath:@"genres"]valueForKey:@"name"]];
    [Overview addObject:[json valueForKeyPath:@"overview"]];


}

-(void)movie_credits
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData* kivaData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/264660/credits?api_key=ea793354ae0aae7ec17fd6d6f5f692a2"]
                            ];
        NSDictionary* json = nil;
        if (kivaData) {
            json = [NSJSONSerialization
                    JSONObjectWithData:kivaData
                    options:kNilOptions
                    error:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self movie_credits_parse: json];
            [self movie_video];

        });
        
    });
}

-(void)movie_credits_parse:(NSDictionary*)json {
    
  //  NSLog(@"%@",[[json valueForKeyPath:@"cast"]valueForKey:@"character"]);
    
    
}

-(void)movie_video
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData* kivaData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/264660/videos?api_key=ea793354ae0aae7ec17fd6d6f5f692a2"]
                            ];
        NSDictionary* json = nil;
        if (kivaData) {
            json = [NSJSONSerialization
                    JSONObjectWithData:kivaData
                    options:kNilOptions
                    error:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self movie_video_parse: json];
            [self show];
        });
        
    });
}

-(void)movie_video_parse:(NSDictionary*)json {
    
    Trailer = [[NSMutableArray alloc]init];
    
    [Trailer addObjectsFromArray:[[json valueForKeyPath:@"results"]valueForKey:@"key"]];
    
    

    
}


-(void)show
{
    NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://image.tmdb.org/t/p/w500",[MoviePicture objectAtIndex:0]]];
    
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    
    Image.image = image;
    
    UIImage *btnImage = [UIImage imageNamed:@"playico.png"];
    [Playbutton setImage:btnImage forState:UIControlStateNormal];
    
    UIImage *img = [UIImage imageNamed:@"playico1.png"];
    [animate_play_img setImage:img];
    
    [UIView animateWithDuration:1.0
                          delay:0.8
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [animate_play setTransform:CGAffineTransformMakeScale(2.5, 2.5)];
                         
                     } completion:NULL];

    
    lb_movie_name.text = [Movie_Name objectAtIndex:0];
    lb_rating.text = @"Rating:";
    lb_release.text = @"Release Date:";
    lb_run.text = @"Run Time:";
    lb_revenue.text = @"Revenue:";

    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString: [Release_date objectAtIndex:0]];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *new_date = [dateFormatter stringFromDate:date];
    lb_movie_release.text = new_date;
    
    
    float n = [[Run_time objectAtIndex:0]intValue]/60.00;
    lb_movie_run.text = [NSString stringWithFormat:@"%i%@%g%@",[[Run_time objectAtIndex:0]intValue]/60,@" hr ",(n - floor(n))*60,@" min"];

    

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.locale = [NSLocale currentLocale];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    lb_movie_revenue.text =[NSString stringWithFormat:@"%@%@",@"$",[numberFormatter stringForObjectValue:[Revenue objectAtIndex:0]]];
    
    
    lb_movie_tagline.text = [Tagline objectAtIndex:0];

    lb_imdb.text = @"IMDB";
    lb_movie_vote_average.layer.masksToBounds = YES;
    lb_movie_vote_average.layer.cornerRadius = 5.0;
    lb_movie_vote_average.text = [NSString stringWithFormat:@"%@",[Vote_average objectAtIndex:0]];
    lb_movie_vote_count.text = [NSString stringWithFormat:@"%@%@%@",@"(",[Vote_count objectAtIndex:0],@" votes)"];
    
   
    
    for(int i=0; i<[Genres count];i++)
    {
        btn_genre=[[UIButton alloc]init];
        [btn_genre setTitle:[NSString stringWithFormat:@"%@%@%@",@"     ",[Genres objectAtIndex:i],@"     "] forState:UIControlStateNormal];

        [btn_genre setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_genre.titleLabel.font = [UIFont systemFontOfSize:12];

        btn_genre.layer.masksToBounds = YES;
        btn_genre.layer.cornerRadius = 12.0;
        btn_genre.layer.borderColor = [UIColor whiteColor].CGColor;
        btn_genre.layer.borderWidth = 0.8;

        [view_genre addSubview:btn_genre];

        view_genre.translatesAutoresizingMaskIntoConstraints = NO;
        btn_genre.translatesAutoresizingMaskIntoConstraints = NO;

        
        [view_genre addConstraint:[NSLayoutConstraint constraintWithItem:btn_genre
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:view_genre
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:0]];
        
        [view_genre addConstraint:[NSLayoutConstraint constraintWithItem:btn_genre
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:view_genre
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1
                                                                  constant:(i*80)+10]];
      
    }
 
    lb_cast.text = @"CAST";

    
    
    
    
    lb_story.text = @"STORYLINE";

    txt_story.text = [Overview objectAtIndex:0];
    txt_story.textColor =[UIColor whiteColor];
    [txt_story sizeToFit];
    
    
    
    btn_buy.layer.masksToBounds = YES;
    btn_buy.layer.cornerRadius = 15.0;
    btn_buy.layer.borderColor = [UIColor whiteColor].CGColor;
    btn_buy.layer.borderWidth = 0.8;
    btn_share.layer.masksToBounds = YES;
    btn_share.layer.cornerRadius = 15.0;
    btn_share.layer.borderColor = [UIColor whiteColor].CGColor;
    btn_share.layer.borderWidth = 0.8;
}

-(IBAction)play_button
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://www.youtube.com/watch?v=",[Trailer objectAtIndex:0]]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
