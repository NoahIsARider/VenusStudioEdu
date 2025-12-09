// 第1章：基础语法
// 涵盖：变量、数据类型、函数、控制流、注释

pub fn run() {
    println!("--- 基础语法 ---");
    
    // 1. 变量和可变性
    demo_variables();
    
    // 2. 数据类型
    demo_data_types();
    
    // 3. 函数
    demo_functions();
    
    // 4. 控制流
    demo_control_flow();
    
    // 5. 注释
    demo_comments();
}

fn demo_variables() {
    println!("\n1️⃣ 变量和可变性：");
    
    // 不可变变量（默认）
    let x = 5;
    println!("  不可变变量 x = {}", x);
    
    // 可变变量
    let mut y = 10;
    println!("  可变变量 y = {}", y);
    y = 20;
    println!("  修改后 y = {}", y);
    
    // 常量
    const MAX_POINTS: u32 = 100_000;
    println!("  常量 MAX_POINTS = {}", MAX_POINTS);
    
    // 变量遮蔽（Shadowing）
    let z = 5;
    let z = z + 1;
    let z = z * 2;
    println!("  遮蔽后的 z = {}", z);
}

fn demo_data_types() {
    println!("\n2️⃣ 数据类型：");
    
    // 整数类型
    let a: i32 = -42;
    let b: u64 = 100;
    println!("  整数：i32 = {}, u64 = {}", a, b);
    
    // 浮点类型
    let c: f64 = 3.14159;
    println!("  浮点数：f64 = {}", c);
    
    // 布尔类型
    let d: bool = true;
    println!("  布尔值：{}", d);
    
    // 字符类型
    let e: char = '🦀';
    println!("  字符：{}", e);
    
    // 元组
    let tuple: (i32, f64, char) = (500, 6.4, 'R');
    println!("  元组：({}, {}, {})", tuple.0, tuple.1, tuple.2);
    
    // 数组
    let array: [i32; 5] = [1, 2, 3, 4, 5];
    println!("  数组：[{}, {}, {}, {}, {}]", 
             array[0], array[1], array[2], array[3], array[4]);
}

fn demo_functions() {
    println!("\n3️⃣ 函数：");
    
    println!("  调用函数 add(5, 3) = {}", add(5, 3));
    println!("  调用表达式函数 multiply(4, 7) = {}", multiply(4, 7));
}

fn add(x: i32, y: i32) -> i32 {
    return x + y; // 显式返回
}

fn multiply(x: i32, y: i32) -> i32 {
    x * y // 表达式返回（无分号）
}

fn demo_control_flow() {
    println!("\n4️⃣ 控制流：");
    
    // if 表达式
    let number = 6;
    if number % 2 == 0 {
        println!("  {} 是偶数", number);
    } else {
        println!("  {} 是奇数", number);
    }
    
    // if 作为表达式
    let condition = true;
    let value = if condition { 5 } else { 10 };
    println!("  条件表达式结果：{}", value);
    
    // loop 循环
    let mut counter = 0;
    let result = loop {
        counter += 1;
        if counter == 5 {
            break counter * 2;
        }
    };
    println!("  loop 循环结果：{}", result);
    
    // while 循环
    let mut n = 3;
    print!("  while 倒计时：");
    while n > 0 {
        print!("{} ", n);
        n -= 1;
    }
    println!("发射！🚀");
    
    // for 循环
    print!("  for 循环遍历数组：");
    let arr = [10, 20, 30, 40, 50];
    for element in arr.iter() {
        print!("{} ", element);
    }
    println!();
    
    // for 范围循环
    print!("  for 范围循环：");
    for i in 1..=5 {
        print!("{} ", i);
    }
    println!();
}

fn demo_comments() {
    println!("\n5️⃣ 注释：");
    
    // 这是单行注释
    println!("  Rust 支持单行注释 //");
    
    /* 这是
       多行
       注释 */
    println!("  Rust 支持多行注释 /* */");
    
    /// 这是文档注释，用于生成文档
    /// 可以使用 Markdown 格式
    println!("  Rust 支持文档注释 ///");
}
