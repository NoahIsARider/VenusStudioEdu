// 第8章：生命周期
// 生命周期注解、规则、结构体中的生命周期

pub fn run() {
    println!("--- 生命周期 (Lifetimes) ---");
    
    // 1. 生命周期基础
    demo_lifetime_basics();
    
    // 2. 函数中的生命周期
    demo_function_lifetimes();
    
    // 3. 结构体中的生命周期
    demo_struct_lifetimes();
    
    // 4. 生命周期省略规则
    demo_lifetime_elision();
    
    // 5. 静态生命周期
    demo_static_lifetime();
}

fn demo_lifetime_basics() {
    println!("\n1️⃣ 生命周期基础：");
    
    println!("  生命周期确保引用始终有效");
    println!("  防止悬垂引用（dangling references）");
    
    // 这个例子演示了为什么需要生命周期
    let r;
    {
        let x = 5;
        r = &x;
        println!("  内部作用域中：r = {}", r);
    }
    // println!("  外部作用域中：r = {}", r); // 错误！x 已经被销毁
    
    println!("  ❌ 上面的代码如果取消注释会编译失败");
}

fn demo_function_lifetimes() {
    println!("\n2️⃣ 函数中的生命周期：");
    
    let string1 = String::from("长字符串很长");
    let string2 = "xyz";
    
    let result = longest(string1.as_str(), string2);
    println!("  最长的字符串是：'{}'", result);
    
    // 生命周期注解示例
    let string1 = String::from("abcd");
    {
        let string2 = String::from("xyz");
        let result = longest(string1.as_str(), string2.as_str());
        println!("  最长的字符串是：'{}'", result);
    }
    
    // 展示不同生命周期的情况
    let string1 = String::from("long string is long");
    let result;
    {
        let string2 = String::from("xyz");
        result = longest(string1.as_str(), string2.as_str());
        println!("  在内部作用域：'{}'", result);
    }
    // println!("  在外部作用域：'{}'", result); // 如果 string2 生命周期更短，这会失败
}

// 生命周期注解语法
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

// 生命周期注解不改变生命周期，只是描述关系
fn _first_word<'a>(s: &'a str) -> &'a str {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    
    &s[..]
}

fn demo_struct_lifetimes() {
    println!("\n3️⃣ 结构体中的生命周期：");
    
    // 结构体包含引用时需要生命周期注解
    #[derive(Debug)]
    struct ImportantExcerpt<'a> {
        part: &'a str,
    }
    
    let novel = String::from("Call me Ishmael. Some years ago...");
    let first_sentence = novel.split('.').next().expect("Could not find a '.'");
    
    let excerpt = ImportantExcerpt {
        part: first_sentence,
    };
    
    println!("  结构体引用：{:?}", excerpt);
    
    // 方法中的生命周期
    impl<'a> ImportantExcerpt<'a> {
        fn level(&self) -> i32 {
            3
        }
        
        fn announce_and_return_part(&self, announcement: &str) -> &str {
            println!("  注意！{}", announcement);
            self.part
        }
    }
    
    println!("  方法返回：{}", excerpt.level());
    println!("  {}", excerpt.announce_and_return_part("重要信息"));
}

fn demo_lifetime_elision() {
    println!("\n4️⃣ 生命周期省略规则：");
    
    println!("  Rust 编译器可以在某些情况下自动推断生命周期");
    println!("  三条生命周期省略规则：");
    println!("  1. 每个引用参数都有自己的生命周期");
    println!("  2. 如果只有一个输入生命周期，它被赋予所有输出生命周期");
    println!("  3. 如果有多个输入生命周期，但其中一个是 &self 或 &mut self，");
    println!("     self 的生命周期被赋予所有输出生命周期");
    
    // 这个函数不需要显式生命周期注解
    fn first_word(s: &str) -> &str {
        let bytes = s.as_bytes();
        
        for (i, &item) in bytes.iter().enumerate() {
            if item == b' ' {
                return &s[0..i];
            }
        }
        
        &s[..]
    }
    
    let s = String::from("hello world");
    let word = first_word(&s);
    println!("  第一个单词（无需显式注解）：'{}'", word);
}

fn demo_static_lifetime() {
    println!("\n5️⃣ 静态生命周期：");
    
    // 'static 生命周期存活于整个程序期间
    let s: &'static str = "我有静态生命周期";
    println!("  静态字符串：'{}'", s);
    
    // 字符串字面量都有 'static 生命周期
    println!("  所有字符串字面量都是 &'static str 类型");
    
    // 泄漏的数据也有 'static 生命周期
    let leaked_string: &'static str = Box::leak(Box::new(String::from("leaked")));
    println!("  泄漏的字符串：'{}'", leaked_string);
    
    println!("  ⚠️  小心使用 'static，它意味着数据永远不会被释放");
}

// 综合示例：泛型、trait bound 和生命周期
fn _longest_with_an_announcement<'a, T>(
    x: &'a str,
    y: &'a str,
    ann: T,
) -> &'a str
where
    T: std::fmt::Display,
{
    println!("  公告！{}", ann);
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
