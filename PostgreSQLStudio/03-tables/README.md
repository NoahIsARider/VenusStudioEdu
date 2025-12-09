# PostgreSQL 表操作

## 学习目标

完成本章学习后，你应该能够：

1. 掌握表的创建、修改和删除操作
2. 理解表约束（主键、外键、唯一性、检查约束）的作用和使用方法
3. 学会使用模式（Schema）组织数据库对象
4. 理解表继承的概念和应用场景
5. 掌握分区表的基本使用方法

## 主要内容

### 1. 创建表

使用 `CREATE TABLE` 语句创建新表，需要定义列名、数据类型和约束。

基本语法：
```sql
CREATE TABLE table_name (
    column1 datatype constraints,
    column2 datatype constraints,
    ...
    table_constraints
);
```

示例：
```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE NOT NULL,
    salary NUMERIC(10, 2) CHECK (salary > 0),
    department_id INTEGER REFERENCES departments(id)
);
```

### 2. 表约束

PostgreSQL 支持多种表约束来保证数据完整性：

- **主键约束（PRIMARY KEY）**：唯一标识表中的每一行
- **外键约束（FOREIGN KEY）**：建立表之间的关联关系
- **唯一性约束（UNIQUE）**：确保列中的值是唯一的
- **检查约束（CHECK）**：确保列中的值满足特定条件
- **非空约束（NOT NULL）**：确保列中的值不为空

### 3. 修改表结构

使用 `ALTER TABLE` 语句可以修改现有表的结构：

- 添加列：`ALTER TABLE table_name ADD COLUMN column_name datatype;`
- 删除列：`ALTER TABLE table_name DROP COLUMN column_name;`
- 修改列类型：`ALTER TABLE table_name ALTER COLUMN column_name TYPE new_datatype;`
- 添加约束：`ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint_definition;`
- 删除约束：`ALTER TABLE table_name DROP CONSTRAINT constraint_name;`

### 4. 删除表

使用 `DROP TABLE` 语句删除表：
```sql
DROP TABLE table_name;
```

如果要避免表不存在时报错，可以使用：
```sql
DROP TABLE IF EXISTS table_name;
```

### 5. 模式（Schema）

模式是数据库对象的逻辑容器，可以用来组织和隔离表、视图等对象。

- 创建模式：`CREATE SCHEMA schema_name;`
- 在模式中创建表：`CREATE TABLE schema_name.table_name (...);`
- 设置搜索路径：`SET search_path TO schema_name, public;`

### 6. 表继承

PostgreSQL 支持表继承，允许创建一个表作为另一个表的子表。

```sql
CREATE TABLE cities (
    name VARCHAR(80),
    population REAL,
    elevation INT
);

CREATE TABLE capitals (
    state CHAR(2)
) INHERITS (cities);
```

### 7. 分区表

分区表是将大表分割成更小、更易管理的部分的方法。

PostgreSQL 支持声明式分区，包括范围分区、列表分区和哈希分区。

示例（范围分区）：
```sql
CREATE TABLE measurements (
    city_id INT NOT NULL,
    logdate DATE NOT NULL,
    peaktemp INT,
    unitsales INT
) PARTITION BY RANGE (logdate);

CREATE TABLE measurements_y2023m01 PARTITION OF measurements
FOR VALUES FROM ('2023-01-01') TO ('2023-02-01');
```

## 最佳实践

1. **合理设计表结构**：
   - 根据业务需求设计表的列和数据类型
   - 使用适当的约束保证数据完整性

2. **使用模式组织对象**：
   - 使用模式来组织相关的表和对象
   - 避免所有对象都在 public 模式中

3. **谨慎使用表继承**：
   - 表继承在某些情况下很有用，但可能会增加查询复杂度
   - 考虑是否可以通过其他方式（如分区）达到相同效果

4. **考虑使用分区表**：
   - 对于大型表，考虑使用分区来提高查询性能
   - 根据数据访问模式选择合适的分区策略

## 实践练习

### 练习 1：创建带有约束的表

```sql
-- 创建部门表
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100)
);

-- 创建员工表，包含各种约束
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    salary NUMERIC(10, 2) CHECK (salary > 0),
    department_id INTEGER REFERENCES departments(id),
    manager_id INTEGER REFERENCES employees(id)
);
```

### 练习 2：修改表结构

```sql
-- 向 employees 表添加一列
ALTER TABLE employees ADD COLUMN birth_date DATE;

-- 添加一个检查约束
ALTER TABLE employees ADD CONSTRAINT check_birth_date CHECK (birth_date < hire_date);

-- 删除一列
ALTER TABLE employees DROP COLUMN phone;
```

### 练习 3：使用模式

```sql
-- 创建一个新的模式
CREATE SCHEMA hr;

-- 在 hr 模式中创建表
CREATE TABLE hr.employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

-- 设置搜索路径
SET search_path TO hr, public;

-- 现在可以直接引用 hr.employees 表
SELECT * FROM employees;
```

### 练习 4：创建分区表

```sql
-- 创建分区表
CREATE TABLE sales (
    id SERIAL,
    sale_date DATE NOT NULL,
    amount NUMERIC(10, 2)
) PARTITION BY RANGE (sale_date);

-- 创建分区
CREATE TABLE sales_2023_q1 PARTITION OF sales
FOR VALUES FROM ('2023-01-01') TO ('2023-04-01');

CREATE TABLE sales_2023_q2 PARTITION OF sales
FOR VALUES FROM ('2023-04-01') TO ('2023-07-01');

-- 插入数据（会自动分配到相应分区）
INSERT INTO sales (sale_date, amount) VALUES
('2023-02-15', 1000.00),
('2023-05-20', 1500.00);
```

### 练习 5：表继承

```sql
-- 创建父表
CREATE TABLE vehicles (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(50),
    model VARCHAR(50)
);

-- 创建子表
CREATE TABLE cars (
    doors INTEGER
) INHERITS (vehicles);

CREATE TABLE trucks (
    load_capacity NUMERIC(10, 2)
) INHERITS (vehicles);

-- 插入数据
INSERT INTO vehicles (brand, model) VALUES ('Generic', 'Vehicle');
INSERT INTO cars (brand, model, doors) VALUES ('Toyota', 'Camry', 4);
INSERT INTO trucks (brand, model, load_capacity) VALUES ('Volvo', 'FH16', 20000.00);

-- 查询所有车辆（包括子表数据）
SELECT * FROM vehicles;

-- 只查询特定子表
SELECT * FROM ONLY vehicles;  -- 仅父表数据
```

通过这些练习，你将掌握 PostgreSQL 中表操作的核心技能。