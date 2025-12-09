// 第13章：异步编程
// async/await、Future、异步运行时

pub fn run() {
    println!("--- 异步编程 (Async Programming) ---");
    
    // 注意：这个模块展示异步编程的概念
    // 实际运行异步代码需要运行时（如 tokio）
    
    demo_async_basics();
    demo_async_concepts();
    demo_async_patterns();
}

fn demo_async_basics() {
    println!("\n1️⃣ 异步编程基础：");
    
    println!("  async/await 语法：");
    println!("  - async fn：声明异步函数");
    println!("  - .await：等待异步操作完成");
    println!("  - 返回 Future trait");
    
    // 示例代码（需要运行时才能执行）
    println!("\n  示例代码：");
    println!(r#"
    async fn do_something() -> i32 {{
        42
    }}
    
    async fn example() {{
        let result = do_something().await;
        println!("结果：{{}}", result);
    }}
    "#);
    
    println!("  异步函数实际上返回 impl Future<Output = T>");
}

fn demo_async_concepts() {
    println!("\n2️⃣ 异步编程概念：");
    
    println!("  Future trait：");
    println!("  - 代表一个异步计算");
    println!("  - 惰性求值：不会自动执行");
    println!("  - 需要被轮询（poll）才会执行");
    
    println!("\n  异步运行时：");
    println!("  - tokio：最流行的异步运行时");
    println!("  - async-std：标准库风格的异步运行时");
    println!("  - smol：轻量级运行时");
    
    println!("\n  示例：使用 tokio");
    println!(r#"
    // Cargo.toml
    // tokio = {{ version = "1", features = ["full"] }}
    
    #[tokio::main]
    async fn main() {{
        println!("Hello, async world!");
    }}
    "#);
    
    println!("\n  并发执行多个异步任务：");
    println!(r#"
    use tokio::join;
    
    async fn task1() {{
        // 异步任务 1
    }}
    
    async fn task2() {{
        // 异步任务 2
    }}
    
    async fn run_both() {{
        let (result1, result2) = join!(task1(), task2());
    }}
    "#);
}

fn demo_async_patterns() {
    println!("\n3️⃣ 常见异步模式：");
    
    println!("  1. 异步 HTTP 请求：");
    println!(r#"
    use reqwest;
    
    async fn fetch_url(url: &str) -> Result<String, reqwest::Error> {{
        let response = reqwest::get(url).await?;
        let body = response.text().await?;
        Ok(body)
    }}
    "#);
    
    println!("\n  2. 异步文件操作：");
    println!(r#"
    use tokio::fs::File;
    use tokio::io::AsyncReadExt;
    
    async fn read_file(path: &str) -> std::io::Result<String> {{
        let mut file = File::open(path).await?;
        let mut contents = String::new();
        file.read_to_string(&mut contents).await?;
        Ok(contents)
    }}
    "#);
    
    println!("\n  3. 异步超时：");
    println!(r#"
    use tokio::time::{{timeout, Duration}};
    
    async fn with_timeout() {{
        let result = timeout(Duration::from_secs(5), some_async_operation()).await;
        match result {{
            Ok(value) => println!("完成：{{:?}}", value),
            Err(_) => println!("超时！"),
        }}
    }}
    "#);
    
    println!("\n  4. 异步通道：");
    println!(r#"
    use tokio::sync::mpsc;
    
    async fn channel_example() {{
        let (tx, mut rx) = mpsc::channel(32);
        
        tokio::spawn(async move {{
            tx.send("消息").await.unwrap();
        }});
        
        while let Some(msg) = rx.recv().await {{
            println!("收到：{{}}", msg);
        }}
    }}
    "#);
    
    println!("\n  5. 异步流（Stream）：");
    println!(r#"
    use tokio_stream::{{self as stream, StreamExt}};
    
    async fn stream_example() {{
        let mut stream = stream::iter(vec![1, 2, 3, 4, 5]);
        
        while let Some(value) = stream.next().await {{
            println!("值：{{}}", value);
        }}
    }}
    "#);
    
    println!("\n  6. Select（等待多个 Future）：");
    println!(r#"
    use tokio::select;
    
    async fn select_example() {{
        let result = select! {{
            val = async_operation1() => {{
                println!("操作1完成：{{}}", val);
            }},
            val = async_operation2() => {{
                println!("操作2完成：{{}}", val);
            }},
        }};
    }}
    "#);
    
    println!("\n  💡 异步编程要点：");
    println!("  - 异步是零成本抽象");
    println!("  - .await 只能在 async 函数中使用");
    println!("  - 异步函数是惰性的，需要 .await 或运行时执行");
    println!("  - 避免在异步代码中使用阻塞操作");
    
    println!("\n  要在此项目中使用异步功能，需要：");
    println!("  1. 在 Cargo.toml 添加：tokio = {{ version = \"1\", features = [\"full\"] }}");
    println!("  2. 将 main 函数改为：#[tokio::main] async fn main()");
    println!("  3. 然后可以在代码中使用 async/await");
}
