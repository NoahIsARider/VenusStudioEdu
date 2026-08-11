<?php
// =====================================================
// main.php
// PHPStudio 主程序入口，依次演示所有章节内容
// =====================================================

echo "╔════════════════════════════════════════╗\n";
echo "║     欢迎来到 PHPStudio 学习项目！      ║\n";
echo "║     PHP 语言完整学习教程               ║\n";
echo "╚════════════════════════════════════════╝\n";

// 教程章节列表
$chapters = [
    ["01. 基础语法", "01-basics/variables.php"],
    ["02. 控制流", "02-control/control.php"],
    ["03. 函数", "03-functions/functions.php"],
    ["04. 数组", "04-arrays/arrays.php"],
    ["05. 面向对象", "05-oop/oop.php"],
    ["06. 字符串", "06-strings/strings.php"],
    ["07. Web 开发", "07-web/web.php"],
];

echo "\n================= 教程章节 =================\n";
foreach ($chapters as $chapter) {
    echo $chapter[0] . " -> " . $chapter[1] . "\n";
}
echo "===========================================\n";

// 依次加载并运行每个章节的演示函数
$demoFunctions = [
    "01-basics/variables.php" => "demoVariables",
    "02-control/control.php" => "demoControl",
    "03-functions/functions.php" => "demoFunctions",
    "04-arrays/arrays.php" => "demoArrays",
    "05-oop/oop.php" => "demoOop",
    "06-strings/strings.php" => "demoStrings",
    "07-web/web.php" => "demoWeb",
];

foreach ($demoFunctions as $file => $func) {
    echo "\n>>> 开始运行：" . $file . "\n";
    require_once __DIR__ . "/" . $file;
    $func();
}

echo "\n╔════════════════════════════════════════╗\n";
echo "║     PHPStudio 全部章节演示完成！       ║\n";
echo "╚════════════════════════════════════════╝\n";
