#!/usr/bin/env escript
%% -*- erlang -*-
%% coding: utf-8
%% =====================================================
%% 03-functions/functions.escript
%% Erlang 函数：模式匹配、守卫、匿名函数、高阶函数
%% =====================================================

main(_) ->
    io:setopts([{encoding, unicode}]),

    io:format("~n=== 1. 函数多子句（模式匹配分派） ===~n"),

    io:format("factorial(5) = ~p~n", [factorial(5)]),
    io:format("fibonacci(10) = ~p~n", [fibonacci(10)]),

    io:format("~n=== 2. 守卫选择函数 ==~n"),

    io:format("f(-5) = ~p~n", [f(-5)]),
    io:format("f(0) = ~p~n", [f(0)]),
    io:format("f(5) = ~p~n", [f(5)]),

    io:format("~n=== 3. 匿名函数（fun） ===~n"),

    %% 匿名函数赋值
    Double = fun(X) -> X * 2 end,
    io:format("Double(21) = ~p~n", [Double(21)]),

    %% 带守卫的匿名函数
    Classify = fun(N) when N > 0 -> positive;
                   (N) when N < 0 -> negative;
                   (_) -> zero
               end,
    io:format("Classify(5) = ~p, Classify(-3) = ~p~n", [Classify(5), Classify(-3)]),

    %% 立即调用
    Result = (fun(A, B) -> A + B end)(3, 4),
    io:format("立即调用匿名函数: ~p~n", [Result]),

    io:format("~n=== 4. 高阶函数 ===~n"),

    List = [1, 2, 3, 4, 5],

    %% map 变换
    Doubled = lists:map(fun(X) -> X * 2 end, List),
    io:format("map 翻倍: ~w~n", [Doubled]),

    %% filter 过滤
    Evens = lists:filter(fun(X) -> X rem 2 =:= 0 end, List),
    io:format("filter 偶数: ~w~n", [Evens]),

    %% foldl 归约
    Total = lists:foldl(fun(X, Acc) -> Acc + X end, 0, List),
    io:format("foldl 求和: ~p~n", [Total]),

    %% foreach 遍历
    lists:foreach(fun(X) -> io:format("~p ", [X]) end, List),
    io:format("（foreach 遍历）~n"),

    io:format("~n=== 5. 函数作为返回值（闭包） ===~n"),

    %% 构造加法器
    Adder = create_adder(10),
    io:format("Adder(5) = ~p, Adder(20) = ~p~n", [Adder(5), Adder(20)]),

    %% 纯函数式计数器：每次返回 {当前值, 下一个计数器}
    Counter = create_counter(),
    {V1, Counter2} = Counter(),
    {V2, Counter3} = Counter2(),
    {V3, _} = Counter3(),
    io:format("纯函数式计数: ~p ~p ~p~n", [V1, V2, V3]),

    io:format("~n=== 6. 命名 fun 递归 ===~n"),

    %% 命名 fun 可以递归引用自身
    Fact = fun F(0) -> 1;
              F(N) -> N * F(N - 1)
           end,
    io:format("命名 fun 阶乘(6) = ~p~n", [Fact(6)]),

    io:format("~n=== 7. 内置高阶函数 ===~n"),

    io:format("lists:reverse: ~w~n", [lists:reverse([1, 2, 3])]),
    io:format("lists:sort: ~w~n", [lists:sort([3, 1, 2])]),
    io:format("lists:max: ~p~n", [lists:max([3, 1, 2, 7])]),
    io:format("lists:member(2, [1,2,3]): ~p~n", [lists:member(2, [1, 2, 3])]),
    io:format("lists:zip: ~w~n", [lists:zip([1, 2], [a, b])]).

%% 尾递归阶乘
factorial(N) -> factorial(N, 1).
factorial(0, Acc) -> Acc;
factorial(N, Acc) -> factorial(N - 1, N * Acc).

%% 斐波那契
fibonacci(0) -> 0;
fibonacci(1) -> 1;
fibonacci(N) -> fibonacci(N - 1) + fibonacci(N - 2).

%% 多子句 + 守卫
f(N) when N > 0 -> N * 2;
f(N) when N < 0 -> abs(N);
f(_) -> 0.

%% 返回函数（闭包）
create_adder(N) ->
    fun(X) -> X + N end.

%% 状态闭包（纯函数式：返回 {值, 下一个状态函数}）
create_counter() -> fun() -> counter_next(0) end.
counter_next(N) -> {N, fun() -> counter_next(N + 1) end}.
