! =====================================================
! main.f90
! FortranStudio 主程序入口，打印欢迎横幅和章节列表
! =====================================================

program main
    implicit none

    print *, "╔════════════════════════════════════════╗"
    print *, "║     欢迎来到 FortranStudio 学习项目！  ║"
    print *, "║     Fortran 语言完整学习教程            ║"
    print *, "╚════════════════════════════════════════╝"

    print *, ""
    print *, "================= 教程章节 ================="
    print *, "01. 基础语法        -> 01-basics/variables.f90"
    print *, "02. 控制流          -> 02-control/control.f90"
    print *, "03. 数组            -> 03-arrays/arrays.f90"
    print *, "04. 函数与子程序    -> 04-functions/functions.f90"
    print *, "05. 派生类型        -> 05-derived-types/types.f90"
    print *, "06. 输入输出        -> 06-io/io.f90"
    print *, "07. 并行编程        -> 07-parallel/parallel.f90"
    print *, "==========================================="

    print *, ""
    print *, ">>> 提示：每个章节是独立的程序，请用 run.sh 分别运行"
    print *, ">>> 例如：bash run.sh 01   （运行第 1 章）"
    print *, ">>> 例如：bash run.sh      （运行所有章节）"
    print *, ""

    print *, "╔════════════════════════════════════════╗"
    print *, "║     FortranStudio 欢迎界面演示完成！   ║"
    print *, "╚════════════════════════════════════════╝"

end program main
