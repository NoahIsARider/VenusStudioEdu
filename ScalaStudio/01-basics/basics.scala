object Basics {
  def main(args: Array[String]): Unit = {
    println("=== 1. 变量与常量 ===")
    val name: String = "ScalaStudio" // 不可变
    var version: Double = 3.3      // 可变
    version = 3.4
    
    println(s"项目名称: $name")
    println(s"版本号: $version")

    println("\n=== 2. 基本数据类型 ===")
    val age: Int = 25
    val pi: Double = 3.14159
    val flag: Boolean = true
    println(s"Int: $age, Double: $pi, Boolean: $flag")
  }
}
Basics.main(Array())
