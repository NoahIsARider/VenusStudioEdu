#!/usr/bin/env escript
%% -*- erlang -*-
%% coding: utf-8
%% =====================================================
%% 07-errors/errors.escript
%% Erlang 错误处理：throw、error、exit、try/catch
%% =====================================================

main(_) ->
    io:setopts([{encoding, unicode}]),

    io:format("~n=== 1. 三种异常类型 ===~n"),

    %% 1. throw: 用于控制流
    try throw(example_throw)
    catch throw:Value -> io:format("捕获 throw: ~p~n", [Value])
    end,

    %% 2. error: 表示逻辑错误
    try error(example_error)
    catch error:ErrReason -> io:format("捕获 error: ~p~n", [ErrReason])
    end,

    %% 3. exit: 进程退出信号
    try exit(example_exit)
    catch exit:ExitReason -> io:format("捕获 exit: ~p~n", [ExitReason])
    end,

    io:format("~n=== 2. try/catch 完整捕获 ===~n"),

    try
        throw({my_error, "自定义错误"})
    catch
        throw:{my_error, Msg} -> io:format("捕获 throw: ~ts~n", [Msg]);
        error:Err -> io:format("捕获 error: ~p~n", [Err]);
        exit:Exit -> io:format("捕获 exit: ~p~n", [Exit])
    end,

    io:format("~n=== 3. try/catch 返回成功值 ===~n"),

    Result = try
        safe_divide(10, 2)
    catch
        error:badarith -> undefined
    end,
    io:format("safe_divide(10, 2) = ~p~n", [Result]),

    Result2 = try
        safe_divide(10, 0)
    catch
        error:badarith -> undefined
    end,
    io:format("safe_divide(10, 0) = ~p~n", [Result2]),

    io:format("~n=== 4. after 子句（始终执行） ===~n"),

    try
        io:format("~ts~n", ["在 try 块中执行"])
    after
        io:format("~ts~n", ["after 子句总会执行"])
    end,

    io:format("~n=== 5. 错误传播与处理 ===~n"),

    %% 处理可能失败的函数
    case parse_integer("123") of
        {ok, N1} -> io:format("解析成功: ~p~n", [N1]);
        {error, Reason} -> io:format("解析失败: ~ts~n", [Reason])
    end,

    case parse_integer("abc") of
        {ok, N2} -> io:format("解析成功: ~p~n", [N2]);
        {error, Reason2} -> io:format("解析失败: ~ts~n", [Reason2])
    end,

    io:format("~n=== 6. 异常堆栈与上下文 ===~n"),

    try
        call_chain_1()
    catch
        Class:Cause:Stacktrace ->
            io:format("异常类型: ~p~n", [Class]),
            io:format("异常原因: ~p~n", [Cause]),
            io:format("堆栈帧数: ~p~n", [length(Stacktrace)])
    end,

    io:format("~n=== 7. 进程级错误处理 ===~n"),

    %% 链接进程：一个进程崩溃，另一个收到 'EXIT' 信号
    process_flag(trap_exit, true),
    Pid = spawn_link(fun() -> exit(boom) end),
    receive
        {'EXIT', Pid, EXReason} -> io:format("收到子进程退出: ~p~n", [EXReason])
    after 1000 -> io:format("等待退出信号超时~n")
    end,

    io:format("~n=== 8. 函数式错误处理模式 ===~n"),

    %% option 类型（Maybe 模式）
    Divide = fun(A, B) ->
        case B of
            0 -> nothing;
            _ -> {just, A / B}
        end
    end,
    case Divide(10, 2) of
        {just, V} -> io:format("除法结果: ~p~n", [V]);
        nothing -> io:format("除数为零~n")
    end.

%% === 辅助函数 ===

%% 安全除法
safe_divide(_A, 0) -> error(badarith);
safe_divide(A, B) -> A / B.

%% 整数解析（返回 {ok, N} 或 {error, Reason}）
parse_integer(S) ->
    try
        {ok, list_to_integer(S)}
    catch
        error:badarg -> {error, "不是有效的整数"}
    end.

%% 调用链制造异常
call_chain_1() -> call_chain_2().
call_chain_2() -> call_chain_3().
call_chain_3() -> throw("链式异常").
