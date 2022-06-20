//
//  Utils.m
//  Stargazers
//
//  Created by Alessandro Giannubilo on 20/06/22.
//

#import "Utils.h"

@implementation Utils

+ (void) showAlertWithTitle:(NSString*)title andMessage:(NSString*)message andViewController:(UIViewController*)controller{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
