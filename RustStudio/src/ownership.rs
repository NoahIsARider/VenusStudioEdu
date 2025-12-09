// 第2章：所有权系统
// Rust 最独特的特性：所有权、借用、引用、切片

pub fn run() {
    println!("--- 所有权系统 ---");
    
    // 1. 所有权规则
    demo_ownership();
    
    // 2. 引用和借用
    demo_references();
    
    // 3. 可变引用
    demo_mutable_references();
    
    // 4. 切片
    demo_slices();
}

fn demo_ownership() {
    println!("\n1️⃣ 所有权规则：");
    println!("  - 每个值都有一个所有者");
    println!("  - 同一时间只能有一个所有者");
    println!("  - 当所有者离开作用域，值将被丢弃");
    
    // 移动（Move）
    let s1 = String::from("hello");
    let s2 = s1; // s1 被移动到 s2
    // println!("{}", s1); // 错误！s1 已失效
    println!("  移动后：s2 = {}", s2);
    
    // 克隆（Clone）
    let s3 = String::from("world");
    let s4 = s3.clone(); // 深拷贝
    println!("  克隆后：s3 = {}, s4 = {}", s3, s4);
    
    // 栈上的数据：复制
    let x = 5;
    let y = x; // 整数实现了 Copy trait，所以会复制
    println!("  复制后：x = {}, y = {}", x, y);
    
    // 函数中的所有权
    let s = String::from("ownership");
    takes_ownership(s); // s 被移动到函数中
    // println!("{}", s); // 错误！s 已失效
    
    let x = 5;
    makes_copy(x); // x 被复制
    println!("  复制类型的值在函数调用后仍有效：x = {}", x);
}

fn takes_ownership(some_string: String) {
    println!("  函数获取所有权：{}", some_string);
} // some_string 在这里被丢弃

fn makes_copy(some_integer: i32) {
    println!("  函数接收复制的值：{}", some_integer);
}

fn demo_references() {
    println!("\n2️⃣ 引用和借用：");
    
    let s1 = String::from("hello");
    let len = calculate_length(&s1); // 借用 s1
    println!("  字符串 '{}' 的长度是 {}", s1, len);
    // s1 仍然有效，因为只是借用
    
    // 多个不可变引用
    let s2 = String::from("world");
    let r1 = &s2;
    let r2 = &s2;
    println!("  多个不可变引用：r1 = {}, r2 = {}", r1, r2);
}

fn calculate_length(s: &String) -> usize {
    s.len()
} // s 离开作用域，但因为没有所有权，所以不会丢弃

fn demo_mutable_references() {
    println!("\n3️⃣ 可变引用：");
    
    let mut s = String::from("hello");
    change(&mut s);
    println!("  修改后的字符串：{}", s);
    
    // 可变引用的限制
    println!("  规则：同一时间只能有一个可变引用");
    println!("  规则：不能同时拥有可变和不可变引用");
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}

fn demo_slices() {
    println!("\n4️⃣ 切片（Slice）：");
    
    let s = String::from("hello world");
    
    let hello = &s[0..5];
    let world = &s[6..11];
    println!("  字符串切片：'{}' 和 '{}'", hello, world);
    
    // 语法糖
    let slice1 = &s[..5];  // 等同于 &s[0..5]
    let slice2 = &s[6..];  // 等同于 &s[6..s.len()]
    let slice3 = &s[..];   // 等同于 &s[0..s.len()]
    println!("  切片语法糖：'{}', '{}', '{}'", slice1, slice2, slice3);
    
    // 字符串字面量就是切片
    let literal: &str = "Hello, literal!";
    println!("  字符串字面量（切片类型）：{}", literal);
    
    // 数组切片
    let arr = [1, 2, 3, 4, 5];
    let arr_slice = &arr[1..4];
    println!("  数组切片：{:?}", arr_slice);
    
    // 实用示例：获取第一个单词
    let sentence = String::from("Hello Rust World");
    let first_word = get_first_word(&sentence);
    println!("  第一个单词：'{}'", first_word);
}

fn get_first_word(s: &str) -> &str {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    
    &s[..]
}
