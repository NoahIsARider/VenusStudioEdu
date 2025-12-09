// RustStudio - 全面的 Rust 语法学习项目
// 通过运行不同的模块学习 Rust 的各个方面

mod basics;
mod ownership;
mod structs_enums;
mod collections;
mod error_handling;
mod generics;
mod traits;
mod lifetimes;
mod closures;
mod iterators;
mod smart_pointers;
mod concurrency;
mod async_programming;
mod macros;

fn main() {
    println!("🦀 欢迎来到 RustStudio - Rust 语法学习项目！\n");
    println!("请选择要学习的章节（1-14）：");
    println!("1.  基础语法 (Basics)");
    println!("2.  所有权系统 (Ownership)");
    println!("3.  结构体和枚举 (Structs & Enums)");
    println!("4.  集合类型 (Collections)");
    println!("5.  错误处理 (Error Handling)");
    println!("6.  泛型 (Generics)");
    println!("7.  特征 (Traits)");
    println!("8.  生命周期 (Lifetimes)");
    println!("9.  闭包 (Closures)");
    println!("10. 迭代器 (Iterators)");
    println!("11. 智能指针 (Smart Pointers)");
    println!("12. 并发编程 (Concurrency)");
    println!("13. 异步编程 (Async Programming)");
    println!("14. 宏 (Macros)");
    println!("\n运行特定模块的示例：cargo run --bin <module_name>");
    println!("例如：cargo run --bin basics\n");

    // 自动运行所有示例作为演示
    println!("=== 自动演示模式 ===\n");
    
    println!("\n📚 1. 基础语法");
    basics::run();
    
    println!("\n📚 2. 所有权系统");
    ownership::run();
    
    println!("\n📚 3. 结构体和枚举");
    structs_enums::run();
    
    println!("\n📚 4. 集合类型");
    collections::run();
    
    println!("\n📚 5. 错误处理");
    error_handling::run();
    
    println!("\n📚 6. 泛型");
    generics::run();
    
    println!("\n📚 7. 特征");
    traits::run();
    
    println!("\n📚 8. 生命周期");
    lifetimes::run();
    
    println!("\n📚 9. 闭包");
    closures::run();
    
    println!("\n📚 10. 迭代器");
    iterators::run();
    
    println!("\n📚 11. 智能指针");
    smart_pointers::run();
    
    println!("\n📚 12. 并发编程");
    concurrency::run();
    
    println!("\n📚 13. 异步编程");
    async_programming::run();
    
    println!("\n📚 14. 宏");
    macros::run();
    
    println!("\n\n🎉 恭喜！你已经完成了 Rust 核心语法的学习！");
}
