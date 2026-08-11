#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"=== 2. Objective-C 面向对象与消息发送 ===");
        Person *p = [[Person alloc] initWithName:@"李四" age:30];
        [p sayHello];
    }
    return 0;
}
