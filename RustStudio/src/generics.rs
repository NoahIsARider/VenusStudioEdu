// 第6章：泛型
// 泛型函数、结构体、枚举、方法

pub fn run() {
    println!("--- 泛型 ---");
    
    // 1. 泛型函数
    demo_generic_functions();
    
    // 2. 泛型结构体
    demo_generic_structs();
    
    // 3. 泛型枚举
    demo_generic_enums();
    
    // 4. 泛型方法
    demo_generic_methods();
}

fn demo_generic_functions() {
    println!("\n1️⃣ 泛型函数：");
    
    // 泛型函数可以处理多种类型
    let numbers = vec![34, 50, 25, 100, 65];
    let result = largest(&numbers);
    println!("  最大的数字：{}", result);
    
    let chars = vec!['y', 'm', 'a', 'q'];
    let result = largest(&chars);
    println!("  最大的字符：{}", result);
}

// 泛型函数：找到最大值
fn largest<T: PartialOrd>(list: &[T]) -> &T {
    let mut largest = &list[0];
    
    for item in list {
        if item > largest {
            largest = item;
        }
    }
    
    largest
}

// 多个泛型参数
fn _mix<T, U>(_t: T, _u: U) -> String {
    format!("混合类型")
}

fn demo_generic_structs() {
    println!("\n2️⃣ 泛型结构体：");
    
    // 单个泛型参数
    #[derive(Debug)]
    struct Point<T> {
        x: T,
        y: T,
    }
    
    let integer_point = Point { x: 5, y: 10 };
    let float_point = Point { x: 1.0, y: 4.0 };
    
    println!("  整数点：{:?}", integer_point);
    println!("  浮点数点：{:?}", float_point);
    
    // 多个泛型参数
    #[derive(Debug)]
    struct MixedPoint<T, U> {
        x: T,
        y: U,
    }
    
    let mixed = MixedPoint { x: 5, y: 4.0 };
    println!("  混合类型点：{:?}", mixed);
}

fn demo_generic_enums() {
    println!("\n3️⃣ 泛型枚举：");
    
    // Option 是标准库中的泛型枚举
    let some_number: Option<i32> = Some(5);
    let some_string: Option<String> = Some(String::from("hello"));
    let no_number: Option<i32> = None;
    
    println!("  Option<i32>: {:?}", some_number);
    println!("  Option<String>: {:?}", some_string);
    println!("  Option<i32> None: {:?}", no_number);
    
    // Result 也是泛型枚举
    let success: Result<i32, String> = Ok(200);
    let failure: Result<i32, String> = Err(String::from("错误"));
    
    println!("  Result Ok: {:?}", success);
    println!("  Result Err: {:?}", failure);
}

fn demo_generic_methods() {
    println!("\n4️⃣ 泛型方法：");
    
    #[derive(Debug)]
    struct Point<T> {
        x: T,
        y: T,
    }
    
    impl<T> Point<T> {
        fn x(&self) -> &T {
            &self.x
        }
    }
    
    // 只为特定类型实现方法
    impl Point<f32> {
        fn distance_from_origin(&self) -> f32 {
            (self.x.powi(2) + self.y.powi(2)).sqrt()
        }
    }
    
    let p = Point { x: 5, y: 10 };
    println!("  p.x = {}", p.x());
    
    let p2 = Point { x: 3.0, y: 4.0 };
    println!("  距离原点：{}", p2.distance_from_origin());
    
    // 方法中使用不同的泛型参数
    #[derive(Debug)]
    struct MixedPoint<T, U> {
        x: T,
        y: U,
    }
    
    impl<T, U> MixedPoint<T, U> {
        fn mixup<V, W>(self, other: MixedPoint<V, W>) -> MixedPoint<T, W> {
            MixedPoint {
                x: self.x,
                y: other.y,
            }
        }
    }
    
    let p1 = MixedPoint { x: 5, y: 10.4 };
    let p2 = MixedPoint { x: "Hello", y: 'c' };
    let p3 = p1.mixup(p2);
    
    println!("  混合后的点：{:?}", p3);
    
    // 泛型的性能
    println!("\n  💡 Rust 的泛型没有运行时开销！");
    println!("  编译器会为每个具体类型生成特化版本（单态化）");
}
