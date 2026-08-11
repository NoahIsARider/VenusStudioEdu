<?php
// =====================================================
// 02-control/control.php
// PHP 控制流：条件与循环
// =====================================================

// PHP 提供完整的控制流语句：if/elseif/else、switch、match、for、while、foreach 等。

function demoControl(): void
{
    echo "\n=== 1. if / elseif / else 条件判断 ===\n";

    $score = 85;

    if ($score >= 90) {
        echo "成绩 $score: 优秀\n";
    } elseif ($score >= 80) {
        echo "成绩 $score: 良好\n";
    } elseif ($score >= 60) {
        echo "成绩 $score: 及格\n";
    } else {
        echo "成绩 $score: 不及格\n";
    }

    // 三元运算符
    $age = 20;
    $status = $age >= 18 ? "成年" : "未成年";
    echo "年龄 $age: $status\n";

    // 简写三元运算符（PHP 5.4+）
    $name = "PHP";
    $label = $name ?: "匿名";   // $name 为真值则取 $name
    echo "标签: $label\n";

    echo "\n=== 2. switch 语句 ===\n";

    $day = 3;
    switch ($day) {
        case 1:
            echo "星期一\n";
            break;
        case 2:
            echo "星期二\n";
            break;
        case 3:
            echo "星期三\n";
            break;
        case 6:
        case 7:
            echo "周末\n";
            break;
        default:
            echo "其他工作日\n";
    }

    echo "\n=== 3. match 表达式（PHP 8.0+） ===\n";

    // match 是表达式，使用严格比较 (===)，必须穷尽或提供 default
    $statusCode = 404;
    $message = match ($statusCode) {
        200, 201 => "成功",
        301, 302 => "重定向",
        404 => "未找到",
        500 => "服务器错误",
        default => "未知状态码",
    };
    echo "状态码 $statusCode: $message\n";

    // match 多条件合并
    $grade = 'B';
    $desc = match ($grade) {
        'A' => "优秀",
        'B', 'C' => "良好",
        'D' => "及格",
        default => "未知等级",
    };
    echo "等级 $grade: $desc\n";

    echo "\n=== 4. for 循环 ===\n";

    // 经典 for 循环
    echo "for 循环 1..5: ";
    for ($i = 1; $i <= 5; $i++) {
        echo $i . " ";
    }
    echo "\n";

    // 带步长的循环
    echo "步长为 2 的循环: ";
    for ($i = 0; $i <= 10; $i += 2) {
        echo $i . " ";
    }
    echo "\n";

    echo "\n=== 5. while 循环 ===\n";

    // while 循环（先判断后执行）
    $n = 5;
    echo "while 倒计时: ";
    while ($n > 0) {
        echo $n . " ";
        $n--;
    }
    echo "\n";

    echo "\n=== 6. do-while 循环 ===\n";

    // do-while 循环（先执行后判断，至少执行一次）
    $m = 1;
    echo "do-while 输出: ";
    do {
        echo $m . " ";
        $m++;
    } while ($m <= 5);
    echo "\n";

    echo "\n=== 7. foreach 循环（遍历数组） ===\n";

    // 遍历索引数组
    $fruits = ["苹果", "香蕉", "橙子"];
    echo "遍历索引数组:\n";
    foreach ($fruits as $index => $fruit) {
        echo "  [$index] $fruit\n";
    }

    // 遍历关联数组
    $person = ["name" => "张三", "age" => 30, "city" => "北京"];
    echo "遍历关联数组:\n";
    foreach ($person as $key => $value) {
        echo "  $key => $value\n";
    }

    echo "\n=== 8. break 与 continue ===\n";

    // break 跳出循环
    echo "break 示例（遇到 3 即停止）: ";
    for ($i = 1; $i <= 10; $i++) {
        if ($i == 3) {
            break;
        }
        echo $i . " ";
    }
    echo "\n";

    // continue 跳过本次迭代
    echo "continue 示例（跳过偶数）: ";
    for ($i = 1; $i <= 10; $i++) {
        if ($i % 2 == 0) {
            continue;
        }
        echo $i . " ";
    }
    echo "\n";

    // break 带层级（跳出多层循环）
    echo "break 2 示例（跳出双层循环）:\n";
    for ($i = 1; $i <= 3; $i++) {
        for ($j = 1; $j <= 3; $j++) {
            if ($i == 2 && $j == 2) {
                break 2;   // 跳出两层循环
            }
            echo "  ($i,$j)";
        }
    }
    echo "\n";
}
