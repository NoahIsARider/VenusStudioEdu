#!/usr/bin/perl
# =====================================================
# 06-oop/oop.pl
# Perl 面向对象编程（基于 bless 的经典方式）
# =====================================================
use strict;
use warnings;
use feature 'say';
use Data::Dumper;

# === 定义一个类 ===
# Perl 的类就是一个包（package），对象是 bless 的引用

{
    package Animal;
    # 构造函数
    sub new {
        my ($class, %args) = @_;
        my $self = { name => $args{name} || "未知", sound => $args{sound} || "..." };
        bless $self, $class;
        return $self;
    }

    # 方法
    sub speak {
        my ($self) = @_;
        return "$self->{name} 发出声音: $self->{sound}";
    }

    # 访问器
    sub get_name {
        my ($self) = @_;
        return $self->{name};
    }

    sub set_name {
        my ($self, $new_name) = @_;
        $self->{name} = $new_name;
        return $self->{name};
    }
}

# === 继承 ===
{
    package Dog;
    our @ISA = ("Animal");   # 通过 @ISA 数组实现继承

    sub new {
        my ($class, %args) = @_;
        $args{sound} //= "汪汪";
        my $self = Animal::new($class, %args);
        return $self;
    }

    # 覆写父类方法
    sub speak {
        my ($self) = @_;
        return "$self->{name} 摇着尾巴说: " . $self->{sound} . "！";
    }

    # 新增方法
    sub fetch {
        my ($self) = @_;
        return "$self->{name} 跑过去把球叼回来了";
    }
}

sub demo_oop {
    say "\n=== 1. 创建对象 ===";

    my $animal = Animal->new(name => "小猫", sound => "喵喵");
    say $animal->speak();
    say "名字: ", $animal->get_name();

    say "\n=== 2. 访问器（getter/setter） ===";

    say "设置新名字: ", $animal->set_name("小花猫");
    say $animal->speak();

    say "\n=== 3. 继承 ===";

    my $dog = Dog->new(name => "旺财");
    say $dog->speak();
    say $dog->fetch();

    say "\n=== 4. 引用类型检查 ===";

    say "对象类型: ", ref($dog);
    say "is_a Animal: ", ($dog->isa("Animal") ? "是" : "否");
    say "can speak: ", ($dog->can("speak") ? "是" : "否");

    say "\n=== 5. 多态 ===";

    my $poly = Animal->new(name => "母鸡", sound => "咯咯");
    for my $obj ($animal, $dog, $poly) {
        say $obj->speak();
    }

    say "\n=== 6. 类属性与类方法 ===";

    {
        package Counter;
        our $total_instances = 0;   # 类属性

        sub new {
            my ($class) = @_;
            my $self = { id => ++$total_instances };
            bless $self, $class;
            return $self;
        }

        sub get_id {
            my ($self) = @_;
            return $self->{id};
        }

        # 类方法（第一个参数是类名）
        sub get_total {
            my ($class) = @_;
            return $class . " 的实例总数: $total_instances";
        }
    }

    my $c1 = Counter->new();
    my $c2 = Counter->new();
    my $c3 = Counter->new();
    say "c1 id: ", $c1->get_id();
    say "c3 id: ", $c3->get_id();
    say Counter->get_total();

    say "\n=== 7. 对象存储结构 ===";

    print Dumper($dog);
}

demo_oop();
