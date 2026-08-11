! =====================================================
! 03-arrays/arrays.f90
! Fortran 数组：声明、数组语法、动态数组、数组内置函数
! =====================================================

program arrays
    implicit none

    call demo_arrays()

contains

    subroutine demo_arrays()
        ! 静态数组声明
        integer :: arr1d(5)
        integer :: arr2d(3, 3)
        real :: vec(5)
        integer :: i, j
        integer, allocatable :: dyn_arr(:)
        real, allocatable :: matrix(:,:)

        print *, ""
        print *, "=== 1. 数组声明 ==="

        ! 一维数组
        arr1d = [1, 2, 3, 4, 5]
        print *, "一维数组:", arr1d

        ! 数组构造器（方括号语法）
        vec = [1.0, 2.0, 3.0, 4.0, 5.0]
        print *, "实数数组:", vec

        ! 二维数组
        arr2d = reshape([1,2,3,4,5,6,7,8,9], [3, 3])
        print *, "二维数组:"
        do i = 1, 3
            print *, "  行", i, ":", arr2d(i, :)
        end do

        print *, ""
        print *, "=== 2. 数组语法（向量化操作）==="

        ! 数组整体运算（无需循环）
        vec = [1.0, 2.0, 3.0, 4.0, 5.0]
        print *, "原数组:    ", vec
        print *, "加 10:     ", vec + 10.0
        print *, "乘 2:      ", vec * 2.0
        print *, "平方:      ", vec ** 2
        print *, "数组相加:  ", vec + vec

        ! 数组切片
        print *, "前3个元素: ", vec(1:3)
        print *, "第2到4个:  ", vec(2:4)
        print *, "步长2:     ", vec(1:5:2)
        print *, "倒数第2起: ", vec(4:5)

        print *, ""
        print *, "=== 3. 动态数组（allocatable）==="

        ! 一维动态数组
        allocate(dyn_arr(10))
        do i = 1, 10
            dyn_arr(i) = i * i
        end do
        print *, "动态数组（平方）:", dyn_arr
        deallocate(dyn_arr)

        ! 二维动态数组
        allocate(matrix(3, 3))
        matrix = reshape([1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0], [3, 3])
        print *, "动态矩阵:"
        do i = 1, 3
            print *, "  行", i, ":", matrix(i, :)
        end do
        deallocate(matrix)

        print *, ""
        print *, "=== 4. 数组内置函数 ==="

        ! 使用静态数组演示内置函数
        block
            integer :: nums(5) = [10, 20, 30, 40, 50]
            real :: vals(5) = [1.5, 2.5, 3.5, 4.5, 5.5]

            print *, "数组:        ", nums
            print *, "size:        ", size(nums)       ! 数组大小
            print *, "shape:       ", shape(nums)      ! 数组形状
            print *, "sum:         ", sum(nums)        ! 求和
            print *, "product:     ", product(nums)    ! 求积
            print *, "maxval:      ", maxval(nums)      ! 最大值
            print *, "minval:      ", minval(nums)      ! 最小值
            print *, "maxloc:      ", maxloc(nums)      ! 最大值位置
            print *, "minloc:      ", minloc(nums)      ! 最小值位置
            print *, "实数 sum:    ", sum(vals)
            print *, "实数 maxval: ", maxval(vals)
            print *, "实数 minval: ", minval(vals)
        end block

        print *, ""
        print *, "=== 5. 数组初始化技巧 ==="

        ! 用标量初始化整个数组
        block
            integer :: zeros(5)
            zeros = 0
            print *, "全零数组:    ", zeros
        end block

        ! 隐式 do 循环构造数组
        block
            integer :: seq(10)
            seq = [(i**2, i = 1, 10)]   ! 隐式 do 循环
            print *, "平方序列:    ", seq
        end block

        ! 数组边界查询
        block
            integer :: arr(0:4)  ! 自定义下标从 0 开始
            arr = [5, 4, 3, 2, 1]
            print *, "自定义下标数组:", arr
            print *, "lbound:      ", lbound(arr)
            print *, "ubound:      ", ubound(arr)
        end block

    end subroutine demo_arrays

end program arrays
