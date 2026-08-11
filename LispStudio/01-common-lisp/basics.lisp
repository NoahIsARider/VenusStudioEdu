;; Common Lisp 基础教程

(format t "=== 1. Common Lisp 基础与变量 ===~%")
(defparameter *project-name* "LispStudio")
(format t "项目名称: ~A~%" *project-name*)

(format t "~%=== 2. 数学运算与函数 ===~%")
(defun add (a b)
  (+ a b))

(format t " (+ 10 20) = ~A~%" (add 10 20))
(format t " 阶乘计算 (5的阶乘): ~A~%" (if (zerop 5) 1 (loop for i from 1 to 5 summing 0 into res))) ; 简单演示
