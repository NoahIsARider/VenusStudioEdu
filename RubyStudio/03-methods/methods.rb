# Ruby 方法与闭包示例

puts "=== 1. 定义方法 ==="
def add(a, b)
    a + b
end

puts "add(5, 3) = #{add(5, 3)}"

def greet(name = "Guest")
    "Hello, #{name}!"
end

puts greet("Alice")
puts greet

puts "\n=== 2. 块 (Block) 与 Yield ==="
def run_twice
    yield
    yield
end

run_twice { puts "Block 被执行！" }

puts "\n=== 3. Lambda 与 Proc ==="
my_proc = Proc.new { |x| x * 2 }
puts "Proc 计算 4 * 2 = #{my_proc.call(4)}"

my_lambda = ->(x) { x * 3 }
puts "Lambda 计算 4 * 3 = #{my_lambda.call(4)}"
