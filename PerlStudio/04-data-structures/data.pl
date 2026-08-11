#!/usr/bin/perl
# =====================================================
# 04-data-structures/data.pl
# Perl 数据结构：数组、哈希、引用
# =====================================================
use strict;
use warnings;
use feature 'say';
eval { require Data::Dumper; Data::Dumper->import(); 1; };
unless (defined &Dumper) {
    *Dumper = sub { my $v = shift; return ref($v) eq 'HASH' ? join(", ", map { "$_ => $v->{$_}" } keys %$v) : (ref($v) eq 'ARRAY' ? "@$v" : $v); };
}

sub demo_data_structures {
    say "\n=== 1. 数组（Array） ===";

    my @fruits = ("苹果", "香蕉", "橙子");
    say "数组内容: @fruits";
    say "第1个元素: $fruits[0]";
    say "最后一个元素: $fruits[-1]";     # 负索引
    say "元素个数: ", scalar @fruits;

    # 添加元素
    push @fruits, "西瓜";                # 尾部添加
    unshift @fruits, "草莓";             # 头部添加
    say "push/unshift 后: @fruits";

    # 删除元素
    my $last = pop @fruits;              # 尾部删除
    my $first = shift @fruits;           # 头部删除
    say "pop 得到: $last, shift 得到: $first";
    say "删除后: @fruits";

    # 切片
    my @slice = @fruits[0, 1];
    say "切片 [0,1]: @slice";

    # 范围
    my @numbers = (1 .. 5);
    say "范围 1..5: @numbers";

    say "\n=== 2. 哈希（Hash） ===";

    my %person = (
        name => "张三",
        age  => 25,
        city => "北京",
    );
    say "person{name}: $person{name}";
    say "person{age}: $person{age}";

    # 添加键值
    $person{occupation} = "工程师";
    say "新增键: $person{occupation}";

    # 删除键值
    delete $person{city};
    say "删除后是否存在 city: ", (exists $person{city} ? "是" : "否");

    # 遍历哈希
    say "遍历键值对:";
    while (my ($key, $value) = each %person) {
        say "  $key => $value";
    }

    # 哈希键列表和值列表
    my @keys = keys %person;
    my @vals = values %person;
    say "所有键: @keys";
    say "所有值: @vals";

    say "\n=== 3. 引用（Reference） ===";

    # 数组引用
    my $array_ref = [1, 2, 3, 4];
    say "数组引用访问: $array_ref->[0], $array_ref->[2]";

    # 哈希引用
    my $hash_ref = { name => "李四", age => 30 };
    say "哈希引用访问: $hash_ref->{name}";

    # 解除引用
    my @deref_array = @$array_ref;
    say "解除引用数组: @deref_array";

    say "\n=== 4. 复杂数据结构 ===";

    # 数组的数组（二维数组）
    my $matrix = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
    ];
    say "matrix[1][2]: $matrix->[1][2]";

    # 数组的哈希
    my $students = [
        { name => "王五", scores => { math => 90, english => 85 } },
        { name => "赵六", scores => { math => 78, english => 95 } },
    ];
    say "王五的数学: $students->[0]{scores}{math}";
    say "赵六的英语: $students->[1]{scores}{english}";

    # 遍历复杂结构
    say "学生列表:";
    for my $student (@$students) {
        my $name = $student->{name};
        my $avg = ($student->{scores}{math} + $student->{scores}{english}) / 2;
        say "  $name 平均分: $avg";
    }

    say "\n=== 5. Data::Dumper 打印结构 ===";

    my $nested = { a => [1, 2], b => { c => 3 } };
    print Dumper($nested);

    say "\n=== 6. 哈希数组排序 ===";

    my @words = ("banana", "apple", "cherry", "date");
    my @sorted = sort @words;
    say "字母排序: @sorted";
    my @sorted_desc = sort { $b cmp $a } @words;
    say "逆序: @sorted_desc";
    my @by_length = sort { length($a) <=> length($b) } @words;
    say "按长度: @by_length";
}

demo_data_structures();
