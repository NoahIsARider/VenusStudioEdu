#!/usr/bin/perl
# =====================================================
# 01-basics/variables.pl
# Perl 变量与数据类型基础
# =====================================================
use strict;
use warnings;
use feature 'say';

sub demo_variables {
    say "\n=== 1. 标量变量（Scalar） ===";

    # Perl 变量用符号前缀标识：$ 标量，@ 数组，% 哈希
    my $name = "PerlStudio";
    my $version = 5.40;
    my $count = 42;
    my $is_open = 1;          # 0 为假
    my $nothing = undef;      # 未定义值

    say "字符串: $name";
    say "浮点数: $version";
    say "整数: $count";
    say "布尔: $is_open";
    say "undef 值: ", (defined $nothing ? "已定义" : "未定义");

    say "\n=== 2. 三种主要变量类型 ===";

    # 标量 $
    my $city = "北京";

    # 数组 @
    my @fruits = ("苹果", "香蕉", "橙子");

    # 哈希 %（键值对）
    my %config = (
        name    => "PerlStudio",
        version => 5.40,
        open    => 1,
    );

    say "标量: \$city = $city";
    say "数组: \@fruits[0] = $fruits[0]";
    say "哈希: \$config{name} = $config{name}";

    say "\n=== 3. 运算符 ===";

    # 算术运算符
    say "加法: 10 + 3 = ", 10 + 3;
    say "减法: 10 - 3 = ", 10 - 3;
    say "乘法: 10 * 3 = ", 10 * 3;
    say "除法: 10 / 3 = ", 10 / 3;
    say "取模: 10 % 3 = ", 10 % 3;
    say "幂: 10 ** 2 = ", 10 ** 2;

    # 字符串运算符
    say "字符串连接: ", "Hello" . " " . "Perl";
    say "字符串重复: ", "-" x 10;

    # 数值比较 vs 字符串比较
    say "数值比较 10 > 3: ", (10 > 3 ? "真" : "假");
    say "字符串比较 'apple' lt 'banana': ", ('apple' lt 'banana' ? "真" : "假");

    say "\n=== 4. 上下文（Context） ===";

    # Perl 的标量上下文和列表上下文
    my @array = (1, 2, 3, 4, 5);
    my $size = @array;              # 标量上下文：返回元素个数
    say "数组元素个数（标量上下文）: $size";

    my @copy = @array;              # 列表上下文：复制数组
    say "列表上下文复制: @copy";

    # 布尔上下文
    say "非空数组在布尔上下文为真: ", (@array ? "真" : "假");

    say "\n=== 5. 字符串插值与转义 ===";

    my $interpolated = "变量插值: 城市是 $city";
    my $single_quoted = '单引号不插值: $city';
    say $interpolated;
    say $single_quoted;

    say "\n=== 6. 变量作用域 ===";

    my $outer = "外层变量";
    {
        my $inner = "内层变量";
        say "内层可见: $inner";
        say "外层可见: $outer";
    }
    # $inner 在这里不可见（离开代码块作用域结束）
    say "外层变量仍然可见: $outer";

    say "\n=== 7. 数字与字符串互转 ===";

    my $num_str = "123";
    my $result = $num_str + 5;      # 自动转换为数字
    say "\"123\" + 5 = $result";

    my $str = 100 . "美元";          # 数字连接字符串
    say "100 . \"美元\" = $str";
}

demo_variables();
