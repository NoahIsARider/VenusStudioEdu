<?php
// =====================================================
// 03-functions/functions.php
// PHP 函数：定义、参数、匿名函数、闭包、箭头函数
// =====================================================

// PHP 中函数是一等公民，可赋值、传参、作为返回值。
// PHP 8.0+ 支持命名参数、联合类型等新特性。

function demoFunctions(): void
{
    echo "\n=== 1. 函数定义与调用 ===\n";

    // 基本函数定义，可声明返回类型
    function greet(string $name): string
    {
        return "你好，$name！";
    }
    echo greet("PHP") . "\n";

    // 带类型声明的函数
    function add(int $a, int $b): int
    {
        return $a + $b;
    }
    echo "add(3, 5) = " . add(3, 5) . "\n";

    echo "\n=== 2. 默认参数 ===\n";

    function introduce(string $name, string $role = "开发者", int $age = 25): string
    {
        return "$name，$age 岁，职业: $role";
    }
    echo introduce("张三") . "\n";                       // 使用默认值
    echo introduce("李四", "设计师") . "\n";              // 部分覆盖
    echo introduce("王五", "经理", 40) . "\n";            // 全部传入

    echo "\n=== 3. 可变参数（...） ===\n";

    // ... 收集所有剩余参数为数组
    function sumAll(int ...$numbers): int
    {
        return array_sum($numbers);
    }
    echo "sumAll(1, 2, 3, 4, 5) = " . sumAll(1, 2, 3, 4, 5) . "\n";
    echo "sumAll(10, 20) = " . sumAll(10, 20) . "\n";

    echo "\n=== 4. 命名参数（PHP 8.0+） ===\n";

    // 命名参数：按参数名传值，顺序无关
    echo introduce(name: "赵六", age: 35, role: "架构师") . "\n";
    // 只传部分命名参数，其余用默认值
    echo introduce("钱七", age: 28) . "\n";

    echo "\n=== 5. 匿名函数（闭包） ===\n";

    // 匿名函数赋值给变量
    $multiply = function (int $a, int $b): int {
        return $a * $b;
    };
    echo "匿名函数 multiply(4, 5) = " . $multiply(4, 5) . "\n";

    // 闭包使用 use 捕获外部变量
    $factor = 10;
    $scale = function (int $x) use ($factor): int {
        return $x * $factor;
    };
    echo "闭包捕获 use scale(5) = " . $scale(5) . "\n";

    // 按引用捕获（修改外部变量）
    $counter = 0;
    $increment = function () use (&$counter): void {
        $counter++;
    };
    $increment();
    $increment();
    $increment();
    echo "按引用捕获后 counter = $counter\n";

    echo "\n=== 6. 箭头函数（PHP 7.4+） ===\n";

    // 箭头函数 fn => 自动捕获外部变量（按值）
    $tax = 0.08;
    $calcTax = fn($price) => $price * $tax;
    echo "箭头函数 calcTax(100) = " . $calcTax(100) . "\n";

    // 箭头函数用于数组处理
    $nums = [1, 2, 3, 4, 5];
    $squared = array_map(fn($n) => $n ** 2, $nums);
    echo "平方: " . implode(", ", $squared) . "\n";

    echo "\n=== 7. 函数作为参数（回调） ===\n";

    // 函数可作为参数传递（高阶函数）
    function apply(callable $fn, int $a, int $b): int
    {
        return $fn($a, $b);
    }
    echo "apply(add, 10, 20) = " . apply('add', 10, 20) . "\n";
    echo "apply(匿名函数, 10, 20) = " . apply(function ($x, $y) { return $x - $y; }, 10, 20) . "\n";

    echo "\n=== 8. 函数作为返回值 ===\n";

    // 返回函数（函数工厂）
    function makeMultiplier(int $factor): callable
    {
        return function (int $x) use ($factor): int {
            return $x * $factor;
        };
    }
    $double = makeMultiplier(2);
    $triple = makeMultiplier(3);
    echo "makeMultiplier(2)(5) = " . $double(5) . "\n";
    echo "makeMultiplier(3)(5) = " . $triple(5) . "\n";

    echo "\n=== 9. 变量函数（可变函数） ===\n";

    // 变量名后加 () 可调用对应函数
    $funcName = 'greet';
    echo "变量函数 \$funcName('世界') = " . $funcName("世界") . "\n";
}
