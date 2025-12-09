// 第9章：闭包
// 匿名函数、捕获环境、Fn traits

pub fn run() {
    println!("--- 闭包 (Closures) ---");
    
    // 1. 闭包基础
    demo_closure_basics();
    
    // 2. 类型推断和注解
    demo_closure_types();
    
    // 3. 捕获环境
    demo_capture();
    
    // 4. Fn traits
    demo_fn_traits();
    
    // 5. 闭包作为参数和返回值
    demo_closure_params();
}

fn demo_closure_basics() {
    println!("\n1️⃣ 闭包基础：");
    
    // 普通函数
    fn add_one_fn(x: i32) -> i32 {
        x + 1
    }
    
    // 闭包（完整形式）
    let add_one_v1 = |x: i32| -> i32 { x + 1 };
    
    // 闭包（省略类型）
    let add_one_v2 = |x| { x + 1 };
    
    // 闭包（省略大括号）
    let add_one_v3 = |x| x + 1;
    
    println!("  函数调用：{}", add_one_fn(5));
    println!("  闭包 v1：{}", add_one_v1(5));
    println!("  闭包 v2：{}", add_one_v2(5));
    println!("  闭包 v3：{}", add_one_v3(5));
    
    // 闭包可以多行
    let verbose_closure = |num| {
        println!("  计算中...");
        std::thread::sleep(std::time::Duration::from_millis(100));
        num + 1
    };
    
    println!("  多行闭包：{}", verbose_closure(10));
}

fn demo_closure_types() {
    println!("\n2️⃣ 类型推断和注解：");
    
    // 闭包会根据第一次使用推断类型
    let example_closure = |x| x;
    
    let s = example_closure(String::from("hello"));
    println!("  推断为 String 类型：{}", s);
    
    // let n = example_closure(5); // 错误！类型已经被推断为 String
    
    // 显式类型注解
    let closure_with_types = |x: i32, y: i32| -> i32 { x + y };
    println!("  显式类型闭包：{}", closure_with_types(1, 2));
}

fn demo_capture() {
    println!("\n3️⃣ 捕获环境：");
    
    // 不可变借用
    let list = vec![1, 2, 3];
    println!("  定义闭包前：{:?}", list);
    
    let only_borrows = || println!("  闭包内：{:?}", list);
    
    println!("  定义闭包后：{:?}", list);
    only_borrows();
    println!("  调用闭包后：{:?}", list);
    
    // 可变借用
    let mut list2 = vec![1, 2, 3];
    println!("\n  定义可变闭包前：{:?}", list2);
    
    let mut borrows_mutably = || list2.push(7);
    
    borrows_mutably();
    println!("  调用闭包后：{:?}", list2);
    
    // 获取所有权
    let list3 = vec![1, 2, 3];
    println!("\n  Move 前：{:?}", list3);
    
    let takes_ownership = move || {
        println!("  闭包内（已获取所有权）：{:?}", list3);
    };
    
    takes_ownership();
    // println!("  Move 后：{:?}", list3); // 错误！所有权已转移
}

fn demo_fn_traits() {
    println!("\n4️⃣ Fn Traits：");
    
    println!("  三种 Fn traits：");
    println!("  - FnOnce：消耗捕获的变量，只能调用一次");
    println!("  - FnMut：可变借用捕获的变量");
    println!("  - Fn：不可变借用捕获的变量");
    
    // FnOnce 示例
    let s = String::from("hello");
    let consume = move || {
        println!("  消耗所有权：{}", s);
        drop(s);
    };
    consume();
    // consume(); // 错误！只能调用一次
    
    // FnMut 示例
    let mut counter = 0;
    let mut increment = || {
        counter += 1;
        println!("  计数器：{}", counter);
    };
    increment();
    increment();
    increment();
    
    // Fn 示例
    let value = String::from("不可变");
    let print = || println!("  {}", value);
    print();
    print();
    println!("  原值仍可用：{}", value);
}

fn demo_closure_params() {
    println!("\n5️⃣ 闭包作为参数和返回值：");
    
    // 闭包作为参数
    fn apply<F>(f: F, x: i32) -> i32
    where
        F: Fn(i32) -> i32,
    {
        f(x)
    }
    
    let double = |x| x * 2;
    let result = apply(double, 5);
    println!("  应用闭包：{}", result);
    
    // 使用泛型和 trait bound
    fn do_twice<F>(mut func: F, arg: i32) -> i32
    where
        F: FnMut(i32) -> i32,
    {
        func(arg) + func(arg)
    }
    
    let mut num = 5;
    let mut add_num = |x| {
        num += 1;
        x + num
    };
    
    println!("  执行两次：{}", do_twice(&mut add_num, 1));
    
    // 返回闭包
    fn returns_closure() -> Box<dyn Fn(i32) -> i32> {
        Box::new(|x| x + 1)
    }
    
    let closure = returns_closure();
    println!("  返回的闭包：{}", closure(5));
    
    // 实际应用：缓存/记忆化
    struct Cacher<T>
    where
        T: Fn(u32) -> u32,
    {
        calculation: T,
        value: Option<u32>,
    }
    
    impl<T> Cacher<T>
    where
        T: Fn(u32) -> u32,
    {
        fn new(calculation: T) -> Cacher<T> {
            Cacher {
                calculation,
                value: None,
            }
        }
        
        fn value(&mut self, arg: u32) -> u32 {
            match self.value {
                Some(v) => v,
                None => {
                    let v = (self.calculation)(arg);
                    self.value = Some(v);
                    v
                }
            }
        }
    }
    
    let mut expensive_closure = Cacher::new(|num| {
        println!("  执行昂贵的计算...");
        std::thread::sleep(std::time::Duration::from_millis(100));
        num
    });
    
    println!("  第一次调用：{}", expensive_closure.value(10));
    println!("  第二次调用（使用缓存）：{}", expensive_closure.value(10));
}
