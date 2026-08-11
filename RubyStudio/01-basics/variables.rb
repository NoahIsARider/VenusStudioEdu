# Ruby 基础语法与变量示例

puts "=== 1. 变量与常量 ==="
name = "RubyStudio"
version = 3.2
PI = 3.14159

puts "语言名称: #{name}"
puts "版本: #{version}"
puts "常量 PI: #{PI}"

puts "\n=== 2. 基本数据类型 ==="
age = 25
price = 99.99
is_active = true
nothing = nil

puts "Integer: #{age} (#{age.class})"
puts "Float: #{price} (#{price.class})"
puts "Boolean: #{is_active} (#{is_active.class})"
puts "Nil: #{nothing.inspect} (#{nothing.class})"

puts "\n=== 3. 字符串操作 ==="
greeting = "Hello"
target = "World"
full = "#{greeting}, #{target}!"
puts full
puts "大写: #{full.upcase}"
puts "反转: #{full.reverse}"
