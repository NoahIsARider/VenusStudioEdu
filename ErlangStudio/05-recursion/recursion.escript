#!/usr/bin/env escript
%% -*- erlang -*-
%% coding: utf-8
%% =====================================================
%% 05-recursion/recursion.escript
%% Erlang 递归：经典递归、尾递归、递归构建数据
%% =====================================================

main(_) ->
    io:setopts([{encoding, unicode}]),

    io:format("~n=== 1. 递归基础（阶乘） ===~n"),

    io:format("factorial(5) = ~p~n", [factorial(5)]),
    io:format("factorial(10) = ~p~n", [factorial(10)]),

    io:format("~n=== 2. 尾递归（避免栈溢出） ===~n"),

    %% 普通递归 vs 尾递归
    io:format("tail_factorial(1000) 可以正常工作~n"),
    io:format("tail_factorial(20) = ~p~n", [tail_factorial(20)]),

    io:format("~n=== 3. 列表递归 ===~n"),

    List = [1, 2, 3, 4, 5],
    io:format("列表: ~w~n", [List]),
    io:format("求和: ~p~n", [sum(List)]),
    io:format("长度: ~p~n", [len(List)]),
    io:format("反转: ~w~n", [reverse(List)]),
    io:format("复制 n 次: ~w~n", [duplicate(3, "abc")]),

    io:format("~n=== 4. 递归构建序列 ===~n"),

    io:format("0~~9: ~w~n", [seq(0, 9)]),
    io:format("前10个斐波那契: ~w~n", [fib_list(10)]),
    io:format("前10个阶乘: ~w~n", [fact_list(10)]),

    io:format("~n=== 5. 分治算法（快速排序） ===~n"),

    Unsorted = [9, 3, 7, 1, 8, 2, 6, 5],
    io:format("快速排序: ~w -> ~w~n", [Unsorted, qsort(Unsorted)]),

    io:format("~n=== 6. 递归与累加器模式 ===~n"),

    io:format("列表转字符串: ~ts~n", [join("abc", ",")]),
    io:format("偶数提取: ~w~n", [filter_even([1, 2, 3, 4, 5, 6, 7, 8])]),
    io:format("map 自实现: ~w~n", [my_map(fun(X) -> X * X end, [1, 2, 3])]),

    io:format("~n=== 7. 尾递归 vs 非尾递归 对比 ===~n"),

    %% 展示两种实现的差异
    io:format("非尾递归 sum: ~p~n", [sum([1, 2, 3])]),
    io:format("尾递归 sum2: ~p~n", [sum2([1, 2, 3])]).

%% === 函数定义 ===

%% 非尾递归阶乘
factorial(0) -> 1;
factorial(N) -> N * factorial(N - 1).

%% 尾递归阶乘（使用累加器）
tail_factorial(N) -> tail_factorial(N, 1).
tail_factorial(0, Acc) -> Acc;
tail_factorial(N, Acc) -> tail_factorial(N - 1, N * Acc).

%% 列表求和（非尾递归）
sum([]) -> 0;
sum([H | T]) -> H + sum(T).

%% 列表求和（尾递归）
sum2(L) -> sum2(L, 0).
sum2([], Acc) -> Acc;
sum2([H | T], Acc) -> sum2(T, Acc + H).

%% 列表长度
len([]) -> 0;
len([_ | T]) -> 1 + len(T).

%% 反转（尾递归）
reverse(L) -> reverse(L, []).
reverse([], Acc) -> Acc;
reverse([H | T], Acc) -> reverse(T, [H | Acc]).

%% 复制元素 n 次
duplicate(0, _) -> [];
duplicate(N, Elem) when N > 0 -> [Elem | duplicate(N - 1, Elem)].

%% 生成范围序列
seq(From, To) when From > To -> [];
seq(From, To) -> [From | seq(From + 1, To)].

%% 斐波那契数列（前 n 个）
fib_list(N) -> fib_list(N, 0, 1, []).
fib_list(0, _A, _B, Acc) -> lists:reverse(Acc);
fib_list(N, A, B, Acc) -> fib_list(N - 1, B, A + B, [A | Acc]).

%% 阶乘数列（1! 到 N!）
fact_list(N) -> [factorial(X) || X <- lists:seq(1, N)].

%% 快速排序（分治）
qsort([]) -> [];
qsort([Pivot | T]) ->
    qsort([X || X <- T, X =< Pivot]) ++ [Pivot] ++ qsort([X || X <- T, X > Pivot]).

%% 列表转字符串（连接）
join([], _Sep) -> "";
join([H], _Sep) -> [H];
join([H | T], Sep) -> [H] ++ Sep ++ join(T, Sep).

%% 过滤偶数
filter_even(L) -> [X || X <- L, X rem 2 =:= 0].

%% 自实现 map
my_map(_F, []) -> [];
my_map(F, [H | T]) -> [F(H) | my_map(F, T)].
