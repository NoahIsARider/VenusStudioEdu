# Ruby 控制流示例

puts "=== 1. 条件语句 (if / unless) ==="
score = 85

if score >= 90
    puts "优秀"
elsif score >= 60
    puts "及格"
else
    puts "不及格"
end

# unless 语句 (相当于 if not)
rained = false
unless rained
    puts "天气不错，出去走走！"
end

puts "\n=== 2. 循环语句 (while / until / times) ==="
counter = 1
while counter <= 3
    puts "While 循环计数: #{counter}"
    counter += 1
end

3.times do |i|
    puts "Times 迭代: #{i + 1}"
end

puts "\n=== 3. 迭代器 (each) ==="
[10, 20, 30].each do |num|
    puts "数组元素: #{num}"
end
