require './lisp_base.rb'
LISP do (cons 1,2) end
LISP do (cond true,(cond false,(cons 1,2),(cons 3,4)),(cons 5,6)) end
LISP do (defun :fact,:x,(cond (eq :x,0),1,(mult (sqrt (square :x)),(fact (minus :x,1))))) end
LISP do (defun :abs,:x,(cond (lt :x,0),(minus 0,:x),:x)) end
LISP do
  (defun :sqrtrec,:x,:y,:d,
   (cond (lt :d,0.0000000001),
    :y,
    (cond (lt (mult :y,:y),:x),
     (sqrtrec :x,(add :y,:d),(mult :d,0.5)),
     (sqrtrec :x,(minus :y,:d),(mult :d,0.5))
    )
   )
  )
end
LISP do (defun :sqrt,:x,(sqrtrec :x,:x,:x)) end
LISP do (defun :square,(mult :x,:x)) end
LISP do (fact 5) end
