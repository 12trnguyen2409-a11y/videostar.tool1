#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%ctor {
    // Đợi app load xong 2 giây rồi hiện thông báo
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tool Cấy Thành Công" message:@"Chúc mừng! Bạn đã nhúng được code vào Video Star." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
