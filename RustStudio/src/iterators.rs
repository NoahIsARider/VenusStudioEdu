// 第10章：迭代器
// 迭代器模式、消费适配器、迭代器适配器

pub fn run() {
    println!("--- 迭代器 (Iterators) ---");
    
    // 1. 迭代器基础
    demo_iterator_basics();
    
    // 2. Iterator trait
    demo_iterator_trait();
    
    // 3. 消费适配器
    demo_consuming_adaptors();
    
    // 4. 迭代器适配器
    demo_iterator_adaptors();
    
    // 5. 自定义迭代器
    demo_custom_iterator();
    
    // 6. 性能对比
    demo_performance();
}

fn demo_iterator_basics() {
    println!("\n1️⃣ 迭代器基础：");
    
    let v = vec![1, 2, 3, 4, 5];
    
    // 使用 for 循环（自动调用 into_iter）
    print!("  for 循环：");
    for val in &v {
        print!("{} ", val);
    }
    println!();
    
    // 显式创建迭代器
    let v1_iter = v.iter();
    
    print!("  显式迭代：");
    for val in v1_iter {
        print!("{} ", val);
    }
    println!();
    
    // 三种迭代方式
    println!("\n  三种迭代方式：");
    
    // iter() - 不可变引用
    print!("  iter()：");
    for val in v.iter() {
        print!("{} ", val);
    }
    println!();
    
    // iter_mut() - 可变引用
    let mut v2 = vec![1, 2, 3];
    print!("  iter_mut()：");
    for val in v2.iter_mut() {
        *val += 10;
        print!("{} ", val);
    }
    println!();
    
    // into_iter() - 获取所有权
    print!("  into_iter()：");
    for val in v.into_iter() {
        print!("{} ", val);
    }
    println!();
    // println!("{:?}", v); // 错误！v 已被移动
}

fn demo_iterator_trait() {
    println!("\n2️⃣ Iterator Trait：");
    
    // Iterator trait 的核心是 next 方法
    let v = vec![1, 2, 3];
    let mut iter = v.iter();
    
    println!("  手动调用 next()：");
    println!("    {:?}", iter.next());
    println!("    {:?}", iter.next());
    println!("    {:?}", iter.next());
    println!("    {:?}", iter.next());
    
    // Iterator trait 定义：
    // trait Iterator {
    //     type Item;
    //     fn next(&mut self) -> Option<Self::Item>;
    // }
}

fn demo_consuming_adaptors() {
    println!("\n3️⃣ 消费适配器：");
    
    // sum - 消耗迭代器，计算总和
    let v = vec![1, 2, 3, 4, 5];
    let total: i32 = v.iter().sum();
    println!("  sum()：{}", total);
    
    // collect - 收集到集合
    let v = vec![1, 2, 3];
    let collected: Vec<i32> = v.iter().map(|x| x * 2).collect();
    println!("  collect()：{:?}", collected);
    
    // for_each - 对每个元素执行操作
    print!("  for_each()：");
    v.iter().for_each(|x| print!("{} ", x));
    println!();
    
    // find - 查找第一个满足条件的元素
    let v = vec![1, 2, 3, 4, 5];
    let found = v.iter().find(|&&x| x > 3);
    println!("  find()：{:?}", found);
    
    // any - 检查是否有元素满足条件
    let has_even = v.iter().any(|&x| x % 2 == 0);
    println!("  any()：{}", has_even);
    
    // all - 检查所有元素是否满足条件
    let all_positive = v.iter().all(|&x| x > 0);
    println!("  all()：{}", all_positive);
    
    // count - 计数
    let count = v.iter().filter(|&&x| x > 2).count();
    println!("  count()：{}", count);
}

fn demo_iterator_adaptors() {
    println!("\n4️⃣ 迭代器适配器：");
    
    let v = vec![1, 2, 3, 4, 5];
    
    // map - 转换每个元素
    let doubled: Vec<i32> = v.iter().map(|x| x * 2).collect();
    println!("  map()：{:?}", doubled);
    
    // filter - 过滤元素
    let evens: Vec<&i32> = v.iter().filter(|&&x| x % 2 == 0).collect();
    println!("  filter()：{:?}", evens);
    
    // enumerate - 添加索引
    print!("  enumerate()：");
    for (i, val) in v.iter().enumerate() {
        print!("({}, {}) ", i, val);
    }
    println!();
    
    // zip - 组合两个迭代器
    let v2 = vec![10, 20, 30, 40, 50];
    let zipped: Vec<(&i32, &i32)> = v.iter().zip(v2.iter()).collect();
    println!("  zip()：{:?}", zipped);
    
    // take - 取前 N 个
    let taken: Vec<&i32> = v.iter().take(3).collect();
    println!("  take(3)：{:?}", taken);
    
    // skip - 跳过前 N 个
    let skipped: Vec<&i32> = v.iter().skip(2).collect();
    println!("  skip(2)：{:?}", skipped);
    
    // chain - 连接两个迭代器
    let v1 = vec![1, 2, 3];
    let v2 = vec![4, 5, 6];
    let chained: Vec<&i32> = v1.iter().chain(v2.iter()).collect();
    println!("  chain()：{:?}", chained);
    
    // rev - 反转
    let reversed: Vec<&i32> = v.iter().rev().collect();
    println!("  rev()：{:?}", reversed);
    
    // 链式调用
    let result: Vec<i32> = v.iter()
        .filter(|&&x| x % 2 == 0)
        .map(|x| x * x)
        .collect();
    println!("  链式调用（偶数平方）：{:?}", result);
}

fn demo_custom_iterator() {
    println!("\n5️⃣ 自定义迭代器：");
    
    // 实现自定义迭代器
    struct Counter {
        count: u32,
        max: u32,
    }
    
    impl Counter {
        fn new(max: u32) -> Counter {
            Counter { count: 0, max }
        }
    }
    
    impl Iterator for Counter {
        type Item = u32;
        
        fn next(&mut self) -> Option<Self::Item> {
            if self.count < self.max {
                self.count += 1;
                Some(self.count)
            } else {
                None
            }
        }
    }
    
    let counter = Counter::new(5);
    print!("  自定义计数器：");
    for num in counter {
        print!("{} ", num);
    }
    println!();
    
    // 使用标准迭代器方法
    let sum: u32 = Counter::new(5).sum();
    println!("  计数器求和：{}", sum);
    
    // 组合使用
    let result: Vec<u32> = Counter::new(10)
        .filter(|x| x % 2 == 0)
        .map(|x| x * 2)
        .collect();
    println!("  计数器组合操作：{:?}", result);
}

fn demo_performance() {
    println!("\n6️⃣ 性能对比：");
    
    println!("  迭代器是零成本抽象！");
    println!("  编译后的迭代器代码与手写循环性能相同");
    
    let v: Vec<i32> = (1..=1000).collect();
    
    // 迭代器方式
    let sum1: i32 = v.iter().sum();
    
    // 循环方式
    let mut sum2 = 0;
    for i in &v {
        sum2 += i;
    }
    
    println!("  迭代器结果：{}", sum1);
    println!("  循环结果：{}", sum2);
    println!("  两者性能相同，但迭代器更简洁、更安全");
}
