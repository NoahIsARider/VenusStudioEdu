// 第7章：特征（Trait）
// 定义共享行为、trait bounds、默认实现

pub fn run() {
    println!("--- 特征 (Traits) ---");
    
    // 1. 定义和实现 trait
    demo_traits();
    
    // 2. 默认实现
    demo_default_impl();
    
    // 3. trait 作为参数
    demo_trait_params();
    
    // 4. trait bound
    demo_trait_bounds();
    
    // 5. 多个 trait bounds
    demo_multiple_bounds();
    
    // 6. 标准库 trait
    demo_standard_traits();
}

// 定义 trait
trait Summary {
    fn summarize(&self) -> String;
}

struct NewsArticle {
    headline: String,
    location: String,
    author: String,
    content: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

struct Tweet {
    username: String,
    content: String,
    reply: bool,
    retweet: bool,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}

fn demo_traits() {
    println!("\n1️⃣ 定义和实现 Trait：");
    
    let news = NewsArticle {
        headline: String::from("Rust 1.91 发布！"),
        location: String::from("互联网"),
        author: String::from("Rust Team"),
        content: String::from("Rust 新版本带来更多改进..."),
    };
    
    let tweet = Tweet {
        username: String::from("rustlang"),
        content: String::from("学习 Rust 真有趣！"),
        reply: false,
        retweet: false,
    };
    
    println!("  新闻摘要：{}", news.summarize());
    println!("  推文摘要：{}", tweet.summarize());
}

// 带默认实现的 trait
trait SummaryWithDefault {
    fn summarize_author(&self) -> String;
    
    fn summarize(&self) -> String {
        format!("(阅读更多来自 {}...)", self.summarize_author())
    }
}

struct Blog {
    author: String,
    title: String,
}

impl SummaryWithDefault for Blog {
    fn summarize_author(&self) -> String {
        self.author.clone()
    }
    
    // 可以使用默认的 summarize 或覆盖它
}

fn demo_default_impl() {
    println!("\n2️⃣ 默认实现：");
    
    let blog = Blog {
        author: String::from("张三"),
        title: String::from("Rust 学习之路"),
    };
    
    println!("  博客摘要（使用默认实现）：{}", blog.summarize());
}

// trait 作为参数
fn notify(item: &impl Summary) {
    println!("  通知：{}", item.summarize());
}

// trait bound 语法（更清晰）
fn _notify_bound<T: Summary>(item: &T) {
    println!("  通知：{}", item.summarize());
}

fn demo_trait_params() {
    println!("\n3️⃣ Trait 作为参数：");
    
    let tweet = Tweet {
        username: String::from("user123"),
        content: String::from("今天学习了 Rust traits！"),
        reply: false,
        retweet: false,
    };
    
    notify(&tweet);
}

// 返回实现了 trait 的类型
fn returns_summarizable() -> impl Summary {
    Tweet {
        username: String::from("horse_ebooks"),
        content: String::from("当然，就像你可能已经知道的那样"),
        reply: false,
        retweet: false,
    }
}

fn demo_trait_bounds() {
    println!("\n4️⃣ Trait Bound：");
    
    let tweet = returns_summarizable();
    println!("  返回的 trait 对象：{}", tweet.summarize());
    
    // 使用 trait bound 约束泛型
    fn print_summary<T: Summary>(item: &T) {
        println!("  摘要：{}", item.summarize());
    }
    
    print_summary(&tweet);
}

// 多个 trait bounds
use std::fmt::Display;

fn _some_function<T: Display + Clone, U: Clone + std::fmt::Debug>(t: &T, u: &U) -> String {
    format!("{} {:?}", t, u)
}

// 使用 where 子句简化
fn _some_function_where<T, U>(t: &T, u: &U) -> String
where
    T: Display + Clone,
    U: Clone + std::fmt::Debug,
{
    format!("{} {:?}", t, u)
}

fn demo_multiple_bounds() {
    println!("\n5️⃣ 多个 Trait Bounds：");
    
    println!("  可以要求类型实现多个 trait");
    println!("  语法：T: Display + Clone");
    println!("  或使用 where 子句：where T: Display + Clone");
}

fn demo_standard_traits() {
    println!("\n6️⃣ 标准库常用 Traits：");
    
    // Clone trait
    #[derive(Clone, Debug)]
    struct Data {
        value: i32,
    }
    
    let d1 = Data { value: 42 };
    let d2 = d1.clone();
    println!("  Clone: {:?} -> {:?}", d1, d2);
    
    // Copy trait（只能用于栈上的简单类型）
    let x = 5;
    let y = x; // 自动复制
    println!("  Copy: x = {}, y = {}", x, y);
    
    // Debug trait（使用 #[derive(Debug)]）
    println!("  Debug: {:?}", d1);
    
    // Display trait（需要手动实现）
    impl Display for Data {
        fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
            write!(f, "Data({})", self.value)
        }
    }
    
    println!("  Display: {}", d1);
    
    // PartialEq 和 Eq
    #[derive(PartialEq, Eq, Debug)]
    struct Point {
        x: i32,
        y: i32,
    }
    
    let p1 = Point { x: 1, y: 2 };
    let p2 = Point { x: 1, y: 2 };
    println!("  PartialEq: p1 == p2 ? {}", p1 == p2);
    
    // PartialOrd 和 Ord
    #[derive(PartialOrd, Ord, PartialEq, Eq, Debug)]
    struct Age(i32);
    
    let age1 = Age(25);
    let age2 = Age(30);
    println!("  PartialOrd: age1 < age2 ? {}", age1 < age2);
}
