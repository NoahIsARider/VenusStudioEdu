#!/usr/bin/perl
# =====================================================
# 03-functions/functions.pl
# Perl 函数（子例程）
# =====================================================
use strict;
use warnings;
use feature 'say';
use feature 'signatures';
no warnings 'experimental::signatures';
use feature 'state';             # 启用静态局部变量

# 传统方式：使用 @_ 访问参数
sub traditional_add {
    my ($a, $b) = @_;
    return $a + $b;
}

# 现代方式：参数签名
sub modern_add($a, $b) {
    return $a + $b;
}

# 带默认值
sub greet($name, $greeting = "你好") {
    return "$greeting，$name！";
}

sub demo_functions {
    say "\n=== 1. 函数定义与调用 ===";

    say "传统方式 add(3, 5) = ", traditional_add(3, 5);
    say "现代方式 add(3, 5) = ", modern_add(3, 5);
    say "带默认参数 greet('小明') = ", greet("小明");
    say "覆盖默认参数 greet('小明', 'Hello') = ", greet("小明", "Hello");

    say "\n=== 2. 返回多个值 ===";

    my ($sum, $product) = compute_two(4, 5);
    say "compute_two(4,5) -> 和: $sum, 积: $product";

    say "\n=== 3. 返回引用（引用传递） ===";

    my $list_ref = make_list(1, 2, 3, 4);
    say "返回的列表引用: @$list_ref";

    say "\n=== 4. 可变参数 ===";

    say "sum(1..10) = ", sum_all(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

    say "\n=== 5. 作用域与变量（my / our / local） ===";

    my $outer = 100;
    demo_scope();
    say "外层 my 变量不受函数内影响: $outer";

    say "\n=== 6. 闭包（Closure） ===";

    my $counter = create_counter();
    say "计数器: ", $counter->(), $counter->(), $counter->();
    my $counter2 = create_counter();
    say "独立计数器: ", $counter2->();

    say "\n=== 7. 函数引用（回调） ===";

    my $result = apply_operation(6, 3, sub { $_[0] + $_[1] });
    say "回调加法: $result";
    my $mult = apply_operation(6, 3, sub { $_[0] * $_[1] });
    say "回调乘法: $mult";

    say "\n=== 8. 递归 ===";

    say "factorial(10) = ", factorial(10);
    say "fibonacci(10) = ", fibonacci(10);

    say "\n=== 9. wantarray 上下文感知 ===";

    my @list = context_demo();
    my $scalar = context_demo();
    say "列表上下文: @list";
    say "标量上下文: $scalar";

    say "\n=== 10. state 变量（静态局部变量） ===";

    # 使用 state 声明持久化变量
    my $state_func = sub {
        state $calls = 0;
        $calls++;
        return $calls;
    };
    say "state 调用: ", $state_func->(), $state_func->(), $state_func->();
}

sub compute_two {
    my ($a, $b) = @_;
    return ($a + $b, $a * $b);
}

sub make_list {
    my @args = @_;
    return \@args;
}

sub sum_all {
    my $total = 0;
    $total += $_ for @_;
    return $total;
}

sub demo_scope {
    my $inner = 50;
    say "函数内 my 变量: $inner";
    # 修改外层变量需要返回值或引用
}

sub create_counter {
    my $count = 0;
    return sub {
        $count++;
        return $count;
    };
}

sub apply_operation {
    my ($a, $b, $callback) = @_;
    return $callback->($a, $b);
}

sub factorial {
    my ($n) = @_;
    return 1 if $n <= 1;
    return $n * factorial($n - 1);
}

sub fibonacci {
    my ($n) = @_;
    return $n if $n <= 1;
    return fibonacci($n - 1) + fibonacci($n - 2);
}

sub context_demo {
    my @items = (10, 20, 30);
    return wantarray ? @items : scalar @items;
}

demo_functions();
