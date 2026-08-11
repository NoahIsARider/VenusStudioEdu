<?php
// =====================================================
// 07-web/web.php
// PHP Web 开发：超全局变量、会话、Cookie、JSON、文件上传
// =====================================================

// PHP 天生为 Web 而生，提供超全局变量处理 HTTP 请求。
// 本文件演示概念，无需真实 Web 服务器即可运行。

function demoWeb(): void
{
    echo "\n=== 1. 超全局变量 $_SERVER ===\n";

    // $_SERVER 包含服务器和执行环境信息
    echo "PHP_SELF: " . ($_SERVER['PHP_SELF'] ?? 'N/A') . "\n";
    echo "SCRIPT_NAME: " . ($_SERVER['SCRIPT_NAME'] ?? 'N/A') . "\n";
    echo "PHP 版本: " . PHP_VERSION . "\n";
    echo "操作系统: " . PHP_OS . "\n";

    // 模拟一些 $_SERVER 字段（CLI 运行时部分字段可能不存在）
    $serverInfo = [
        'SERVER_NAME' => 'localhost',
        'REQUEST_METHOD' => 'GET',
        'REQUEST_URI' => '/index.php',
        'HTTP_USER_AGENT' => 'Mozilla/5.0',
        'REMOTE_ADDR' => '127.0.0.1',
    ];
    echo "模拟服务器信息:\n";
    foreach ($serverInfo as $key => $value) {
        echo "  $key => $value\n";
    }

    echo "\n=== 2. $_GET 表单数据（模拟） ===\n";

    // $_GET 收集 URL 参数（?name=PHP&version=8）
    // CLI 运行时 $_GET 为空，这里模拟处理逻辑
    $simulatedGet = ['name' => 'PHP', 'version' => '8.2', 'page' => '1'];

    function handleGetParams(array $params): void
    {
        echo "处理 GET 参数:\n";
        foreach ($params as $key => $value) {
            // 实际开发中务必对用户输入做过滤和验证
            $safe = htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
            echo "  $key => $safe\n";
        }
    }
    handleGetParams($simulatedGet);

    echo "\n=== 3. $_POST 表单数据（模拟） ===\n";

    // $_POST 收集表单 POST 提交的数据
    $simulatedPost = [
        'username' => 'zhangsan',
        'email' => 'zhangsan@example.com',
        'message' => '你好，这是一条留言',
    ];

    function handlePostForm(array $post): void
    {
        echo "处理 POST 表单:\n";
        // 验证必填字段
        $required = ['username', 'email'];
        foreach ($required as $field) {
            if (empty($post[$field])) {
                echo "  ❌ 字段 $field 不能为空\n";
                return;
            }
        }
        // 验证邮箱格式
        if (!filter_var($post['email'], FILTER_VALIDATE_EMAIL)) {
            echo "  ❌ 邮箱格式无效\n";
            return;
        }
        echo "  ✅ 表单验证通过\n";
        echo "  用户名: " . htmlspecialchars($post['username']) . "\n";
        echo "  邮箱: " . htmlspecialchars($post['email']) . "\n";
        echo "  留言: " . htmlspecialchars($post['message']) . "\n";
    }
    handlePostForm($simulatedPost);

    echo "\n=== 4. Cookie 操作（概念演示） ===\n";

    // setcookie() 设置 Cookie（需在输出前调用，CLI 下不生效，仅演示）
    // setcookie('user', 'zhangsan', time() + 3600, '/');

    // 模拟 Cookie 读写
    function simulateCookie(): void
    {
        echo "设置 Cookie（模拟）:\n";
        $cookies = [
            'user' => 'zhangsan',
            'lang' => 'zh-CN',
            'theme' => 'dark',
        ];
        foreach ($cookies as $name => $value) {
            $expires = time() + 3600;
            echo "  setcookie('$name', '$value', 过期时间戳: $expires)\n";
        }

        echo "读取 Cookie（模拟 \$_COOKIE）:\n";
        // 实际代码: foreach ($_COOKIE as $name => $value) { ... }
        foreach ($cookies as $name => $value) {
            echo "  $_COOKIE['$name'] => $value\n";
        }
    }
    simulateCookie();

    echo "\n=== 5. Session 会话（概念演示） ===\n";

    // session_start() 启动会话，$_SESSION 存储会话数据
    // CLI 运行无法真正启动 session，这里演示概念
    function simulateSession(): void
    {
        echo "启动会话（模拟 session_start()）:\n";

        // 模拟 $_SESSION
        $session = [];

        // 存储会话数据
        $session['user_id'] = 1001;
        $session['username'] = 'admin';
        $session['login_time'] = date('Y-m-d H:i:s');
        $session['cart'] = ['商品A', '商品B'];

        echo "存储会话数据:\n";
        foreach ($session as $key => $value) {
            if (is_array($value)) {
                echo "  \$_SESSION['$key'] => [" . implode(", ", $value) . "]\n";
            } else {
                echo "  \$_SESSION['$key'] => $value\n";
            }
        }

        echo "销毁会话（模拟 session_destroy()）:\n";
        echo "  会话已清空\n";
    }
    simulateSession();

    echo "\n=== 6. HTTP 头部操作（概念演示） ===\n";

    // header() 设置 HTTP 响应头（需在任何输出前调用）
    function simulateHeaders(): void
    {
        echo "设置 HTTP 响应头（模拟）:\n";
        $headers = [
            'Content-Type: application/json; charset=utf-8',
            'X-Custom-Header: PHPStudio',
            'Access-Control-Allow-Origin: *',
        ];
        foreach ($headers as $header) {
            echo "  header('$header')\n";
        }

        echo "重定向（模拟）:\n";
        echo "  header('Location: /login.php')\n";

        echo "设置状态码:\n";
        echo "  http_response_code(404) -> 返回 404\n";
        echo "  http_response_code(200) -> 返回 200\n";
    }
    simulateHeaders();

    echo "\n=== 7. JSON 编码与解码 ===\n";

    // json_encode 将 PHP 数组/对象转为 JSON 字符串
    $data = [
        'name' => 'PHPStudio',
        'version' => '8.2',
        'features' => ['OOP', '闭包', 'match'],
        'active' => true,
    ];

    $json = json_encode($data, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    echo "json_encode:\n$json\n";

    // json_decode 将 JSON 字符串转回 PHP 数组/对象
    $decoded = json_decode($json, true);   // true 返回关联数组
    echo "json_decode(关联数组):\n";
    print_r($decoded);

    // 解码为对象
    $decodedObj = json_decode($json);      // 默认返回对象
    echo "json_decode(对象): " . $decodedObj->name . ", 版本: " . $decodedObj->version . "\n";

    // JSON 错误处理
    $badJson = '{"name": "test", "invalid"}';
    $result = json_decode($badJson, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        echo "JSON 解析错误: " . json_last_error_msg() . "\n";
    }

    echo "\n=== 8. 文件上传处理（概念演示） ===\n";

    // $_FILES 处理上传的文件
    function simulateFileUpload(): void
    {
        echo "模拟 \$_FILES 结构:\n";
        // 实际表单: <form method="post" enctype="multipart/form-data">
        $files = [
            'avatar' => [
                'name' => 'photo.jpg',
                'type' => 'image/jpeg',
                'tmp_name' => '/tmp/phpXXXXXX',
                'error' => UPLOAD_ERR_OK,
                'size' => 102400,
            ],
        ];

        foreach ($files as $field => $info) {
            echo "  字段: $field\n";
            echo "    原始文件名: " . $info['name'] . "\n";
            echo "    MIME 类型: " . $info['type'] . "\n";
            echo "    临时文件: " . $info['tmp_name'] . "\n";
            echo "    错误码: " . $info['error'] . " (" . uploadErrorText($info['error']) . ")\n";
            echo "    文件大小: " . $info['size'] . " 字节\n";
        }

        echo "\n文件上传安全检查（模拟）:\n";
        $allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
        $maxSize = 2 * 1024 * 1024;   // 2MB

        $file = $files['avatar'];
        if (!in_array($file['type'], $allowedTypes)) {
            echo "  ❌ 文件类型不被允许\n";
        } elseif ($file['size'] > $maxSize) {
            echo "  ❌ 文件超过 2MB 限制\n";
        } elseif ($file['error'] !== UPLOAD_ERR_OK) {
            echo "  ❌ 上传出错\n";
        } else {
            echo "  ✅ 文件验证通过，可执行 move_uploaded_file() 保存\n";
            // move_uploaded_file($file['tmp_name'], 'uploads/' . $file['name']);
        }
    }

    function uploadErrorText(int $code): string
    {
        return match ($code) {
            UPLOAD_ERR_OK => '上传成功',
            UPLOAD_ERR_INI_SIZE => '超过 php.ini 限制',
            UPLOAD_ERR_FORM_SIZE => '超过表单限制',
            UPLOAD_ERR_PARTIAL => '部分上传',
            UPLOAD_ERR_NO_FILE => '没有文件',
            default => '未知错误',
        };
    }

    simulateFileUpload();
}
