object Collections {
  def main(args: Array[String]): Unit = {
    println("=== 1. 列表 (List) 与集 (Set) ===")
    val fruits = List("apple", "banana", "cherry")
    println(s"水果列表: $fruits")
    println(s"第一个水果: ${fruits.head}")

    val numbers = Set(1, 2, 2, 3, 4)
    println(s"去重集合 Set: $numbers")

    println("\n=== 2. 映射 (Map) ===")
    val scores = Map("Alice" -> 90, "Bob" -> 85, "Charlie" -> 95)
    println(s"Alice 的分数: ${scores.getOrElse("Alice", 0)}")
  }
}
Collections.main(Array())
