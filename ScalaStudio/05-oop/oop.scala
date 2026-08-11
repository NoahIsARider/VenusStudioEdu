object OOP {
  class Person(val name: String, var age: Int) {
    def introduce(): Unit = {
      println(s"你好，我是 $name，今年 $age 岁。")
    }
  }

  case class Book(title: String, author: String)

  def main(args: Array[String]): Unit = {
    println("=== 1. 类与对象 ===")
    val p = new Person("张三", 28)
    p.introduce()

    println("\n=== 2. 样例类 (Case Class) ===")
    val book = Book("Scala 编程", "Martin")
    println(s"书名: ${book.title}, 作者: ${book.author}")
  }
}
OOP.main(Array())
