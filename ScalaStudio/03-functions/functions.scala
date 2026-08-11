object Functions {
  def main(args: Array[String]): Unit = {
    println("=== 1. 函数定义与计算 ===")
    def add(a: Int, b: Int): Int = a + b
    println(s"add(3, 4) = ${add(3, 4)}")

    println("\n=== 2. 高阶函数与 Lambda ===")
    val nums = List(1, 2, 3, 4, 5)
    val doubled = nums.map(x => x * 2)
    println(s"原列表: $nums")
    println(s"映射翻倍: $doubled")
  }
}
Functions.main(Array())
