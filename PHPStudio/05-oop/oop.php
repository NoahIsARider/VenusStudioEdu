<?php
// =====================================================
// 05-oop/oop.php
// PHP 面向对象编程：类、继承、抽象类、接口、trait
// =====================================================

// PHP 提供完整的面向对象支持：封装、继承、多态、抽象、接口、trait。

function demoOop(): void
{
    echo "\n=== 1. 类与对象基础 ===\n";

    // 定义类：属性、方法、构造函数
    class Animal
    {
        // 属性（成员变量），可声明可见性和类型
        public string $name;
        protected int $age;
        private bool $isAlive;

        // 类常量
        public const KINGDOM = "动物界";

        // 构造函数（PHP 8.0+ 支持构造函数属性提升，简化属性声明）
        public function __construct(string $name, int $age)
        {
            $this->name = $name;
            $this->age = $age;
            $this->isAlive = true;
        }

        // 方法
        public function describe(): string
        {
            return $this->name . "，" . $this->age . " 岁";
        }

        // 访问受保护属性（通过方法）
        public function getAge(): int
        {
            return $this->age;
        }

        // 静态方法
        public static function getKingdom(): string
        {
            return self::KINGDOM;
        }
    }

    // 创建对象
    $cat = new Animal("小猫", 3);
    echo "名称: " . $cat->name . "\n";
    echo "描述: " . $cat->describe() . "\n";
    echo "类常量: " . Animal::KINGDOM . "\n";
    echo "静态方法: " . Animal::getKingdom() . "\n";

    echo "\n=== 2. 可见性（public / protected / private） ===\n";

    // public: 任何地方可访问
    // protected: 类内和子类可访问
    // private: 仅本类可访问
    echo "public 属性 name: " . $cat->name . "\n";
    echo "protected 通过方法 getAge(): " . $cat->getAge() . "\n";
    // echo $cat->age;       // 报错：protected 不可外部访问
    // echo $cat->isAlive;   // 报错：private 不可外部访问

    echo "\n=== 3. 继承 ===\n";

    // extends 继承父类
    class Dog extends Animal
    {
        public string $breed;

        public function __construct(string $name, int $age, string $breed)
        {
            parent::__construct($name, $age);   // 调用父类构造函数
            $this->breed = $breed;
        }

        // 重写父类方法
        public function describe(): string
        {
            return parent::describe() . "，品种: " . $this->breed;
        }

        // 子类特有方法
        public function bark(): string
        {
            return $this->name . " 汪汪叫！";
        }
    }

    $dog = new Dog("旺财", 5, "金毛");
    echo "继承描述: " . $dog->describe() . "\n";
    echo "子类方法: " . $dog->bark() . "\n";

    echo "\n=== 4. 抽象类 ===\n";

    // 抽象类不能被实例化，只能被继承
    abstract class Shape
    {
        abstract public function area(): float;       // 抽象方法，子类必须实现

        public function describe(): string
        {
            return "形状面积: " . $this->area();
        }
    }

    class Circle extends Shape
    {
        public function __construct(private float $radius) {}

        public function area(): float
        {
            return M_PI * $this->radius ** 2;
        }
    }

    class Rectangle extends Shape
    {
        public function __construct(private float $width, private float $height) {}

        public function area(): float
        {
            return $this->width * $this->height;
        }
    }

    $circle = new Circle(5);
    $rect = new Rectangle(4, 6);
    echo "圆形 r=5: " . round($circle->area(), 2) . "\n";
    echo "矩形 4x6: " . $rect->area() . "\n";

    echo "\n=== 5. 接口 ===\n";

    // 接口定义方法契约，类可实现多个接口
    interface Comparable
    {
        public function compareTo(object $other): int;
    }

    interface Printable
    {
        public function print(): string;
    }

    // 一个类可实现多个接口
    class Product implements Comparable, Printable
    {
        public function __construct(
            public string $name,
            public float $price
        ) {}

        public function compareTo(object $other): int
        {
            if (!$other instanceof Product) {
                throw new TypeError("只能与 Product 比较");
            }
            return $this->price <=> $other->price;
        }

        public function print(): string
        {
            return "商品: {$this->name}，价格: {$this->price} 元";
        }
    }

    $p1 = new Product("手机", 2999);
    $p2 = new Product("电脑", 5999);
    echo $p1->print() . "\n";
    echo $p2->print() . "\n";
    echo "价格比较: " . $p1->compareTo($p2) . " (p1 < p2 返回 -1)\n";

    echo "\n=== 6. trait（代码复用） ===\n";

    // trait 解决单继承限制，可复用方法集
    trait Timestampable
    {
        protected ?string $createdAt = null;
        protected ?string $updatedAt = null;

        public function touch(): void
        {
            $this->updatedAt = date('Y-m-d H:i:s');
            if ($this->createdAt === null) {
                $this->createdAt = $this->updatedAt;
            }
        }

        public function getCreatedAt(): ?string
        {
            return $this->createdAt;
        }
    }

    class Article
    {
        use Timestampable;       // 使用 trait

        public function __construct(public string $title) {}
    }

    $article = new Article("PHP 教程");
    $article->touch();
    echo "文章: " . $article->title . "\n";
    echo "创建时间: " . $article->getCreatedAt() . "\n";

    echo "\n=== 7. 静态属性与方法 ===\n";

    class Counter
    {
        private static int $count = 0;   // 静态属性，所有实例共享

        public function __construct()
        {
            self::$count++;
        }

        public static function getCount(): int
        {
            return self::$count;
        }
    }

    new Counter();
    new Counter();
    new Counter();
    echo "实例化次数: " . Counter::getCount() . "\n";

    echo "\n=== 8. instanceof 类型检查 ===\n";

    echo "dog instanceof Animal: " . var_export($dog instanceof Animal, true) . "\n";
    echo "circle instanceof Shape: " . var_export($circle instanceof Shape, true) . "\n";
    echo "p1 instanceof Printable: " . var_export($p1 instanceof Printable, true) . "\n";
}
