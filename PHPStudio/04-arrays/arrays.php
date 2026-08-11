<?php
// =====================================================
// 04-arrays/arrays.php
// PHP 数组：索引数组、关联数组、多维数组、数组函数
// =====================================================

// PHP 的数组实际上是有序映射，可同时作为索引数组、关联数组、多维数组。

function demoArrays(): void
{
    echo "\n=== 1. 索引数组 ===\n";

    // 索引数组（自动从 0 开始编号）
    $fruits = ["苹果", "香蕉", "橙子"];
    echo "数组: " . implode(", ", $fruits) . "\n";
    echo "第一个元素: " . $fruits[0] . "\n";
    echo "元素个数: " . count($fruits) . "\n";

    // 追加元素
    $fruits[] = "葡萄";
    echo "追加后: " . implode(", ", $fruits) . "\n";

    // 按索引修改
    $fruits[1] = "芒果";
    echo "修改后: " . implode(", ", $fruits) . "\n";

    echo "\n=== 2. 关联数组 ===\n";

    // 关联数组（键值对，类似字典）
    $person = [
        "name" => "张三",
        "age" => 30,
        "city" => "北京",
    ];
    echo "姓名: " . $person["name"] . "\n";
    echo "年龄: " . $person["age"] . "\n";

    // 添加键值对
    $person["email"] = "zhangsan@example.com";
    echo "添加后: " . json_encode($person, JSON_UNESCAPED_UNICODE) . "\n";

    echo "\n=== 3. 多维数组 ===\n";

    // 二维数组（数组中的数组）
    $students = [
        ["name" => "张三", "score" => 90],
        ["name" => "李四", "score" => 85],
        ["name" => "王五", "score" => 78],
    ];

    echo "学生列表:\n";
    foreach ($students as $student) {
        echo "  " . $student["name"] . ": " . $student["score"] . " 分\n";
    }

    // 三维数组
    $matrix = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
    ];
    echo "矩阵 [1][2] = " . $matrix[1][2] . "\n";

    echo "\n=== 4. 数组解构（list / 简写） ===\n";

    // list() 解构
    $point = [10, 20];
    list($x, $y) = $point;
    echo "list 解构: x = $x, y = $y\n";

    // 简写解构（PHP 7.1+）
    [$a, $b] = [100, 200];
    echo "简写解构: a = $a, b = $b\n";

    // 关联数组解构（PHP 7.1+）
    ["name" => $n, "age" => $ag] = $person;
    echo "关联解构: name = $n, age = $ag\n";

    echo "\n=== 5. 数组函数：array_map ===\n";

    $numbers = [1, 2, 3, 4, 5];
    // array_map 对每个元素应用回调
    $doubled = array_map(fn($n) => $n * 2, $numbers);
    echo "array_map 平方: " . implode(", ", array_map(fn($n) => $n ** 2, $numbers)) . "\n";
    echo "array_map 翻倍: " . implode(", ", $doubled) . "\n";

    echo "\n=== 6. 数组函数：array_filter ===\n";

    // array_filter 过滤元素，回调返回真则保留
    $evens = array_filter($numbers, fn($n) => $n % 2 == 0);
    echo "偶数: " . implode(", ", $evens) . "\n";

    // 过滤掉空值
    $mixed = [0, 1, null, "", "a", false, 2];
    $truthy = array_filter($mixed);
    echo "过滤假值: " . implode(", ", $truthy) . "\n";

    echo "\n=== 7. 数组函数：array_reduce ===\n";

    // array_reduce 归纳为单值
    $sum = array_reduce($numbers, fn($carry, $item) => $carry + $item, 0);
    echo "求和: $sum\n";

    $product = array_reduce($numbers, fn($carry, $item) => $carry * $item, 1);
    echo "求积: $product\n";

    echo "\n=== 8. 数组函数：array_merge ===\n";

    // array_merge 合并数组
    $arr1 = [1, 2, 3];
    $arr2 = [4, 5, 6];
    $merged = array_merge($arr1, $arr2);
    echo "合并索引数组: " . implode(", ", $merged) . "\n";

    // 合并关联数组（相同键后者覆盖）
    $defaults = ["host" => "localhost", "port" => 3306, "debug" => false];
    $config = ["port" => 5432, "name" => "mydb"];
    $final = array_merge($defaults, $config);
    echo "合并关联数组: " . json_encode($final, JSON_UNESCAPED_UNICODE) . "\n";

    // + 运算符：相同键保留前者
    $plus = $defaults + $config;
    echo "+ 运算符: " . json_encode($plus, JSON_UNESCAPED_UNICODE) . "\n";

    echo "\n=== 9. 数组排序 ===\n";

    // sort 升序排序（重置键）
    $unsorted = [5, 2, 8, 1, 9, 3];
    sort($unsorted);
    echo "sort 升序: " . implode(", ", $unsorted) . "\n";

    // rsort 降序
    rsort($unsorted);
    echo "rsort 降序: " . implode(", ", $unsorted) . "\n";

    // 关联数组按值排序（保留键）
    $scores = ["张三" => 90, "李四" => 85, "王五" => 78];
    arsort($scores);
    echo "arsort 按值降序:\n";
    foreach ($scores as $name => $score) {
        echo "  $name: $score\n";
    }

    // 按键排序
    ksort($scores);
    echo "ksort 按键升序:\n";
    foreach ($scores as $name => $score) {
        echo "  $name: $score\n";
    }

    echo "\n=== 10. 其他常用数组函数 ===\n";

    $sample = [3, 1, 4, 1, 5, 9, 2, 6];

    echo "count: " . count($sample) . "\n";              // 元素个数
    echo "max: " . max($sample) . "\n";                  // 最大值
    echo "min: " . min($sample) . "\n";                  // 最小值
    echo "array_sum: " . array_sum($sample) . "\n";      // 求和
    echo "in_array(5): " . var_export(in_array(5, $sample), true) . "\n";   // 是否包含
    echo "array_reverse: " . implode(", ", array_reverse($sample)) . "\n"; // 反转
    echo "array_unique: " . implode(", ", array_unique($sample)) . "\n";    // 去重
    echo "array_slice(2,3): " . implode(", ", array_slice($sample, 2, 3)) . "\n"; // 切片

    // 键值操作
    $assoc = ["a" => 1, "b" => 2, "c" => 3];
    echo "array_keys: " . implode(", ", array_keys($assoc)) . "\n";
    echo "array_values: " . implode(", ", array_values($assoc)) . "\n";
    echo "array_flip: " . json_encode(array_flip($assoc)) . "\n";
}
