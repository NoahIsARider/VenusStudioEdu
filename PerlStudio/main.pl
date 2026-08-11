#!/usr/bin/perl
# =====================================================
# main.pl
# PerlStudio 主程序入口，依次运行所有章节
# =====================================================
use strict;
use warnings;
use feature 'say';

print "╔════════════════════════════════════════╗\n";
print "║     欢迎来到 PerlStudio 学习项目！      ║\n";
print "║     Perl 语言完整学习教程               ║\n";
print "╚════════════════════════════════════════╝\n";

my @chapters = (
    ["01. 基础语法",        "01-basics/variables.pl"],
    ["02. 控制流",          "02-control/control.pl"],
    ["03. 函数",            "03-functions/functions.pl"],
    ["04. 数据结构",        "04-data-structures/data.pl"],
    ["05. 正则表达式",      "05-regex/regex.pl"],
    ["06. 面向对象",        "06-oop/oop.pl"],
    ["07. 模块",            "07-modules/modules.pl"],
    ["08. 高级特性",        "08-advanced/advanced.pl"],
);

say "\n================= 教程章节 =================";
for my $ch (@chapters) {
    say "$ch->[0] -> $ch->[1]";
}
say "===========================================";

for my $ch (@chapters) {
    say "\n>>> 开始运行: $ch->[1]";
    do "./$ch->[1]";
    die "无法加载 $ch->[1]: $@\n" if $@;
}

print "\n╔════════════════════════════════════════╗\n";
print "║     PerlStudio 全部章节演示完成！       ║\n";
print "╚════════════════════════════════════════╝\n";
