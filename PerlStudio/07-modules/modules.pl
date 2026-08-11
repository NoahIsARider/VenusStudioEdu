#!/usr/bin/perl
# =====================================================
# 07-modules/modules.pl
# Perl 模块使用：use 与包
# =====================================================
use strict;
use warnings;
use feature 'say';

# 添加当前脚本所在目录到 @INC（使用 __FILE__ 保证独立运行与 do 加载都正确）
use File::Basename qw(dirname);
use lib dirname(__FILE__);

use MyUtils;               # 默认导出 add, is_even
use MyUtils qw( factorial divide PI E create_counter get_secret_message );

sub demo_modules {
    say "\n=== 1. use 导入模块 ===";

    say "默认导出 add(10, 5) = ", add(10, 5);
    say "默认导出 is_even(7) = ", (is_even(7) ? "偶数" : "奇数");

    say "\n=== 2. 显式导出符号 ===";

    say "factorial(5) = ", factorial(5);
    say "divide(10, 4) = ", divide(10, 4);
    say "常量 PI = ", PI;
    say "常量 E = ", E;

    say "\n=== 3. 使用 CPAN 内置模块 ===";

    # List::Util 常用函数
    use List::Util qw(max min sum shuffle);
    my @nums = (3, 7, 1, 9, 4);
    say "最大值: ", max(@nums);
    say "最小值: ", min(@nums);
    say "总和: ", sum(@nums);

    # Scalar::Util
    use Scalar::Util qw(blessed looks_like_number);
    my $str = "abc";
    say "'abc' 是否为数字: ", (looks_like_number($str) ? "是" : "否");
    my $num = 42;
    say "42 是否为数字: ", (looks_like_number($num) ? "是" : "否");

    say "\n=== 4. 模块私有函数 ===";

    say "通过接口获取私有信息: ", get_secret_message();

    say "\n=== 5. 闭包从模块导出 ===";

    my $counter = create_counter();
    say "模块导出的计数器: ", $counter->(), $counter->(), $counter->();

    say "\n=== 6. 错误处理与 eval ===";

    # eval 捕获异常
    eval {
        divide(10, 0);
    };
    if ($@) {
        say "捕获到异常: ", $@;
    }

    say "\n=== 7. 命名空间检查 ===";

    say "MyUtils 包中是否有 factorial: ",
        (MyUtils->can("factorial") ? "是" : "否");
    say "当前包名: ", __PACKAGE__;
}

demo_modules();
