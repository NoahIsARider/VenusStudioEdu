#!/usr/bin/perl
# =====================================================
# 02-control/control.pl
# Perl 控制流：条件、循环、修饰符
# =====================================================
use strict;
use warnings;
use feature 'say';

sub demo_control {
    say "\n=== 1. if / elsif / else ===";

    my $score = 85;
    if ($score >= 90) {
        say "成绩等级: A";
    } elsif ($score >= 80) {
        say "成绩等级: B";
    } elsif ($score >= 60) {
        say "成绩等级: C";
    } else {
        say "成绩等级: D";
    }

    say "\n=== 2. unless（if 的反向） ===";

    my $is_member = 0;
    unless ($is_member) {
        say "不是会员，需要购买门票";
    }

    say "\n=== 3. 三目运算符 ===";

    my $age = 18;
    my $status = $age >= 18 ? "成年" : "未成年";
    say "年龄 $age 岁: $status";

    say "\n=== 4. for 循环（C 风格） ===";

    for (my $i = 1; $i <= 5; $i++) {
        print "$i ";
    }
    print "\n";

    say "\n=== 5. foreach 遍历 ===";

    my @colors = ("红", "绿", "蓝");
    foreach my $color (@colors) {
        print "$color ";
    }
    print "\n";

    # foreach 和 for 是同一个关键字
    for my $n (1..5) {
        print "$n ";
    }
    print "\n";

    # 带索引遍历
    my @names = ("张三", "李四", "王五");
    for my $i (0 .. $#names) {
        say "第 $i 个: $names[$i]";
    }

    say "\n=== 6. while / until 循环 ===";

    my $count = 1;
    while ($count <= 3) {
        print "while: $count ";
        $count++;
    }
    print "\n";

    my $n = 3;
    until ($n <= 0) {   # 条件为假时继续
        print "until: $n ";
        $n--;
    }
    print "\n";

    say "\n=== 7. 语句修饰符（尾缀写法） ===";

    my $i = 0;
    print "修饰符 for: " if 0;
    print "尾缀条件 ";
    print "执行了" if $i == 0;
    print "\n";

    # while 作为修饰符
    my $x = 5;
    print "修饰符 while 执行 ", "a" x $x, "\n" if $x > 0;

    say "\n=== 8. last / next / redo ===";

    # last = break
    for my $i (1 .. 10) {
        last if $i == 4;
        print "$i ";
    }
    print "（last 跳出）\n";

    # next = continue
    for my $i (1 .. 8) {
        next if $i % 2 == 0;   # 跳过偶数
        print "$i ";
    }
    print "（next 跳过偶数）\n";

    # redo 重新执行当前迭代
    my $attempts = 0;
    my $j = 0;
    while ($j < 3) {
        $attempts++;
        if ($attempts < 3 && $j == 0) {
            print "第 ${attempts} 次尝试失败，redo 重试 ";
            redo;
        }
        $j++;
        print "迭代 $j (尝试 $attempts) ";
    }
    print "\n";

    say "\n=== 9. 标签（Label）控制嵌套循环 ===";

    OUTER: for my $row (1 .. 3) {
        for my $col (1 .. 3) {
            next OUTER if $row == $col;  # 跳过对角
            print "$row,$col ";
        }
    }
    print "\n";

    say "\n=== 10. 多条件分支 ===";

    my $day = "Monday";
    if    ($day =~ /^Mon/) { say "$day 是星期一" }
    elsif ($day =~ /^Tue/) { say "$day 是星期二" }
    elsif ($day =~ /^Wed/) { say "$day 是星期三" }
    else                   { say "$day 是其他日子" }

    # 使用列表判断简化比较（避免实验性智能匹配警告）
    my $fruit = "apple";
    my @favorites = ("apple", "banana");
    my $is_favorite = grep { $_ eq $fruit } @favorites ? "是" : "否";
    say "apple 是否在喜爱列表: $is_favorite";
}

demo_control();
