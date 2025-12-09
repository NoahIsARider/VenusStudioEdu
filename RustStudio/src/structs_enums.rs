// 第3章：结构体和枚举
// 自定义数据类型、方法、关联函数、模式匹配

pub fn run() {
    println!("--- 结构体和枚举 ---");
    
    // 1. 结构体
    demo_structs();
    
    // 2. 方法
    demo_methods();
    
    // 3. 枚举
    demo_enums();
    
    // 4. 模式匹配
    demo_pattern_matching();
    
    // 5. Option 枚举
    demo_option();
}

// 定义结构体
#[derive(Debug)]
struct User {
    username: String,
    email: String,
    age: u32,
    active: bool,
}

// 元组结构体
#[derive(Debug)]
struct Color(i32, i32, i32);

// 单元结构体
struct AlwaysEqual;

fn demo_structs() {
    println!("\n1️⃣ 结构体：");
    
    // 创建结构体实例
    let user1 = User {
        email: String::from("user@example.com"),
        username: String::from("rustacean"),
        age: 25,
        active: true,
    };
    
    println!("  用户：{:?}", user1);
    
    // 使用字段初始化简写
    let email = String::from("another@example.com");
    let username = String::from("ferris");
    let user2 = build_user(email, username, 30);
    println!("  新用户：{:?}", user2);
    
    // 结构体更新语法
    let user3 = User {
        email: String::from("third@example.com"),
        ..user2
    };
    println!("  更新语法创建的用户：{:?}", user3);
    
    // 元组结构体
    let black = Color(0, 0, 0);
    let white = Color(255, 255, 255);
    println!("  颜色：黑色 {:?}, 白色 {:?}", black, white);
}

fn build_user(email: String, username: String, age: u32) -> User {
    User {
        email,      // 字段初始化简写
        username,
        age,
        active: true,
    }
}

// 定义方法
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    // 方法（第一个参数是 &self）
    fn area(&self) -> u32 {
        self.width * self.height
    }
    
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
    
    // 关联函数（没有 self 参数）
    fn square(size: u32) -> Rectangle {
        Rectangle {
            width: size,
            height: size,
        }
    }
}

fn demo_methods() {
    println!("\n2️⃣ 方法：");
    
    let rect1 = Rectangle {
        width: 30,
        height: 50,
    };
    
    println!("  矩形：{:?}", rect1);
    println!("  面积：{}", rect1.area());
    
    let rect2 = Rectangle {
        width: 10,
        height: 40,
    };
    
    let rect3 = Rectangle {
        width: 60,
        height: 45,
    };
    
    println!("  rect1 能容纳 rect2 吗？{}", rect1.can_hold(&rect2));
    println!("  rect1 能容纳 rect3 吗？{}", rect1.can_hold(&rect3));
    
    // 调用关联函数
    let square = Rectangle::square(20);
    println!("  正方形：{:?}", square);
}

// 定义枚举
#[derive(Debug)]
enum IpAddrKind {
    V4,
    V6,
}

#[derive(Debug)]
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}

#[derive(Debug)]
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

impl Message {
    fn call(&self) {
        println!("  调用消息：{:?}", self);
    }
}

fn demo_enums() {
    println!("\n3️⃣ 枚举：");
    
    let four = IpAddrKind::V4;
    let six = IpAddrKind::V6;
    println!("  IP 地址类型：{:?}, {:?}", four, six);
    
    // 带数据的枚举
    let home = IpAddr::V4(127, 0, 0, 1);
    let loopback = IpAddr::V6(String::from("::1"));
    println!("  IP 地址：{:?}", home);
    println!("  IP 地址：{:?}", loopback);
    
    // 不同类型的枚举变体
    let m1 = Message::Quit;
    let m2 = Message::Move { x: 10, y: 20 };
    let m3 = Message::Write(String::from("Hello"));
    let m4 = Message::ChangeColor(255, 0, 0);
    
    m1.call();
    m2.call();
    m3.call();
    m4.call();
}

fn demo_pattern_matching() {
    println!("\n4️⃣ 模式匹配（match）：");
    
    let ip = IpAddr::V4(192, 168, 1, 1);
    
    match ip {
        IpAddr::V4(a, b, c, d) => {
            println!("  IPv4 地址：{}.{}.{}.{}", a, b, c, d);
        }
        IpAddr::V6(addr) => {
            println!("  IPv6 地址：{}", addr);
        }
    }
    
    // match 必须穷尽所有可能
    let number = 7;
    match number {
        1 => println!("  一"),
        2 => println!("  二"),
        3 | 4 | 5 => println!("  三到五"),
        6..=10 => println!("  六到十"),
        _ => println!("  其他数字"),
    }
    
    // if let 简化语法
    let some_value = Some(3);
    if let Some(3) = some_value {
        println!("  if let 匹配到 3");
    }
}

fn demo_option() {
    println!("\n5️⃣ Option 枚举：");
    
    // Option 用于表示可能为空的值
    let some_number: Option<i32> = Some(5);
    let no_number: Option<i32> = None;
    
    println!("  Some 值：{:?}", some_number);
    println!("  None 值：{:?}", no_number);
    
    // 使用 match 处理 Option
    let result = match some_number {
        Some(i) => i + 1,
        None => 0,
    };
    println!("  处理 Some：{}", result);
    
    // 使用方法链
    let x = Some(2);
    let y = x.map(|val| val * 2);
    println!("  map 操作：{:?}", y);
    
    // unwrap_or 提供默认值
    let value = no_number.unwrap_or(10);
    println!("  unwrap_or 默认值：{}", value);
}
