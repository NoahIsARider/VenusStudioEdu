// 第14章：宏
// 声明宏、过程宏、自定义派生

pub fn run() {
    println!("--- 宏 (Macros) ---");
    
    // 1. 声明宏基础
    demo_declarative_macros();
    
    // 2. 常用标准宏
    demo_standard_macros();
    
    // 3. 自定义声明宏
    demo_custom_macros();
    
    // 4. 过程宏
    demo_procedural_macros();
}

fn demo_declarative_macros() {
    println!("\n1️⃣ 声明宏基础：");
    
    println!("  宏 vs 函数：");
    println!("  - 宏在编译时展开");
    println!("  - 可以接受可变数量的参数");
    println!("  - 可以操作语法树");
    println!("  - 使用 ! 调用（如 println!）");
    
    println!("\n  声明宏使用 macro_rules!：");
    println!(r#"
    macro_rules! say_hello {{
        () => {{
            println!("Hello!");
        }};
    }}
    "#);
}

fn demo_standard_macros() {
    println!("\n2️⃣ 常用标准宏：");
    
    // println! 和 print!
    println!("  println! 和 print!：格式化输出");
    print!("  这不会换行 ");
    println!("这会换行");
    
    // format!
    let s = format!("  {} + {} = {}", 2, 3, 2 + 3);
    println!("{}", s);
    
    // vec!
    let v = vec![1, 2, 3, 4, 5];
    println!("  vec! 宏：{:?}", v);
    
    // panic!
    println!("  panic! 宏：用于不可恢复的错误");
    // panic!("程序崩溃！");
    
    // assert! 和相关宏
    assert!(2 + 2 == 4);
    assert_eq!(2 + 2, 4);
    assert_ne!(2 + 2, 5);
    println!("  assert! 系列：断言宏");
    
    // dbg!
    let a = 2;
    let b = 3;
    let c = dbg!(a + b); // 打印并返回值
    println!("  dbg! 返回：{}", c);
    
    // matches!
    let value = Some(5);
    let is_some = matches!(value, Some(_));
    println!("  matches! 宏：{}", is_some);
    
    // todo! 和 unimplemented!
    println!("  todo! 和 unimplemented!：标记未完成的代码");
    
    // unreachable!
    println!("  unreachable!：标记不应到达的代码");
    
    // compile_error!
    println!("  compile_error!：产生编译错误");
}

fn demo_custom_macros() {
    println!("\n3️⃣ 自定义声明宏：");
    
    // 简单宏
    macro_rules! say_hello {
        () => {
            println!("  你好！")
        };
    }
    
    say_hello!();
    
    // 带参数的宏
    macro_rules! greet {
        ($name:expr) => {
            println!("  你好，{}！", $name)
        };
    }
    
    greet!("Rust");
    
    // 多个模式
    macro_rules! calculate {
        (add $a:expr, $b:expr) => {
            $a + $b
        };
        (mul $a:expr, $b:expr) => {
            $a * $b
        };
    }
    
    println!("  计算 add：{}", calculate!(add 2, 3));
    println!("  计算 mul：{}", calculate!(mul 2, 3));
    
    // 可变参数
    macro_rules! print_all {
        ($($item:expr),*) => {
            $(
                print!("{} ", $item);
            )*
            println!();
        };
    }
    
    print!("  可变参数宏：");
    print_all!(1, 2, 3, 4, 5);
    
    // 创建数据结构的宏
    macro_rules! create_point {
        ($x:expr, $y:expr) => {
            {
                #[derive(Debug)]
                struct Point {
                    x: i32,
                    y: i32,
                }
                Point { x: $x, y: $y }
            }
        };
    }
    
    let p = create_point!(10, 20);
    println!("  创建的点：{:?}", p);
    
    // HashMap 初始化宏示例
    println!("\n  实用宏示例：");
    println!(r#"
    macro_rules! hashmap {{
        ($($key:expr => $value:expr),* $(,)?) => {{
            let mut map = std::collections::HashMap::new();
            $(
                map.insert($key, $value);
            )*
            map
        }};
    }}
    
    let map = hashmap! {{
        "key1" => "value1",
        "key2" => "value2",
    }};
    "#);
}

fn demo_procedural_macros() {
    println!("\n4️⃣ 过程宏：");
    
    println!("  三种过程宏：");
    println!("  1. 自定义派生（Derive）宏");
    println!("  2. 属性宏");
    println!("  3. 函数宏");
    
    println!("\n  自定义派生宏示例：");
    println!(r#"
    // 使用
    #[derive(Debug, Clone)]
    struct MyStruct {{
        field: i32,
    }}
    
    // 自定义派生宏需要单独的 crate
    use proc_macro::TokenStream;
    
    #[proc_macro_derive(MyTrait)]
    pub fn my_trait_derive(input: TokenStream) -> TokenStream {{
        // 解析输入，生成实现代码
    }}
    "#);
    
    println!("\n  属性宏示例：");
    println!(r#"
    #[route(GET, "/")]
    fn index() {{
        // 路由处理
    }}
    "#);
    
    println!("\n  函数宏示例：");
    println!(r#"
    sql!(SELECT * FROM users WHERE id = 1);
    "#);
    
    println!("\n  常用的派生宏：");
    #[derive(Debug, Clone, PartialEq, Eq)]
    struct Example {
        value: i32,
    }
    
    let e1 = Example { value: 42 };
    let e2 = e1.clone();
    
    println!("  Debug: {:?}", e1);
    println!("  Clone: {:?}", e2);
    println!("  PartialEq: {}", e1 == e2);
    
    println!("\n  💡 宏的优势：");
    println!("  - 减少重复代码");
    println!("  - 编译时代码生成");
    println!("  - 类型安全");
    println!("  - 零运行时开销");
    
    println!("\n  💡 宏的限制：");
    println!("  - 调试困难");
    println!("  - 编译错误信息不够清晰");
    println!("  - 语法复杂");
}
