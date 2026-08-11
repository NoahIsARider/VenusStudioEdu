! =====================================================
! 02-control/control.f90
! Fortran 控制流：if/then/else、select case、do 循环、cycle、exit
! =====================================================

program control
    implicit none

    call demo_control()

contains

    subroutine demo_control()
        integer :: i, n, sum
        real :: score
        character(len=10) :: grade

        print *, ""
        print *, "=== 1. if/then/else 语句 ==="

        ! 基本 if 语句
        i = 10
        if (i > 5) then
            print *, "i =", i, " 大于 5"
        end if

        ! if/else 语句
        i = 3
        if (i > 5) then
            print *, "i =", i, " 大于 5"
        else
            print *, "i =", i, " 小于等于 5"
        end if

        ! if/elseif/else 语句
        score = 85.0
        if (score >= 90.0) then
            print *, "成绩:", score, " 等级: A（优秀）"
        else if (score >= 80.0) then
            print *, "成绩:", score, " 等级: B（良好）"
        else if (score >= 70.0) then
            print *, "成绩:", score, " 等级: C（中等）"
        else if (score >= 60.0) then
            print *, "成绩:", score, " 等级: D（及格）"
        else
            print *, "成绩:", score, " 等级: F（不及格）"
        end if

        ! 单行 if 语句（Fortran 风格）
        i = 5
        if (i == 5) print *, "单行 if：i 等于 5"

        print *, ""
        print *, "=== 2. select case 语句 ==="

        ! select case 分支选择
        grade = "B"
        select case (grade)
        case ("A")
            print *, "优秀"
        case ("B")
            print *, "良好"
        case ("C")
            print *, "中等"
        case ("D")
            print *, "及格"
        case ("F")
            print *, "不及格"
        case default
            print *, "未知等级"
        end select

        ! case 范围
        i = 15
        select case (i)
        case (0:9)
            print *, "个位数"
        case (10:99)
            print *, "两位数"
        case (100:999)
            print *, "三位数"
        case default
            print *, "其他"
        end select

        ! case 条件列表
        i = 3
        select case (i)
        case (1, 3, 5, 7, 9)
            print *, "奇数"
        case (2, 4, 6, 8, 10)
            print *, "偶数"
        end select

        print *, ""
        print *, "=== 3. do 循环 ==="

        ! 基本 do 循环
        print *, "基本 do 循环（1 到 5）:"
        do i = 1, 5
            print *, "  i =", i
        end do

        ! 带步长的 do 循环
        print *, "带步长 2 的 do 循环（1 到 10）:"
        do i = 1, 10, 2
            print *, "  i =", i
        end do

        ! 倒序 do 循环
        print *, "倒序 do 循环（5 到 1）:"
        do i = 5, 1, -1
            print *, "  i =", i
        end do

        ! 无限 do 循环（配合 exit 使用）
        print *, "无限 do 循环配合 exit:"
        i = 0
        do
            i = i + 1
            if (i > 3) exit
            print *, "  i =", i
        end do

        print *, ""
        print *, "=== 4. do while 循环 ==="

        ! do while 循环
        i = 1
        sum = 0
        do while (i <= 10)
            sum = sum + i
            i = i + 1
        end do
        print *, "1 到 10 的和 =", sum

        print *, ""
        print *, "=== 5. cycle 和 exit ==="

        ! cycle：跳过本次循环（类似 continue）
        print *, "cycle 跳过偶数:"
        do i = 1, 10
            if (mod(i, 2) == 0) cycle
            print *, "  奇数: i =", i
        end do

        ! exit：退出循环
        print *, "exit 在 i=5 时退出:"
        do i = 1, 100
            if (i == 5) then
                print *, "  在 i =", i, " 时退出"
                exit
            end if
            print *, "  i =", i
        end do

        print *, ""
        print *, "=== 6. 嵌套循环与循环标签 ==="

        ! 嵌套循环，使用循环标签
        outer: do i = 1, 3
            inner: do n = 1, 3
                if (i == 2 .and. n == 2) cycle outer  ! 跳过外层本次循环
                print *, "  i =", i, ", n =", n
            end do inner
        end do outer

        ! 使用 exit 标签退出多层循环
        print *, "多层 exit 示例:"
        outer2: do i = 1, 3
            do n = 1, 3
                if (i * n > 4) exit outer2
                print *, "  i =", i, ", n =", n, ", 乘积 =", i * n
            end do
        end do outer2

    end subroutine demo_control

end program control
