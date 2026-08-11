# Ruby 面向对象编程示例

module Greeter
    def say_hello
        puts "#{self.class} 模块打招呼: Hello!"
    end
end

class Animal
    attr_accessor :name, :age

    def initialize(name, age)
        @name = name
        @age = age
    end

    def speak
        puts "#{@name} 发出声音"
    end
end

class Dog < Animal
    include Greeter

    def speak
        puts "#{@name} 汪汪叫！"
    end
end

puts "=== 面向对象测试 ==="
dog = Dog.new("旺财", 3)
dog.speak
dog.say_hello
puts "狗狗名字: #{dog.name}, 年龄: #{dog.age}"
