# Ruby 集合示例 (数组与哈希)

puts "=== 1. 数组 (Array) ==="
fruits = ["apple", "banana", "cherry"]
fruits.push("orange")
puts "水果列表: #{fruits.inspect}"
puts "第一个元素: #{fruits.first}"
puts "元素个数: #{fruits.length}"

doubled = [1, 2, 3].map { |n| n * 2 }
puts "映射翻倍: #{doubled.inspect}"

puts "\n=== 2. 哈希 (Hash) ==="
person = { "name" => "Bob", "age" => 30, "city" => "Beijing" }
# 也可以使用符号作为键
student = { name: "Alice", grade: "A", score: 95 }

puts "Person 名字: #{person["name"]}"
puts "Student 分数: #{student[:score]}"

student.each do |key, value|
    puts "#{key}: #{value}"
end
