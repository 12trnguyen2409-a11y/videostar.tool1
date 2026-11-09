#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tool Cấy Thành Công" message:@"Chúc mừng! Bạn đã nhúng được code vào Video Star." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        // Đoạn sửa lỗi Xcode: Tìm cửa sổ màn hình chính theo cách mới
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }
        
        if (window) {
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}
