//
//  ViewController.m
//  SampleApp
//
//  Created by matoh on 2015/03/30.
//  Copyright (c) 2015年 iti. All rights reserved.
//

#import "ViewController.h"

//#import <Crashlytics/Crashlytics.h>

#import "AFNetworking.h"


static NSString* const kUrl = @"http://qw136.qhit.net/smbc_nikko/qsearch.exe?F=users/smbc-nikko/mktindex";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[Crashlytics sharedInstance] crash];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.versionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startLoading:(id)sender {
    
    // 1
    NSURL *url = [NSURL URLWithString:kUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            // 3
            NSData *data = responseObject;
            NSString *jsonpData = [[NSString alloc] initWithData:data encoding:NSShiftJISStringEncoding];

            // レスポンス（JSONP）から関数呼び出し部分を取り除いて、JSON文字列を抽出する
            NSError *error = nil;
            NSString *pattern = @"jsoncallMar\\(([\\s\\S]*)\\)";
            NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
            
            // 検索対象の文字列の中から正規表現にマッチした件数分の結果を取得
            NSArray *matchesInString = [expression matchesInString:jsonpData options:0 range:NSMakeRange(0, jsonpData.length)];
            
            // 検索結果を配列に入れる
            NSString *jsonData;
            if (matchesInString.count > 0) {
                NSTextCheckingResult *checkingResult = matchesInString[0];
                jsonData = [jsonpData substringWithRange:[checkingResult rangeAtIndex:1]];
            }
            
            // JSON文字列 → Dictionary
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", dic);
            
            // 適用な指数名を表示してみる
            NSString *key = [NSString stringWithFormat:@"mar_%u", (int)arc4random_uniform(37)+1];
            NSDictionary *sisuDic = [dic valueForKey:key];
            NSMutableString *message = [NSMutableString new];
            [message appendString:[sisuDic valueForKey:@"ri"]];
            [message appendString:@"\n"];
            [message appendString:[sisuDic valueForKey:@"dt"]];
            [message appendString:@"\n"];
            [message appendString:[sisuDic valueForKey:@"la"]];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];

}

@end
