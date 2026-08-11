<?php
// =====================================================
// 01-basics/variables.php
// PHP 变量和数据类型基础
// =====================================================

// PHP 是一种弱类型、动态类型语言，变量以 $ 开头，无需声明类型。
// 使用 $ 前缀声明变量，赋值即定义。

function demoVariables(): void
{
    echo "\n=== 1. 变量声明 ===\n";

    // 1. 简单赋值
    $name = "PHPStudio";
    echo "字符串变量: \$name = $name\n";

    // 2. 整数与浮点数
    $version = 8.2;
    $count = 42;
    echo "浮点数: \$version = $version\n";
    echo "整数: \$count = $count\n";

    // 3. 多重赋值（同时赋值多个变量）
    [$a, $b, $c] = [1, 2, 3];
    echo "多重赋值: a = $a, b = $b, c = $c\n";

    // 4. 变量交换（PHP 使用 list/解构交换，无需临时变量）
    [$a, $b] = [$b, $a];
    echo "交换后: a = $a, b = $b\n";

    // 5. 未初始化的变量访问会触发警告（E_WARNING），值为 null
    $nothing = null;
    echo "null 变量: " . var_export($nothing, true) . "\n";

    echo "\n=== 2. 数据类型 ===\n";

    // PHP 基本类型：int、float、string、bool、array、null、object、callable
    $integer = 42;            // 整数
    $float = 3.14159;         // 浮点数
    $text = "你好，PHP！";     // 字符串
    $boolean = true;          // 布尔
    $empty = null;            // null
    $arr = [1, 2, 3];         // 数组

    echo "整数: $integer, 类型: " . gettype($integer) . "\n";
    echo "浮点: $float, 类型: " . gettype($float) . "\n";
    echo "字符串: $text, 类型: " . gettype($text) . "\n";
    echo "布尔: " . var_export($boolean, true) . ", 类型: " . gettype($boolean) . "\n";
    echo "null: " . var_export($empty, true) . ", 类型: " . gettype($empty) . "\n";
    echo "数组: " . var_export($arr, true) . ", 类型: " . gettype($arr) . "\n";

    echo "\n=== 3. var_dump 与 print_r 调试输出 ===\n";

    // var_dump 输出类型和值，调试常用
    echo "var_dump 输出:\n";
    var_dump($integer);
    var_dump($text);
    var_dump($arr);

    // print_r 输出易读结构，适合数组和对象
    echo "\nprint_r 输出:\n";
    print_r($arr);

    echo "\n=== 4. 类型自动转换（类型隐式转换） ===\n";

    // PHP 是弱类型，运算时会自动转换类型
    $sum = "10" + 5;          // 字符串转数字相加
    echo "\"10\" + 5 = $sum (类型: " . gettype($sum) . ")\n";

    $concat = 10 . "美元";    // 数字连接字符串
    echo "10 . \"美元\" = $concat (类型: " . gettype($concat) . ")\n";

    // 布尔转换：0、0.0、""、"0"、null、[] 为假，其他为真
    $falsy = "0";
    echo "\"0\" 的布尔值: " . var_export((bool)$falsy, true) . "\n";

    // 显式类型转换
    $str = (string)123;
    $num = (int)"456";
    echo "(string)123 = $str, (int)\"456\" = $num\n";

    echo "\n=== 5. 运算符 ===\n";

    // 算术运算符
    echo "加法 10 + 3 = " . (10 + 3) . "\n";
    echo "减法 10 - 3 = " . (10 - 3) . "\n";
    echo "乘法 10 * 3 = " . (10 * 3) . "\n";
    echo "除法 10 / 3 = " . (10 / 3) . "\n";
    echo "整除 10 ÷ 3 = " . intdiv(10, 3) . "\n";   // 整数除法
    echo "取模 10 % 3 = " . (10 % 3) . "\n";
    echo "幂 10 ** 2 = " . (10 ** 2) . "\n";

    // 关系运算符
    echo "\n关系运算符:\n";
    echo "10 > 3: " . var_export(10 > 3, true) . "\n";
    echo "10 < 3: " . var_export(10 < 3, true) . "\n";
    echo "10 == 3: " . var_export(10 == 3, true) . "\n";
    echo "10 != 3: " . var_export(10 != 3, true) . "\n";
    // === 严格比较（类型和值都相同）
    echo "10 === \"10\": " . var_export(10 === "10", true) . " (严格比较)\n";
    echo "10 == \"10\": " . var_export(10 == "10", true) . " (松散比较)\n";

    // 逻辑运算符
    echo "\n逻辑运算符:\n";
    echo "true && false: " . var_export(true && false, true) . "\n";
    echo "true || false: " . var_export(true || false, true) . "\n";
    echo "!true: " . var_export(!true, true) . "\n";
    // ?? 空合并运算符：左值为 null 时返回右值，常用于设置默认值
    $value = null ?? "默认值";
    echo "null ?? \"默认值\": $value\n";

    // 太空船运算符 <=>（三向比较）
    echo "\n太空船运算符 <=>:\n";
    echo "1 <=> 2 = " . (1 <=> 2) . " (左<右返回-1)\n";
    echo "2 <=> 2 = " . (2 <=> 2) . " (相等返回0)\n";
    echo "3 <=> 2 = " . (3 <=> 2) . " (左>右返回1)\n";

    echo "\n=== 6. 常量 ===\n";

    // 使用 define() 定义常量（运行时）
    define("MAX_SIZE", 100);
    define("APP_NAME", "PHPStudio");
    echo "define() 常量: MAX_SIZE = " . MAX_SIZE . ", APP_NAME = " . APP_NAME . "\n";

    // 使用 const 关键字定义常量（编译时）
    const PI = 3.1415926;
    const VERSION = "8.2";
    echo "const 常量: PI = " . PI . ", VERSION = " . VERSION . "\n";

    // 魔术常量
    echo "\n魔术常量:\n";
    echo "当前文件: " . __FILE__ . "\n";
    echo "当前行号: " . __LINE__ . "\n";
    echo "当前目录: " . __DIR__ . "\n";
}
