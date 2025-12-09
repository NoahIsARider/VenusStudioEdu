// 第11章：智能指针
// Box、Rc、RefCell、Weak

use std::rc::Rc;
use std::cell::RefCell;

pub fn run() {
    println!("--- 智能指针 (Smart Pointers) ---");
    
    // 1. Box<T> - 堆上分配
    demo_box();
    
    // 2. Rc<T> - 引用计数
    demo_rc();
    
    // 3. RefCell<T> - 内部可变性
    demo_refcell();
    
    // 4. 组合使用
    demo_combinations();
    
    // 5. Weak<T> - 弱引用
    demo_weak();
}

fn demo_box() {
    println!("\n1️⃣ Box<T> - 堆上分配：");
    
    // 在堆上存储值
    let b = Box::new(5);
    println!("  Box 值：{}", b);
    
    // 递归类型（必须使用 Box）
    #[derive(Debug)]
    enum List {
        Cons(i32, Box<List>),
        Nil,
    }
    
    use List::{Cons, Nil};
    
    let list = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))));
    println!("  递归链表：{:?}", list);
    
    // Box 的使用场景：
    println!("  Box 的使用场景：");
    println!("  - 在编译时大小未知的类型");
    println!("  - 大量数据需要转移所有权但不想复制");
    println!("  - 只关心类型实现了某个 trait 而不关心具体类型");
}

fn demo_rc() {
    println!("\n2️⃣ Rc<T> - 引用计数（单线程）：");
    
    // Rc 允许多个所有者
    #[derive(Debug)]
    enum List {
        Cons(i32, Rc<List>),
        Nil,
    }
    
    use List::{Cons, Nil};
    
    let a = Rc::new(Cons(5, Rc::new(Cons(10, Rc::new(Nil)))));
    println!("  创建 a，引用计数：{}", Rc::strong_count(&a));
    
    let b = Cons(3, Rc::clone(&a));
    println!("  创建 b 后，a 的引用计数：{}", Rc::strong_count(&a));
    
    {
        let c = Cons(4, Rc::clone(&a));
        println!("  创建 c 后，a 的引用计数：{}", Rc::strong_count(&a));
        println!("  b: {:?}", b);
        println!("  c: {:?}", c);
    }
    
    println!("  c 离开作用域后，a 的引用计数：{}", Rc::strong_count(&a));
    
    println!("  ⚠️  Rc 只能用于单线程！");
}

fn demo_refcell() {
    println!("\n3️⃣ RefCell<T> - 内部可变性：");
    
    println!("  RefCell 允许在有不可变引用时修改数据");
    println!("  借用规则在运行时检查，而不是编译时");
    
    let data = RefCell::new(5);
    
    println!("  初始值：{}", data.borrow());
    
    // 可变借用
    *data.borrow_mut() += 10;
    println!("  修改后：{}", data.borrow());
    
    // 多个不可变借用
    let r1 = data.borrow();
    let r2 = data.borrow();
    println!("  多个不可变借用：{}, {}", r1, r2);
    drop(r1);
    drop(r2);
    
    // 内部可变性模式示例
    trait Messenger {
        fn send(&self, msg: &str);
    }
    
    struct MockMessenger {
        sent_messages: RefCell<Vec<String>>,
    }
    
    impl MockMessenger {
        fn new() -> MockMessenger {
            MockMessenger {
                sent_messages: RefCell::new(vec![]),
            }
        }
    }
    
    impl Messenger for MockMessenger {
        fn send(&self, message: &str) {
            // 即使 self 是不可变引用，仍可修改内部数据
            self.sent_messages.borrow_mut().push(String::from(message));
        }
    }
    
    let messenger = MockMessenger::new();
    messenger.send("消息 1");
    messenger.send("消息 2");
    println!("  发送的消息：{:?}", messenger.sent_messages.borrow());
    
    println!("  ⚠️  如果违反借用规则，程序会在运行时 panic");
}

fn demo_combinations() {
    println!("\n4️⃣ 组合使用 Rc<RefCell<T>>：");
    
    // Rc<RefCell<T>> 允许多个所有者修改数据
    #[derive(Debug)]
    enum List {
        Cons(Rc<RefCell<i32>>, Rc<List>),
        Nil,
    }
    
    use List::{Cons, Nil};
    
    let value = Rc::new(RefCell::new(5));
    
    let a = Rc::new(Cons(Rc::clone(&value), Rc::new(Nil)));
    let b = Cons(Rc::new(RefCell::new(3)), Rc::clone(&a));
    let c = Cons(Rc::new(RefCell::new(4)), Rc::clone(&a));
    
    println!("  初始 a：{:?}", a);
    println!("  初始 b：{:?}", b);
    println!("  初始 c：{:?}", c);
    
    // 修改共享的值
    *value.borrow_mut() += 10;
    
    println!("  修改后 a：{:?}", a);
    println!("  修改后 b：{:?}", b);
    println!("  修改后 c：{:?}", c);
    
    println!("  Rc<RefCell<T>> 组合了：");
    println!("  - 多个所有者（Rc）");
    println!("  - 内部可变性（RefCell）");
}

fn demo_weak() {
    println!("\n5️⃣ Weak<T> - 弱引用：");
    
    use std::rc::Weak;
    
    #[derive(Debug)]
    struct Node {
        value: i32,
        parent: RefCell<Weak<Node>>,
        children: RefCell<Vec<Rc<Node>>>,
    }
    
    // 创建父节点
    let leaf = Rc::new(Node {
        value: 3,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![]),
    });
    
    println!("  leaf 的强引用计数：{}", Rc::strong_count(&leaf));
    println!("  leaf 的弱引用计数：{}", Rc::weak_count(&leaf));
    
    {
        let branch = Rc::new(Node {
            value: 5,
            parent: RefCell::new(Weak::new()),
            children: RefCell::new(vec![Rc::clone(&leaf)]),
        });
        
        *leaf.parent.borrow_mut() = Rc::downgrade(&branch);
        
        println!("\n  branch 的强引用计数：{}", Rc::strong_count(&branch));
        println!("  branch 的弱引用计数：{}", Rc::weak_count(&branch));
        
        println!("\n  leaf 的强引用计数：{}", Rc::strong_count(&leaf));
        println!("  leaf 的弱引用计数：{}", Rc::weak_count(&leaf));
        
        // 访问父节点
        println!("\n  leaf 的父节点：{:?}", 
                 leaf.parent.borrow().upgrade().map(|n| n.value));
    }
    
    println!("\n  branch 离开作用域后");
    println!("  leaf 的父节点：{:?}", 
             leaf.parent.borrow().upgrade());
    
    println!("\n  Weak<T> 用于：");
    println!("  - 防止循环引用");
    println!("  - 父子关系（父节点拥有子节点，子节点弱引用父节点）");
}
