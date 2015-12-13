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
    

    [self movie];
    [self rate_movie];
    
   

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
    
    Character = [[NSMutableArray alloc]init];
    Name = [[NSMutableArray alloc]init];
    Picture = [[NSMutableArray alloc]init];

    [Character addObjectsFromArray:[[json valueForKeyPath:@"cast"]valueForKey:@"character"]];
    [Name addObjectsFromArray:[[json valueForKeyPath:@"cast"]valueForKey:@"name"]];
    [Picture addObjectsFromArray:[[json valueForKeyPath:@"cast"]valueForKey:@"profile_path"]];
    
  

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
    lb_movie_rating.text = @"R";
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
    
    float number =[[Vote_average objectAtIndex:0]floatValue];
    
    if((number > 0.0)&&(number < 1.0))
    {
        rate_m = 1;
        [self myTapMethod];
        
    }else
    if((number > 1.0)&&(number < 2.0))
    {
        rate_m = 1;

        [self myTapMethod1];
    }
    else
    if((number > 2.0)&&(number < 3.0))
    {
        rate_m = 1;

        [self myTapMethod2];
    }
    else
    if((number > 3.0)&&(number < 4.0))
    {
        rate_m = 1;

        [self myTapMethod3];
    }
    else
    if((number > 4.0)&&(number < 5.0))
    {
        rate_m = 1;

        [self myTapMethod4];
    }
    else
    if((number > 5.0)&&(number < 6.0))
    {
        rate_m = 1;

        [self myTapMethod5];
    }else
    if((number > 6.0)&&(number < 7.0))
    {
        rate_m = 1;

        [self myTapMethod6];
    }else
    if((number > 7.0)&&(number < 8.0))
    {
        rate_m = 1;

        [self myTapMethod7];
    }else
    if((number > 8.0)&&(number < 9.0))
    {
        rate_m = 1;

        [self myTapMethod8];
    }else
    if((number > 9.0)&&(number < 10.0))
    {
        rate_m = 1;

        [self myTapMethod9];
    }
    
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

 

    for(int i=0; i<[Character count];i++)
    {
        
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://image.tmdb.org/t/p/w500",[Picture objectAtIndex:i]]];
        
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        
        img_picture =[[UIImageView alloc]init];
        
        img_picture.image = image;
        [cast_view addSubview:img_picture];

        cast_view.translatesAutoresizingMaskIntoConstraints = NO;
        img_picture.translatesAutoresizingMaskIntoConstraints = NO;
        
        [cast_view addConstraint:[NSLayoutConstraint constraintWithItem:img_picture
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:cast_view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
        
        [cast_view addConstraint:[NSLayoutConstraint constraintWithItem:img_picture
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:50]];
        [cast_view addConstraint:[NSLayoutConstraint constraintWithItem:img_picture
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:60]];

        if(i==0)
        {
            [cast_view addConstraint:[NSLayoutConstraint constraintWithItem:img_picture
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:cast_view
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1
                                                                   constant:30]];
            
        }
        else
        {
            [cast_view addConstraint:[NSLayoutConstraint constraintWithItem:img_picture
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:cast_view
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1
                                                                   constant:(i*100)+40]];
            
        }
        
        

        lb_name=[[UILabel alloc]init];
        lb_name.text =[Name objectAtIndex:i];
        lb_name.textColor = [UIColor whiteColor];
        lb_name.font = [UIFont systemFontOfSize:10.0f];
        
        
        [cast_view addSubview:lb_name];
        
        cast_view.translatesAutoresizingMaskIntoConstraints = NO;
        lb_name.translatesAutoresizingMaskIntoConstraints = NO;
        
        [cast_view addConstraint:[NSLayoutConstraint constraintWithItem:lb_name
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:cast_view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:60]];
       
        [cast_view addConstraint:[NSLayoutConstraint constraintWithItem:lb_name
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:img_picture
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0]];
            
    
        
     
        
        lb_character=[[UILabel alloc]init];
        lb_character.text =[NSString stringWithFormat:@"%@%@",@"- ",[Character objectAtIndex:i]];
        lb_character.textColor = [UIColor colorWithRed:130.0/255.0 green:129.0/255.0 blue:128.0/255.0 alpha:1.0];
        lb_character.font = [UIFont italicSystemFontOfSize:10.0f];
        
        
        [cast_view addSubview:lb_character];
        
        cast_view.translatesAutoresizingMaskIntoConstraints = NO;
        lb_character.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [cast_view addConstraint:[NSLayoutConstraint constraintWithItem:lb_character
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:cast_view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:70]];
        
        [cast_view addConstraint:[NSLayoutConstraint constraintWithItem:lb_character
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:lb_name
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0]];
        
    }


    
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

-(void)rating
{

    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",@"http://api.themoviedb.org/3/movie/264660/rating?guest_session_id=",[guest_id objectAtIndex:0],@"&api_key=ea793354ae0aae7ec17fd6d6f5f692a2"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *post = [[NSString alloc] initWithFormat:@"%@%@%@",@"{\n  \"value\": ",ocena,@"}"];
    
    
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];

    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (error) {
                                          // Handle error...
                                          return;
                                      }
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                          NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }
                                      
                                      NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response Body:\n%@\n", body);
                                
                                      
                                     
                                  }];
    [task resume];
    
    
   
}

-(void)guest
{
    

    NSURL *URL = [NSURL URLWithString:@"http://api.themoviedb.org/3/authentication/guest_session/new?api_key=ea793354ae0aae7ec17fd6d6f5f692a2"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (error) {
                                          // Handle error...
                                          return;
                                      }
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                          NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }
                                      
                                      NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSError *err = nil;

                                      NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];

                                      NSLog(@"Response Body:\n%@\n", body);
                                      
                                      guest_id = [[NSMutableArray alloc]init];
                                      [guest_id addObject:[dictResponse objectForKey:@"guest_session_id"]];
                                      
                                      [self rating];

                                  }];
    [task resume];
}

-(void)rate_movie
{

    UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod)];
    UITapGestureRecognizer *newTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod1)];
    UITapGestureRecognizer *newTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod2)];
    UITapGestureRecognizer *newTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod3)];
    UITapGestureRecognizer *newTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod4)];
    UITapGestureRecognizer *newTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod5)];
    UITapGestureRecognizer *newTap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod6)];
    UITapGestureRecognizer *newTap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod7)];
    UITapGestureRecognizer *newTap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod8)];
    UITapGestureRecognizer *newTap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod9)];

    
    [star1 setUserInteractionEnabled:YES];
    [star2 setUserInteractionEnabled:YES];
    [star3 setUserInteractionEnabled:YES];
    [star4 setUserInteractionEnabled:YES];
    [star5 setUserInteractionEnabled:YES];
    [star6 setUserInteractionEnabled:YES];
    [star7 setUserInteractionEnabled:YES];
    [star8 setUserInteractionEnabled:YES];
    [star9 setUserInteractionEnabled:YES];
    [star10 setUserInteractionEnabled:YES];
    
    [star1 addGestureRecognizer:newTap];
    [star2 addGestureRecognizer:newTap1];
    [star3 addGestureRecognizer:newTap2];
    [star4 addGestureRecognizer:newTap3];
    [star5 addGestureRecognizer:newTap4];
    [star6 addGestureRecognizer:newTap5];
    [star7 addGestureRecognizer:newTap6];
    [star8 addGestureRecognizer:newTap7];
    [star9 addGestureRecognizer:newTap8];
    [star10 addGestureRecognizer:newTap9];




}
NSString *ocena=0;

-(void)myTapMethod{
    
    star1.image = [UIImage imageNamed:@"star_on.png"];
    star2.image = [UIImage imageNamed:@"star.png"];
    star3.image = [UIImage imageNamed:@"star.png"];
    star4.image = [UIImage imageNamed:@"star.png"];
    star5.image = [UIImage imageNamed:@"star.png"];
    star6.image = [UIImage imageNamed:@"star.png"];
    star7.image = [UIImage imageNamed:@"star.png"];
    star8.image = [UIImage imageNamed:@"star.png"];
    star9.image = [UIImage imageNamed:@"star.png"];
    star10.image = [UIImage imageNamed:@"star.png"];
    ocena = @"1";
    if(rate_m == 1)
    {
        rate_m = 0;
    }
    else
    [self guest];
    

}
-(void)myTapMethod1{
    
    star1.image = [UIImage imageNamed:@"star_on.png"];
    star2.image = [UIImage imageNamed:@"star_on.png"];
    star3.image = [UIImage imageNamed:@"star.png"];
    star4.image = [UIImage imageNamed:@"star.png"];
    star5.image = [UIImage imageNamed:@"star.png"];
    star6.image = [UIImage imageNamed:@"star.png"];
    star7.image = [UIImage imageNamed:@"star.png"];
    star8.image = [UIImage imageNamed:@"star.png"];
    star9.image = [UIImage imageNamed:@"star.png"];
    star10.image = [UIImage imageNamed:@"star.png"];
    ocena = @"2";
    if(rate_m == 1)
    {
        rate_m = 0;
    }
    else
        [self guest];
}-(void)myTapMethod2{
    
    star1.image = [UIImage imageNamed:@"star_on.png"];
    star2.image = [UIImage imageNamed:@"star_on.png"];
    star3.image = [UIImage imageNamed:@"star_on.png"];
    star4.image = [UIImage imageNamed:@"star.png"];
    star5.image = [UIImage imageNamed:@"star.png"];
    star6.image = [UIImage imageNamed:@"star.png"];
    star7.image = [UIImage imageNamed:@"star.png"];
    star8.image = [UIImage imageNamed:@"star.png"];
    star9.image = [UIImage imageNamed:@"star.png"];
    star10.image = [UIImage imageNamed:@"star.png"];
    ocena = @"3";
    if(rate_m == 1)
    {
        rate_m = 0;
    }
    else
        [self guest];
}-(void)myTapMethod3{
    
    star1.image = [UIImage imageNamed:@"star_on.png"];
    star2.image = [UIImage imageNamed:@"star_on.png"];
    star3.image = [UIImage imageNamed:@"star_on.png"];
    star4.image = [UIImage imageNamed:@"star_on.png"];
    star5.image = [UIImage imageNamed:@"star.png"];
    star6.image = [UIImage imageNamed:@"star.png"];
    star7.image = [UIImage imageNamed:@"star.png"];
    star8.image = [UIImage imageNamed:@"star.png"];
    star9.image = [UIImage imageNamed:@"star.png"];
    star10.image = [UIImage imageNamed:@"star.png"];
    ocena = @"4";
    if(rate_m == 1)
    {
        rate_m = 0;
    }
    else
        [self guest];
}-(void)myTapMethod4{
    
    star1.image = [UIImage imageNamed:@"star_on.png"];
    star2.image = [UIImage imageNamed:@"star_on.png"];
    star3.image = [UIImage imageNamed:@"star_on.png"];
    star4.image = [UIImage imageNamed:@"star_on.png"];
    star5.image = [UIImage imageNamed:@"star_on.png"];
    star6.image = [UIImage imageNamed:@"star.png"];
    star7.image = [UIImage imageNamed:@"star.png"];
    star8.image = [UIImage imageNamed:@"star.png"];
    star9.image = [UIImage imageNamed:@"star.png"];
    star10.image = [UIImage imageNamed:@"star.png"];
    ocena = @"5";
    if(rate_m == 1)
    {
        rate_m = 0;
    }
    else
        [self guest];
}-(void)myTapMethod5{
    
    star1.image = [UIImage imageNamed:@"star_on.png"];
    star2.image = [UIImage imageNamed:@"star_on.png"];
    star3.image = [UIImage imageNamed:@"star_on.png"];
    star4.image = [UIImage imageNamed:@"star_on.png"];
    star5.image = [UIImage imageNamed:@"star_on.png"];
    star6.image = [UIImage imageNamed:@"star_on.png"];
    star7.image = [UIImage imageNamed:@"star.png"];
    star8.image = [UIImage imageNamed:@"star.png"];
    star9.image = [UIImage imageNamed:@"star.png"];
    star10.image = [UIImage imageNamed:@"star.png"];
    ocena = @"6";
    if(rate_m == 1)
    {
        rate_m = 0;
    }
    else
        [self guest];
}-(void)myTapMethod6{
    
    star1.image = [UIImage imageNamed:@"star_on.png"];
    star2.image = [UIImage imageNamed:@"star_on.png"];
    star3.image = [UIImage imageNamed:@"star_on.png"];
    star4.image = [UIImage imageNamed:@"star_on.png"];
    star5.image = [UIImage imageNamed:@"star_on.png"];
    star6.image = [UIImage imageNamed:@"star_on.png"];
    star7.image = [UIImage imageNamed:@"star_on.png"];
    star8.image = [UIImage imageNamed:@"star.png"];
    star9.image = [UIImage imageNamed:@"star.png"];
    star10.image = [UIImage imageNamed:@"star.png"];
    ocena = @"7";
    if(rate_m == 1)
    {
        rate_m = 0;
    }
    else
        [self guest];
}
-(void)myTapMethod7{
    
    star1.image = [UIImage imageNamed:@"star_on.png"];
    star2.image = [UIImage imageNamed:@"star_on.png"];
    star3.image = [UIImage imageNamed:@"star_on.png"];
    star4.image = [UIImage imageNamed:@"star_on.png"];
    star5.image = [UIImage imageNamed:@"star_on.png"];
    star6.image = [UIImage imageNamed:@"star_on.png"];
    star7.image = [UIImage imageNamed:@"star_on.png"];
    star8.image = [UIImage imageNamed:@"star_on.png"];
    star9.image = [UIImage imageNamed:@"star.png"];
    star10.image = [UIImage imageNamed:@"star.png"];
    ocena = @"8";
    if(rate_m == 1)
    {
        rate_m = 0;
    }
    else
        [self guest];
}
-(void)myTapMethod8{
    
    star1.image = [UIImage imageNamed:@"star_on.png"];
    star2.image = [UIImage imageNamed:@"star_on.png"];
    star3.image = [UIImage imageNamed:@"star_on.png"];
    star4.image = [UIImage imageNamed:@"star_on.png"];
    star5.image = [UIImage imageNamed:@"star_on.png"];
    star6.image = [UIImage imageNamed:@"star_on.png"];
    star7.image = [UIImage imageNamed:@"star_on.png"];
    star8.image = [UIImage imageNamed:@"star_on.png"];
    star9.image = [UIImage imageNamed:@"star_on.png"];
    star10.image = [UIImage imageNamed:@"star.png"];
    ocena = @"9";
    if(rate_m == 1)
    {
        rate_m = 0;
    }
    else
        [self guest];
}
-(void)myTapMethod9{
    
    star1.image = [UIImage imageNamed:@"star_on.png"];
    star2.image = [UIImage imageNamed:@"star_on.png"];
    star3.image = [UIImage imageNamed:@"star_on.png"];
    star4.image = [UIImage imageNamed:@"star_on.png"];
    star5.image = [UIImage imageNamed:@"star_on.png"];
    star6.image = [UIImage imageNamed:@"star_on.png"];
    star7.image = [UIImage imageNamed:@"star_on.png"];
    star8.image = [UIImage imageNamed:@"star_on.png"];
    star9.image = [UIImage imageNamed:@"star_on.png"];
    star10.image = [UIImage imageNamed:@"star_on.png"];
    ocena = @"10";
    if(rate_m == 1)
    {
        rate_m = 0;
    }
    else
        [self guest];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
