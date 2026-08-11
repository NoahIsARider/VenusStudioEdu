#!/usr/bin/env escript
%% -*- erlang -*-
%% coding: utf-8
%% =====================================================
%% 06-concurrency/concurrency.escript
%% Erlang 并发：进程、消息传递、选择接收
%% =====================================================

main(_) ->
    io:setopts([{encoding, unicode}]),

    io:format("~n=== 1. 创建进程（spawn） ===~n"),

    %% spawn 创建新进程，返回进程标识 Pid
    Pid = spawn(fun() -> io:format("子进程 ~p 运行中~n", [self()]) end),
    io:format("父进程 ~p 创建了子进程 ~p~n", [self(), Pid]),
    timer:sleep(100),

    io:format("~n=== 2. 进程间消息传递 ===~n"),

    %% 子进程接收消息并回复
    Echo = spawn(fun() -> echo_loop() end),
    Echo ! {ping, self()},
    receive
        {pong, Msg} -> io:format("收到回复: ~ts~n", [Msg])
    after 1000 -> io:format("等待回复超时~n")
    end,

    io:format("~n=== 3. 进程通信示例：注册进程 ===~n"),

    %% 注册进程名
    register(worker, spawn(fun() -> worker_loop() end)),

    %% 通过注册名发消息
    worker ! {task, 1, self()},
    worker ! {task, 2, self()},
    collect_replies(2),

    io:format("~n=== 4. 进程状态保持（计数器） ===~n"),

    %% 有状态的进程：计数器
    CounterPid = spawn(fun() -> counter(0) end),
    CounterPid ! {increment, self()},
    CounterPid ! {increment, self()},
    CounterPid ! {get, self()},
    receive
        {value, V} -> io:format("计数器最终值: ~p~n", [V])
    end,
    CounterPid ! stop,

    io:format("~n=== 5. 并行计算（并发求和） ===~n"),

    %% 分片并行求和（1~100 分成 4 段）
    Results = [
        spawn_worker(1, 25),
        spawn_worker(26, 50),
        spawn_worker(51, 75),
        spawn_worker(76, 100)
    ],
    _ = [W ! {go, self()} || W <- Results],
    Total = collect_partial(Results, 0),
    io:format("1~~100 并发求和: ~p~n", [Total]),

    io:format("~n=== 6. 并发进程与监控 ===~n"),

    %% 链接和监控
    _Parent = self(),
    Monitored = spawn(fun() ->
        timer:sleep(200),
        exit(normal)    %% 正常退出
    end),
    Ref = erlang:monitor(process, Monitored),
    receive
        {'DOWN', Ref, process, Monitored, Reason} ->
            io:format("进程 ~p 已退出，原因: ~p~n", [Monitored, Reason])
    end,

    io:format("~n=== 7. 并发累加（每个进程独立工作） ===~n"),

    %% 创建多个独立计数器
    [start_counter(Name) || Name <- [a, b, c]],
    timer:sleep(100),
    io:format("并发演示完成~n").

%% === 辅助函数 ===

%% 回显循环
echo_loop() ->
    receive
        {ping, From} ->
            From ! {pong, "pong"},
            echo_loop();
        stop -> ok
    end.

%% 工作进程：接收任务并回复
worker_loop() ->
    receive
        {task, N, From} ->
            Result = N * N,
            From ! {done, self(), N, Result},
            worker_loop()
    end.

%% 收集 worker 回复
collect_replies(0) -> ok;
collect_replies(N) ->
    receive
        {done, Pid, TaskN, Result} ->
            io:format("任务 ~p 由 ~p 完成: 结果 ~p~n", [TaskN, Pid, Result]),
            collect_replies(N - 1)
    after 1000 ->
        io:format("等待回复超时~n")
    end.

%% 有状态计数器
counter(Value) ->
    receive
        {increment, _} -> counter(Value + 1);
        {get, From} -> From ! {value, Value}, counter(Value);
        stop -> ok
    end.

%% 分片求和工作进程
spawn_worker(From, To) ->
    spawn(fun() ->
        receive
            {go, Parent} ->
                Parent ! {partial, self(), range_sum(From, To)}
        end
    end).

range_sum(From, To) -> lists:sum(lists:seq(From, To)).

collect_partial([], Acc) -> Acc;
collect_partial([Pid | T], Acc) ->
    receive
        {partial, Pid, Sum} -> collect_partial(T, Acc + Sum)
    after 1000 ->
        collect_partial(T, Acc)
    end.

%% 独立计数器演示
start_counter(Name) ->
    spawn(fun() ->
        io:format("进程 ~p 启动（标签 ~p）~n", [self(), Name]),
        receive stop -> ok end
    end).
