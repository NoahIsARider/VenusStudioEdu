#!/usr/bin/perl
# =====================================================
# 05-regex/regex.pl
# Perl 正则表达式（Perl 的强项）
# =====================================================
use strict;
use warnings;
use feature 'say';

sub demo_regex {
    say "\n=== 1. 匹配运算符 m// ===";

    my $text = "The quick brown fox jumps over the lazy dog";
    say "文本: $text";

    # 基础匹配
    say "是否包含 'quick': ", ($text =~ /quick/ ? "是" : "否");
    say "是否包含 'cat': ", ($text =~ /cat/ ? "是" : "否");

    # ^ 行首，$ 行尾
    say "以 The 开头: ", ($text =~ /^The/ ? "是" : "否");
    say "以 dog 结尾: ", ($text =~ /dog$/ ? "是" : "否");

    # 字符类
    say "包含数字: ", ($text =~ /[0-9]/ ? "是" : "否");
    my $alphanumeric = "abc123";
    say "alphanumeric 是字母数字: ", ($alphanumeric =~ /^[a-zA-Z0-9]+$/ ? "是" : "否");

    say "\n=== 2. 捕获组 () ===";

    my $email = 'user123@example.com';
    if ($email =~ /^([a-z0-9]+)@([a-z]+\.[a-z]+)$/) {
        say "用户名: $1";
        say "域名: $2";
    }

    # 命名捕获（Perl 5.10+）
    if ($email =~ /^(?<user>[a-z0-9]+)@(?<domain>[a-z]+\.[a-z]+)$/) {
        say "命名捕获用户名: $+{user}";
        say "命名捕获域名: $+{domain}";
    }

    say "\n=== 3. 替换 s/// ===";

    my $sentence = "I love programming in Perl";
    $sentence =~ s/Perl/Perl 5/;
    say "替换后: $sentence";

    # 全局替换
    my $repeat = "a b c a b c";
    $repeat =~ s/a/X/g;
    say "全局替换: $repeat";

    # 大小写转换
    my $lower = "hello world";
    $lower =~ s/(\w+)/\u$1/g;   # \u 首字母大写
    say "首字母大写: $lower";

    say "\n=== 4. 提取所有匹配 ===";

    my $numbers = "价格: 12.5元, 优惠: 3.8元, 运费: 2.0元";
    my @prices = ($numbers =~ /([\d.]+)元/g);
    say "提取的价格: @prices";

    # 提取单词
    my $words = "one two three";
    my @word_list = ($words =~ /(\w+)/g);
    say "提取单词: @word_list";

    say "\n=== 5. 量词 ===";

    # * 0或多个, + 1或多个, ? 0或1个, {n,m} n到m个
    my @tests = ("", "a", "ab", "aabb", "bbb");
    for my $t (@tests) {
        my $match = $t =~ /^a*b*$/ ? "匹配" : "不匹配";
        say "a*b* 匹配 '$t': $match";
    }

    # 贪婪 vs 懒惰
    my $html = "<b>粗体</b>和<b>更多</b>";
    $html =~ /<b>(.*)<\/b>/;
    say "贪婪匹配: $1";
    $html =~ /<b>(.*?)<\/b>/;
    say "懒惰匹配: $1";

    say "\n=== 6. 常用字符类简写 ===";

    my $sample = "Hello, World! 123";
    my @words_found = ($sample =~ /\w+/g);
    my @digits_found = ($sample =~ /\d+/g);
    say "单词（\\w+）: @words_found";
    say "数字（\\d+）: @digits_found";
    say "空白数量: ", scalar (($sample =~ /\s/g));

    say "\n=== 7. 条件匹配与交替 ===";

    my @colors = ("red", "green", "blue", "yellow");
    for my $c (@colors) {
        my $family = $c =~ /^(red|blue)$/ ? "冷色" : "其他";
        say "$c: $family";
    }

    say "\n=== 8. 替换中的表达式 ===";

    my $temp_f = 72;
    my $result = "温度是 72F";
    $result =~ s{(\d+)F}{ ($1 - 32) * 5 / 9 }e;   # /e 执行表达式
    say "华氏转摄氏结果: $result 摄氏度";

    say "\n=== 9. 正则分组与非捕获 ===";

    my $date = "2024-03-15";
    if ($date =~ /^(?:\d{4})-(\d{2})-(\d{2})$/) {
        say "月: $1, 日: $2（年份用非捕获组）";
    }

    say "\n=== 10. 校验示例 ===";

    my @phones = ("138-1234-5678", "12345", "abc-defg-hijk");
    for my $phone (@phones) {
        if ($phone =~ /^\d{3}-\d{4}-\d{4}$/) {
            say "手机号格式正确: $phone";
        } else {
            say "手机号格式错误: $phone";
        }
    }
}

demo_regex();
