// 第5章：错误处理
// panic!、Result、? 运算符

use std::fs::File;
use std::io::{self, Read};

pub fn run() {
    println!("--- 错误处理 ---");
    
    // 1. 不可恢复的错误 panic!
    demo_panic();
    
    // 2. 可恢复的错误 Result
    demo_result();
    
    // 3. ? 运算符
    demo_question_mark();
    
    // 4. 自定义错误类型
    demo_custom_errors();
}

fn demo_panic() {
    println!("\n1️⃣ 不可恢复的错误 panic!：");
    
    // panic! 会立即终止程序
    println!("  panic! 用于不可恢复的错误");
    println!("  示例：panic!(\"程序崩溃了！\");");
    
    // 数组越界会触发 panic
    // let v = vec![1, 2, 3];
    // v[99]; // 这会 panic
    
    println!("  （跳过实际 panic 以继续演示）");
}

fn demo_result() {
    println!("\n2️⃣ 可恢复的错误 Result<T, E>：");
    
    // Result 枚举有两个变体：Ok(T) 和 Err(E)
    let f = File::open("hello.txt");
    
    match f {
        Ok(file) => println!("  文件打开成功：{:?}", file),
        Err(error) => println!("  文件打开失败：{:?}", error),
    }
    
    // 匹配不同的错误类型
    use std::io::ErrorKind;
    
    let f = File::open("hello.txt");
    let _f = match f {
        Ok(file) => {
            println!("  文件存在");
            file
        },
        Err(error) => match error.kind() {
            ErrorKind::NotFound => {
                println!("  文件不存在，尝试创建");
                match File::create("hello.txt") {
                    Ok(fc) => {
                        println!("  文件创建成功");
                        fc
                    },
                    Err(e) => {
                        println!("  文件创建失败：{:?}", e);
                        panic!("无法创建文件：{:?}", e);
                    }
                }
            },
            other_error => {
                println!("  其他错误：{:?}", other_error);
                panic!("打开文件出错：{:?}", other_error);
            }
        },
    };
    
    // 使用闭包简化
    let _f = File::open("hello.txt").unwrap_or_else(|error| {
        if error.kind() == ErrorKind::NotFound {
            File::create("hello.txt").unwrap_or_else(|error| {
                panic!("无法创建文件：{:?}", error);
            })
        } else {
            panic!("打开文件出错：{:?}", error);
        }
    });
    
    // unwrap：Ok 则返回值，Err 则 panic
    // let f = File::open("nonexistent.txt").unwrap();
    
    // expect：类似 unwrap，但可以自定义错误信息
    // let f = File::open("nonexistent.txt")
    //     .expect("无法打开 nonexistent.txt");
}

fn demo_question_mark() {
    println!("\n3️⃣ ? 运算符（错误传播）：");
    
    match read_username_from_file() {
        Ok(username) => println!("  读取用户名：{}", username),
        Err(e) => println!("  读取失败：{}", e),
    }
    
    match read_username_short() {
        Ok(username) => println!("  简化版读取用户名：{}", username),
        Err(e) => println!("  读取失败：{}", e),
    }
}

// 传统错误传播方式
fn read_username_from_file() -> Result<String, io::Error> {
    let f = File::open("username.txt");
    
    let mut f = match f {
        Ok(file) => file,
        Err(e) => return Err(e),
    };
    
    let mut s = String::new();
    
    match f.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    }
}

// 使用 ? 运算符简化
fn read_username_short() -> Result<String, io::Error> {
    let mut f = File::open("username.txt")?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}

// 进一步简化
fn _read_username_shorter() -> Result<String, io::Error> {
    let mut s = String::new();
    File::open("username.txt")?.read_to_string(&mut s)?;
    Ok(s)
}

// 最简化版本
fn _read_username_shortest() -> Result<String, io::Error> {
    std::fs::read_to_string("username.txt")
}

fn demo_custom_errors() {
    println!("\n4️⃣ 自定义错误类型：");
    
    #[derive(Debug)]
    enum MyError {
        IoError(io::Error),
        ParseError,
    }
    
    impl From<io::Error> for MyError {
        fn from(error: io::Error) -> Self {
            MyError::IoError(error)
        }
    }
    
    fn do_something() -> Result<(), MyError> {
        // File::open 返回 io::Error，自动转换为 MyError
        let _f = File::open("test.txt")?;
        Ok(())
    }
    
    match do_something() {
        Ok(_) => println!("  操作成功"),
        Err(e) => println!("  自定义错误：{:?}", e),
    }
    
    println!("  可以实现自己的错误类型来统一错误处理");
}
