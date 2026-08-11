<?php
// =====================================================
// 06-strings/strings.php
// PHP 字符串处理：函数、格式化、正则表达式
// =====================================================

// PHP 拥有丰富的字符串处理函数，是 Web 开发的核心能力。

function demoStrings(): void
{
    echo "\n=== 1. 字符串基本操作 ===\n";

    $str = "Hello, PHPStudio!";

    // strlen 获取字节长度
    echo "strlen: " . strlen($str) . "\n";

    // mb_strlen 获取字符数（多字节安全，处理中文）
    $chinese = "你好，世界";
    echo "strlen(中文): " . strlen($chinese) . " (字节)\n";
    echo "mb_strlen(中文): " . mb_strlen($chinese) . " (字符)\n";

    // substr 截取子串
    echo "substr(0,5): " . substr($str, 0, 5) . "\n";
    echo "substr(-5): " . substr($str, -5) . "\n";
    // 多字节截取用 mb_substr
    echo "mb_substr(中文,0,2): " . mb_substr($chinese, 0, 2) . "\n";

    echo "\n=== 2. 字符串查找与替换 ===\n";

    $text = "PHP 是最好的语言，PHP 无处不在";

    // strpos 查找位置（从 0 开始，找不到返回 false）
    $pos = strpos($text, "PHP");
    echo "strpos PHP: " . var_export($pos, true) . "\n";

    // strrpos 从右查找
    echo "strrpos PHP: " . strrpos($text, "PHP") . "\n";

    // str_replace 替换
    $replaced = str_replace("PHP", "Python", $text);
    echo "str_replace: $replaced\n";

    // str_replace 支持数组批量替换
    $search = ["苹果", "香蕉"];
    $replace = ["Apple", "Banana"];
    $fruitText = "我喜欢苹果和香蕉";
    echo "批量替换: " . str_replace($search, $replace, $fruitText) . "\n";

    // str_contains（PHP 8.0+）判断是否包含
    echo "str_contains PHP: " . var_export(str_contains($text, "PHP"), true) . "\n";
    echo "str_starts_with: " . var_export(str_starts_with($text, "PHP"), true) . "\n";
    echo "str_ends_with: " . var_export(str_ends_with($text, "不在"), true) . "\n";

    echo "\n=== 3. 字符串分割与连接 ===\n";

    // explode 按分隔符分割成数组
    $csv = "张三,李四,王五,赵六";
    $names = explode(",", $csv);
    echo "explode: " . implode(" | ", $names) . "\n";

    // implode 把数组连接成字符串
    $tags = ["PHP", "Web", "编程"];
    echo "implode: " . implode(" - ", $tags) . "\n";

    // str_split 按长度分割
    $split = str_split("Hello", 2);
    echo "str_split(2): " . implode("/", $split) . "\n";

    echo "\n=== 4. 字符串修剪与清理 ===\n";

    $dirty = "   Hello World   ";

    // trim 去除两端空白
    echo "trim: [" . trim($dirty) . "]\n";
    // ltrim / rtrim 去除左/右
    echo "ltrim: [" . ltrim($dirty) . "]\n";
    echo "rtrim: [" . rtrim($dirty) . "]\n";

    // 去除指定字符
    $padded = "###PHP###";
    echo "trim(#): [" . trim($padded, "#") . "]\n";

    // 大小写转换
    echo "strtoupper: " . strtoupper("hello") . "\n";
    echo "strtolower: " . strtolower("WORLD") . "\n";
    echo "ucfirst: " . ucfirst("php") . "\n";
    echo "ucwords: " . ucwords("hello world") . "\n";

    echo "\n=== 5. 字符串格式化 ===\n";

    // sprintf 格式化字符串
    $formatted = sprintf("姓名: %s，年龄: %d，分数: %.2f", "张三", 25, 92.5);
    echo "sprintf: $formatted\n";

    // 常用格式符
    echo sprintf("十进制: %d\n", 42);
    echo sprintf("浮点: %.2f\n", 3.14159);
    echo sprintf("字符串: %s\n", "PHP");
    echo sprintf("八进制: %o\n", 255);
    echo sprintf("十六进制: %x\n", 255);
    echo sprintf("补零: %05d\n", 42);

    // number_format 数字千分位
    echo "number_format: " . number_format(1234567.891, 2) . "\n";

    // PHP 8.0+ 字符串插值（双引号中变量自动解析）
    $name = "世界";
    echo "插值: 你好，$name！\n";
    echo "花括号插值: {$name}你好！\n";

    echo "\n=== 6. 正则表达式 ===\n";

    // preg_match 正则匹配
    $email = "user@example.com";
    if (preg_match('/^[\w.+-]+@[\w.-]+\.[a-zA-Z]+$/', $email)) {
        echo "preg_match: $email 是有效邮箱格式\n";
    }

    // preg_match 捕获分组
    $dateStr = "2024-03-15";
    if (preg_match('/(\d{4})-(\d{2})-(\d{2})/', $dateStr, $matches)) {
        echo "捕获: 年={$matches[1]} 月={$matches[2]} 日={$matches[3]}\n";
    }

    // preg_match_all 全局匹配
    $content = "电话 13800138000 和 13900139000";
    preg_match_all('/1[3-9]\d{9}/', $content, $phones);
    echo "preg_match_all: " . implode(", ", $phones[0]) . "\n";

    // preg_replace 正则替换
    $masked = preg_replace('/1[3-9]\d{9}/', '***', $content);
    echo "preg_replace 脱敏: $masked\n";

    // preg_replace_callback 回调替换
    $templated = preg_replace_callback('/\d+/', function ($m) {
        return $m[0] * 2;
    }, "a1b2c3");
    echo "preg_replace_callback 翻倍数字: $templated\n";

    // preg_split 按正则分割
    $parts = preg_split('/[\s,]+/', "PHP, Python  Ruby,Java");
    echo "preg_split: " . implode(" | ", $parts) . "\n";

    echo "\n=== 7. 其他实用字符串函数 ===\n";

    echo "str_repeat: " . str_repeat("=-", 10) . "\n";
    echo "strrev: " . strrev("Hello") . "\n";
    echo "str_pad: [" . str_pad("PHP", 10, "-", STR_PAD_BOTH) . "]\n";
    echo "wordwrap: " . wordwrap("The quick brown fox jumps over the lazy dog", 15, "\n", true) . "\n";
    echo "htmlspecialchars: " . htmlspecialchars("<script>alert('xss')</script>") . "\n";
}
