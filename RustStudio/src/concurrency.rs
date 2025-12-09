// 第12章：并发编程
// 线程、消息传递、共享状态、Sync 和 Send

use std::thread;
use std::time::Duration;
use std::sync::{mpsc, Mutex, Arc};

pub fn run() {
    println!("--- 并发编程 (Concurrency) ---");
    
    // 1. 线程基础
    demo_threads();
    
    // 2. 消息传递
    demo_message_passing();
    
    // 3. 共享状态
    demo_shared_state();
    
    // 4. Sync 和 Send traits
    demo_sync_send();
}

fn demo_threads() {
    println!("\n1️⃣ 线程基础：");
    
    // 创建线程
    let handle = thread::spawn(|| {
        for i in 1..5 {
            println!("  子线程：数字 {}", i);
            thread::sleep(Duration::from_millis(50));
        }
    });
    
    for i in 1..3 {
        println!("  主线程：数字 {}", i);
        thread::sleep(Duration::from_millis(50));
    }
    
    // 等待线程完成
    handle.join().unwrap();
    println!("  所有线程完成");
    
    // 使用 move 闭包
    let v = vec![1, 2, 3];
    
    let handle = thread::spawn(move || {
        println!("  线程中的 vector：{:?}", v);
    });
    
    handle.join().unwrap();
    // println!("{:?}", v); // 错误！v 已被移动
    
    // 多个线程
    println!("\n  创建多个线程：");
    let mut handles = vec![];
    
    for i in 0..5 {
        let handle = thread::spawn(move || {
            println!("    线程 {} 开始", i);
            thread::sleep(Duration::from_millis(100));
            println!("    线程 {} 结束", i);
        });
        handles.push(handle);
    }
    
    for handle in handles {
        handle.join().unwrap();
    }
}

fn demo_message_passing() {
    println!("\n2️⃣ 消息传递（Channel）：");
    
    // 创建通道
    let (tx, rx) = mpsc::channel();
    
    thread::spawn(move || {
        let val = String::from("你好");
        tx.send(val).unwrap();
        // println!("{}", val); // 错误！val 已被移动
    });
    
    let received = rx.recv().unwrap();
    println!("  收到：{}", received);
    
    // 发送多个值
    println!("\n  发送多个值：");
    let (tx, rx) = mpsc::channel();
    
    thread::spawn(move || {
        let vals = vec![
            String::from("你好"),
            String::from("来自"),
            String::from("线程"),
        ];
        
        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_millis(100));
        }
    });
    
    for received in rx {
        println!("  收到：{}", received);
    }
    
    // 多个发送者
    println!("\n  多个发送者：");
    let (tx, rx) = mpsc::channel();
    
    let tx1 = tx.clone();
    thread::spawn(move || {
        let vals = vec![
            String::from("线程 1：消息 1"),
            String::from("线程 1：消息 2"),
        ];
        for val in vals {
            tx1.send(val).unwrap();
            thread::sleep(Duration::from_millis(100));
        }
    });
    
    thread::spawn(move || {
        let vals = vec![
            String::from("线程 2：消息 1"),
            String::from("线程 2：消息 2"),
        ];
        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_millis(100));
        }
    });
    
    for received in rx.iter().take(4) {
        println!("  收到：{}", received);
    }
}

fn demo_shared_state() {
    println!("\n3️⃣ 共享状态（Mutex）：");
    
    // Mutex 基础
    let m = Mutex::new(5);
    
    {
        let mut num = m.lock().unwrap();
        *num = 6;
    } // 锁在这里自动释放
    
    println!("  Mutex 值：{:?}", m);
    
    // 多线程共享 Mutex（需要 Arc）
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];
    
    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }
    
    for handle in handles {
        handle.join().unwrap();
    }
    
    println!("  计数器结果：{}", *counter.lock().unwrap());
    
    // Arc<Mutex<T>> 模式
    println!("\n  Arc<Mutex<T>> 模式：");
    println!("  - Arc：原子引用计数，线程安全");
    println!("  - Mutex：互斥锁，保证同时只有一个线程访问");
    
    // 实际应用：并发计算
    let data = Arc::new(Mutex::new(vec![]));
    let mut handles = vec![];
    
    for i in 0..5 {
        let data = Arc::clone(&data);
        let handle = thread::spawn(move || {
            thread::sleep(Duration::from_millis(50));
            let mut d = data.lock().unwrap();
            d.push(i * 2);
        });
        handles.push(handle);
    }
    
    for handle in handles {
        handle.join().unwrap();
    }
    
    println!("  并发计算结果：{:?}", *data.lock().unwrap());
}

fn demo_sync_send() {
    println!("\n4️⃣ Sync 和 Send Traits：");
    
    println!("  Send trait：");
    println!("  - 允许在线程间转移所有权");
    println!("  - 几乎所有类型都实现了 Send");
    println!("  - Rc<T> 不是 Send（只能单线程使用）");
    
    println!("\n  Sync trait：");
    println!("  - 允许多个线程同时访问");
    println!("  - &T 是 Sync 的，如果 T 是 Sync");
    println!("  - RefCell<T> 和 Cell<T> 不是 Sync");
    
    println!("\n  Arc<T> 是 Send + Sync（如果 T 是 Send + Sync）");
    println!("  Mutex<T> 是 Send + Sync（如果 T 是 Send）");
    
    // 这些 trait 通常是自动实现的
    println!("\n  💡 Send 和 Sync 是 marker traits");
    println!("  编译器会自动推断和检查");
    println!("  手动实现这些 trait 是不安全的");
}
