#!/usr/bin/perl
# =====================================================
# 07-modules/MyUtils.pm
# Perl 模块定义（被 modules.pl 引用）
# =====================================================
package MyUtils;
use strict;
use warnings;
use Exporter 'import';

# 导出列表：定义可以被外部使用的符号
our @EXPORT_OK = qw(
    add subtract multiply divide
    is_even factorial
    PI E
    create_counter get_secret_message
);

our @EXPORT = qw( add is_even );   # 默认导出

# 常量
use constant PI => 3.14159265;
use constant E  => 2.71828;

sub add {
    my ($a, $b) = @_;
    return $a + $b;
}

sub subtract {
    my ($a, $b) = @_;
    return $a - $b;
}

sub multiply {
    my ($a, $b) = @_;
    return $a * $b;
}

sub divide {
    my ($a, $b) = @_;
    die "除数不能为零\n" if $b == 0;
    return $a / $b;
}

sub is_even {
    my ($n) = @_;
    return $n % 2 == 0 ? 1 : 0;
}

sub factorial {
    my ($n) = @_;
    return 1 if $n <= 1;
    return $n * factorial($n - 1);
}

sub create_counter {
    my $count = 0;
    return sub {
        $count++;
        return $count;
    };
}

# 私有函数（不导出）
sub _private_helper {
    return "模块私有函数";
}

# 通过公开接口暴露
sub get_secret_message {
    return _private_helper();
}

1;   # 模块必须返回真值
