#!/usr/bin/perl
# =====================================================
# 08-advanced/advanced.pl
# Perl 高级特性：文件 IO、异常处理、引用、特殊变量
# =====================================================
use strict;
use warnings;
use feature 'say';
use File::Temp qw(tempfile);
use File::Spec;

sub demo_advanced {
    say "\n=== 1. 文件读写 ===";

    # 使用临时文件演示
    my ($fh, $filename) = tempfile(SUFFIX => '.txt');
    print $fh "第一行\n第二行\n第三行\n";
    close $fh;

    # 读取文件
    open my $in, '<', $filename or die "无法打开文件: $!";
    my @lines = <$in>;
    close $in;
    say "文件内容 ($filename):";
    print @lines;
    say "文件行数: ", scalar @lines;

    # 写入文件（覆盖模式）
    open my $out, '>', $filename or die "无法写入: $!";
    print $out "新的内容\n";
    close $out;

    # 追加模式
    open my $app, '>>', $filename or die "无法追加: $!";
    print $app "追加的一行\n";
    close $app;

    # 验证结果
    open my $check, '<', $filename or die "无法打开: $!";
    say "追加后的内容:";
    print <$check>;
    close $check;
    unlink $filename;

    say "\n=== 2. 异常处理（eval + die） ===";

    eval {
        die "自定义错误信息";
    };
    if ($@) {
        say "捕获错误: $@";
    }

    # 带行号和上下文的错误
    my $result = guarded_divide(10, 0);
    say "guarded_divide(10, 0) 返回: ", (defined $result ? $result : "失败");
    my $ok_result = guarded_divide(10, 2);
    say "guarded_divide(10, 2) 返回: ", $ok_result;

    # Try::Tiny 风格（内置 eval 足够）
    my @res = eval { (1, 2, 3) };
    say "eval 返回值个数: ", scalar @res;

    say "\n=== 3. 引用的高级用法 ===";

    # 引用的引用
    my $scalar = "hello";
    my $ref = \$scalar;
    my $refref = \$ref;
    say "引用链解引用: $$$refref";

    # 数组哈希混合引用
    my %complex = (
        list    => [1, 2, 3],
        map_ref => { a => 1, b => 2 },
        func    => sub { return "匿名函数" },
    );
    say "复杂结构: ", $complex{list}[0], " ", $complex{map_ref}{b}, " ",
        $complex{func}->();

    say "\n=== 4. 特殊变量 ===";

    # $_ 默认变量
    my @names = ("alice", "bob", "charlie");
    for (@names) {
        $_ = ucfirst;    # 修改默认变量
    }
    say "ucfirst 转换: @names";

    # $! 系统错误
    open my $bad, '<', "/nonexistent/file.txt";
    say "无法打开文件时的 \$! : $!" if !$bad;

    # $0 程序名, $$ 进程 ID
    say "程序名: $0, 进程 ID: $$";

    say "\n=== 5. 排序高级用法 ===";

    my %score = (
        alice   => 85,
        bob     => 92,
        charlie => 78,
        david   => 95,
    );

    # 按键排序
    my @by_name = sort keys %score;
    say "按键排序: @by_name";

    # 按值排序
    my @by_score = sort { $score{$b} <=> $score{$a} } keys %score;
    say "按分数从高到低: @by_score";

    say "\n=== 6. map / grep 函数式操作 ===";

    my @numbers = (1, 2, 3, 4, 5, 6, 7, 8);
    my @squares = map { $_ * $_ } @numbers;
    say "平方: @squares";

    my @evens = grep { $_ % 2 == 0 } @numbers;
    say "偶数: @evens";

    # map 到哈希
    my %square_map = map { $_ => $_ * $_ } @numbers;
    say "map 构建哈希: 4 的平方 = $square_map{4}";

    say "\n=== 7. 时间与日期 ===";

    my ($sec, $min, $hour, $day, $mon, $year) = localtime;
    $mon += 1;
    $year += 1900;
    say "当前时间: $year-$mon-$day $hour:$min:$sec";

    use POSIX qw(strftime);
    say "格式化时间: ", strftime("%Y-%m-%d %H:%M:%S", localtime);

    say "\n=== 8. 命令行参数 ===";

    say "参数个数 (\@ARGV): ", scalar @ARGV;
    say "参数列表: @ARGV" if @ARGV;
}

sub guarded_divide {
    my ($a, $b) = @_;
    return undef if $b == 0;
    return $a / $b;
}

demo_advanced();
