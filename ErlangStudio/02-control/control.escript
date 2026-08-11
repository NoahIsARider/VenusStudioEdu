#!/usr/bin/env escript
%% -*- erlang -*-
%% coding: utf-8
%% =====================================================
%% 02-control/control.escript
%% Erlang 控制流：if、case、守卫、列表推导
%% =====================================================

main(_) ->
    io:setopts([{encoding, unicode}]),

    io:format("~n=== 1. if 表达式 ===~n"),

    %% Erlang 的 if 也是表达式，必须有 else 分支
    Score = 85,
    Grade = if Score >= 90 -> "A";
               Score >= 80 -> "B";
               Score >= 60 -> "C";
               true        -> "D"      %% true 作为默认分支
            end,
    io:format("成绩 ~p: 等级 ~ts~n", [Score, Grade]),

    io:format("~n=== 2. case 表达式 ===~n"),

    %% case 模式匹配
    Result1 = {ok, 42},
    Output1 = case Result1 of
        {ok, Value} -> io_lib:format("成功，值 = ~p", [Value]);
        {error, Reason} -> io_lib:format("失败: ~p", [Reason]);
        _ -> "未知结果"
    end,
    io:format("Result1 = ~ts~n", [Output1]),

    Result2 = {error, timeout},
    Output2 = case Result2 of
        {ok, V2} -> io_lib:format("成功，值 = ~p", [V2]);
        {error, R2} -> io_lib:format("失败原因: ~p", [R2]);
        _ -> "未知结果"
    end,
    io:format("Result2 = ~ts~n", [Output2]),

    io:format("~n=== 3. case 配合守卫 ===~n"),

    Number = 7,
    Description = case Number of
        N when N > 0, N rem 2 =:= 0 -> "正偶数";
        N when N > 0 -> "正奇数";
        N when N < 0 -> "负数";
        _ -> "零"
    end,
    io:format("~p 是 ~ts~n", [Number, Description]),

    io:format("~n=== 4. 列表推导（List Comprehension） ===~n"),

    Squares = [X * X || X <- lists:seq(1, 10)],
    io:format("1~~10 的平方: ~w~n", [Squares]),

    %% 带过滤条件
    Evens = [X || X <- lists:seq(1, 20), X rem 2 =:= 0],
    io:format("1~~20 的偶数: ~w~n", [Evens]),

    %% 多个生成器（笛卡尔积）
    Pairs = [{X, Y} || X <- [1, 2], Y <- [a, b]],
    io:format("笛卡尔积: ~w~n", [Pairs]),

    %% 多条件
    Special = [X || X <- lists:seq(1, 30), X rem 3 =:= 0, X rem 5 =:= 0],
    io:format("同时被3和5整除: ~w~n", [Special]),

    io:format("~n=== 5. 位语法（Bit Syntax） ===~n"),

    %% 二进制数据构造和匹配
    Bin = <<1, 2, 3, 4, 5>>,
    io:format("二进制: ~w~n", [Bin]),

    %% 拆分二进制
    <<A, B, Rest/binary>> = Bin,
    io:format("前两个字节: ~p, ~p，剩余: ~w~n", [A, B, Rest]),

    %% 整数转二进制
    Data = <<16#FF:16, 16#1234:16>>,
    io:format("16位整数拼接: ~w~n", [Data]),
    <<High:16, Low:16>> = Data,
    io:format("拆分: ~p, ~p~n", [High, Low]),

    io:format("~n=== 6. 递归列表处理（替换循环） ===~n"),

    List = [3, 1, 4, 1, 5, 9, 2, 6],
    io:format("列表: ~w~n", [List]),
    io:format("总和: ~p~n", [sum(List)]),
    io:format("最大值: ~p~n", [max_el(List)]),
    io:format("反转: ~w~n", [rev(List)]).

%% 自定义递归函数
sum([]) -> 0;
sum([H | T]) -> H + sum(T).

max_el([H | T]) -> max_el(T, H).
max_el([], M) -> M;
max_el([H | T], M) when H > M -> max_el(T, H);
max_el([_ | T], M) -> max_el(T, M).

rev(L) -> rev(L, []).
rev([], Acc) -> Acc;
rev([H | T], Acc) -> rev(T, [H | Acc]).
