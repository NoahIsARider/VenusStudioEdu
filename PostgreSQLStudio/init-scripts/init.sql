-- PostgreSQLStudio 初始化脚本
-- 创建示例数据库和表

-- 创建示例数据库（如果需要单独的数据库）
-- CREATE DATABASE sample_db;

-- 连接到数据库后创建示例表
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    salary DECIMAL(10, 2),
    department_id INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager_id INTEGER,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12, 2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS employee_projects (
    employee_id INTEGER REFERENCES employees(id),
    project_id INTEGER REFERENCES projects(id),
    assignment_date DATE DEFAULT CURRENT_DATE,
    hours_per_week DECIMAL(5, 2),
    PRIMARY KEY (employee_id, project_id)
);

-- 插入一些示例数据
INSERT INTO departments (name) VALUES 
    ('人力资源部'),
    ('技术部'),
    ('市场部'),
    ('财务部'),
    ('运营部');

INSERT INTO employees (first_name, last_name, email, hire_date, salary, department_id) VALUES
    ('张', '三', 'zhangsan@company.com', '2020-01-15', 8000.00, 2),
    ('李', '四', 'lisi@company.com', '2019-03-22', 9500.00, 2),
    ('王', '五', 'wangwu@company.com', '2021-07-10', 7500.00, 1),
    ('赵', '六', 'zhaoliu@company.com', '2018-11-05', 12000.00, 3),
    ('钱', '七', 'qianqi@company.com', '2020-09-18', 8500.00, 4);

INSERT INTO projects (name, description, start_date, end_date, budget) VALUES
    ('客户关系管理系统', '开发新的CRM系统', '2023-01-01', '2023-12-31', 500000.00),
    ('电商平台升级', '现有电商平台功能增强', '2023-03-01', '2023-09-30', 300000.00),
    ('移动应用开发', '公司首款移动应用', '2023-06-01', '2024-01-31', 450000.00);

INSERT INTO employee_projects (employee_id, project_id, hours_per_week) VALUES
    (1, 1, 20.0),
    (2, 1, 30.0),
    (2, 2, 15.0),
    (4, 3, 25.0),
    (5, 2, 20.0);