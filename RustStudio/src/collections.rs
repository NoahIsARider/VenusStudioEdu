// 第4章：集合类型
// Vector、String、HashMap

use std::collections::HashMap;

pub fn run() {
    println!("--- 集合类型 ---");
    
    // 1. Vector
    demo_vectors();
    
    // 2. String
    demo_strings();
    
    // 3. HashMap
    demo_hashmaps();
}

fn demo_vectors() {
    println!("\n1️⃣ Vector（动态数组）：");
    
    // 创建 Vector
    let mut v1: Vec<i32> = Vec::new();
    v1.push(1);
    v1.push(2);
    v1.push(3);
    println!("  Vector v1: {:?}", v1);
    
    // 使用宏创建
    let v2 = vec![1, 2, 3, 4, 5];
    println!("  Vector v2: {:?}", v2);
    
    // 访问元素
    let third: &i32 = &v2[2];
    println!("  第三个元素：{}", third);
    
    // 安全访问
    match v2.get(2) {
        Some(third) => println!("  get 方法获取第三个元素：{}", third),
        None => println!("  没有第三个元素"),
    }
    
    // 遍历
    print!("  遍历 Vector：");
    for i in &v2 {
        print!("{} ", i);
    }
    println!();
    
    // 可变遍历
    let mut v3 = vec![1, 2, 3];
    for i in &mut v3 {
        *i += 10;
    }
    println!("  修改后的 Vector：{:?}", v3);
    
    // 使用枚举存储不同类型
    #[derive(Debug)]
    enum SpreadsheetCell {
        Int(i32),
        Float(f64),
        Text(String),
    }
    
    let row = vec![
        SpreadsheetCell::Int(3),
        SpreadsheetCell::Float(10.12),
        SpreadsheetCell::Text(String::from("blue")),
    ];
    println!("  多类型 Vector：{:?}", row);
}

fn demo_strings() {
    println!("\n2️⃣ String（可增长的字符串）：");
    
    // 创建字符串
    let mut s1 = String::new();
    s1.push_str("hello");
    println!("  String::new(): {}", s1);
    
    let s2 = "initial contents".to_string();
    println!("  to_string(): {}", s2);
    
    let s3 = String::from("こんにちは");
    println!("  String::from(): {}", s3);
    
    // 更新字符串
    let mut s = String::from("foo");
    s.push_str("bar");
    s.push('!');
    println!("  追加后：{}", s);
    
    // 连接字符串
    let s1 = String::from("Hello, ");
    let s2 = String::from("world!");
    let s3 = s1 + &s2; // s1 被移动了
    println!("  + 连接：{}", s3);
    
    // format! 宏
    let s1 = String::from("tic");
    let s2 = String::from("tac");
    let s3 = String::from("toe");
    let s = format!("{}-{}-{}", s1, s2, s3);
    println!("  format! 宏：{}", s);
    
    // 索引字符串（Rust 不支持直接索引）
    let hello = String::from("Здравствуйте");
    // let c = hello[0]; // 错误！
    
    // 使用切片（需要小心字节边界）
    let s = &hello[0..4]; // 获取前 4 个字节
    println!("  字符串切片（俄语）：{}", s);
    
    // 遍历字符
    print!("  遍历字符：");
    for c in "नमस्ते".chars() {
        print!("{} ", c);
    }
    println!();
    
    // 遍历字节
    print!("  遍历字节：");
    for b in "hello".bytes() {
        print!("{} ", b);
    }
    println!();
}

fn demo_hashmaps() {
    println!("\n3️⃣ HashMap（哈希映射）：");
    
    // 创建 HashMap
    let mut scores = HashMap::new();
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);
    println!("  HashMap: {:?}", scores);
    
    // 从元组 Vector 创建
    let teams = vec![String::from("Blue"), String::from("Yellow")];
    let initial_scores = vec![10, 50];
    let scores: HashMap<_, _> = teams.iter().zip(initial_scores.iter()).collect();
    println!("  从 Vector 创建：{:?}", scores);
    
    // 访问值
    let mut scores = HashMap::new();
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);
    
    let team_name = String::from("Blue");
    let score = scores.get(&team_name);
    match score {
        Some(s) => println!("  Blue 队得分：{}", s),
        None => println!("  队伍不存在"),
    }
    
    // 遍历
    println!("  遍历 HashMap：");
    for (key, value) in &scores {
        println!("    {}: {}", key, value);
    }
    
    // 更新值
    scores.insert(String::from("Blue"), 25); // 覆盖
    println!("  覆盖后：{:?}", scores);
    
    // 只在键不存在时插入
    scores.entry(String::from("Red")).or_insert(50);
    scores.entry(String::from("Blue")).or_insert(100); // 不会插入
    println!("  entry/or_insert 后：{:?}", scores);
    
    // 基于旧值更新
    let text = "hello world wonderful world";
    let mut map = HashMap::new();
    
    for word in text.split_whitespace() {
        let count = map.entry(word).or_insert(0);
        *count += 1;
    }
    println!("  单词计数：{:?}", map);
}
