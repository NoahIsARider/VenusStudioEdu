# PostgreSQL 数据类型

## 学习目标

完成本章学习后，你应该能够：

1. 理解 PostgreSQL 中各种数据类型的用途
2. 掌握数值类型、字符类型、日期/时间类型的选择和使用
3. 了解特殊数据类型如 JSON、数组、UUID 的应用场景
4. 能够根据业务需求选择合适的数据类型
5. 理解类型转换的基本原则

## 主要内容

### 1. 数值类型

PostgreSQL 提供了丰富的数值类型来满足不同的精度和范围要求：

- **整数类型**：
  - SMALLINT：2字节，范围 -32768 到 32767
  - INTEGER：4字节，范围 -2147483648 到 2147483647
  - BIGINT：8字节，范围 -9223372036854775808 到 9223372036854775807

- **任意精度数值类型**：
  - NUMERIC/DECIMAL：用户指定精度，无精度损失

- **浮点数类型**：
  - REAL：4字节，6位十进制精度
  - DOUBLE PRECISION：8字节，15位十进制精度

### 2. 字符类型

PostgreSQL 提供多种字符类型来存储文本数据：

- **CHAR(n)**：固定长度字符，不足部分用空格填充
- **VARCHAR(n)**：可变长度字符，最大长度 n
- **TEXT**：可变长度文本，无长度限制

### 3. 日期/时间类型

PostgreSQL 包含全面的日期/时间类型支持：

- **DATE**：只包含日期部分
- **TIME**：只包含时间部分
- **TIMESTAMP**：包含日期和时间
- **TIMESTAMPTZ**：带时区的时间戳
- **INTERVAL**：时间间隔

### 4. 布尔类型

BOOLEAN 类型存储真/假值，可以接受 true/false、yes/no、1/0 等形式的输入。

### 5. 特殊数据类型

PostgreSQL 还提供了一些特殊的数据类型：

- **JSON/JSONB**：存储 JSON 格式数据，JSONB 提供更好的性能
- **ARRAY**：数组类型，可以存储任何数据类型的数组
- **UUID**：通用唯一标识符
- **ENUM**：枚举类型
- **网络地址类型**：INET、CIDR、MACADDR 等

## 最佳实践

1. **选择合适的数据类型**：
   - 根据数据的实际范围和精度要求选择合适的类型
   - 避免过度使用大类型，节省存储空间

2. **使用 TEXT 而不是 VARCHAR(n)**：
   - 当不确定长度或长度变化很大时，使用 TEXT 更灵活
   - TEXT 性能与 VARCHAR 相当

3. **优先使用 TIMESTAMPTZ**：
   - 带时区的时间戳更适合全球应用
   - 避免时区相关的混淆

4. **合理使用 JSONB**：
   - 对于结构化程度较低的数据，使用 JSONB
   - 注意 JSONB 的查询性能可能不如传统关系型结构

## 实践练习

### 练习 1：创建包含各种数据类型的表

```sql
-- 创建一个产品信息表，包含各种数据类型
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2),
    stock_quantity INTEGER,
    weight REAL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    is_active BOOLEAN DEFAULT true,
    tags TEXT[],  -- 文本数组
    metadata JSONB  -- JSON 数据
);

-- 插入示例数据
INSERT INTO products (name, price, stock_quantity, weight, description, tags, metadata) VALUES
('笔记本电脑', 5999.99, 50, 2.5, '高性能游戏笔记本', ARRAY['电子产品', '电脑'], '{"color": "black", "warranty": "2 years"}'),
('无线鼠标', 199.50, 200, 0.1, '人体工学设计', ARRAY['电子产品', '配件'], '{"color": "white", "battery": "AA x 2"}');
```

### 练习 2：操作日期/时间类型

```sql
-- 创建订单表
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE,
    order_time TIME,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 插入订单数据
INSERT INTO orders (customer_name, order_date, order_time) VALUES
('张三', '2023-10-15', '14:30:00'),
('李四', CURRENT_DATE, CURRENT_TIME);
```

### 练习 3：使用 JSONB 数据类型

```sql
-- 查询包含特定元数据的产品
SELECT * FROM products WHERE metadata ? 'warranty';

-- 查询特定颜色的产品
SELECT * FROM products WHERE metadata @> '{"color": "black"}';

-- 添加新的元数据字段
UPDATE products 
SET metadata = metadata || '{"discount": "10%"}' 
WHERE name = '笔记本电脑';
```

### 练习 4：数组操作

```sql
-- 查询包含特定标签的产品
SELECT * FROM products WHERE tags && ARRAY['电子产品'];

-- 查询同时包含多个标签的产品
SELECT * FROM products WHERE tags @> ARRAY['电子产品', '电脑'];
```

### 练习 5：类型转换

```sql
-- 显式类型转换
SELECT '123'::INTEGER AS converted_number;
SELECT 123::TEXT AS converted_text;

-- 使用 CAST 函数
SELECT CAST('2023-10-15' AS DATE) AS converted_date;
```

通过这些练习，你将更好地理解 PostgreSQL 中各种数据类型的使用方法和适用场景。