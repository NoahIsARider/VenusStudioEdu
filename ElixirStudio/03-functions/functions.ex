defmodule Functions do
  def add(a, b), do: a + b

  def run do
    IO.puts("=== 1. 函数定义与管道操作符 ===")
    IO.puts("add(10, 15) = #{add(10, 15)}")

    result = [1, 2, 3] |> Enum.map(&(&1 * 2)) |> Enum.sum()
    IO.puts("管道计算结果: #{result}")
  end
end
Functions.run()
