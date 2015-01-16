#! /usr/bin/env guile
!#

(define (load-all)
    (load "scm/seqs.scm")
    (load "scm/meths.scm")
    (load "scm/plot.scm"))

(load-all)



(define (deriv-demo)
    (let ((plot (plot:new 100 300))
          (xrange (list -250 250 1)))
        (plot:draw-poly plot (poly '(1 2 5 -10)) xrange)
        (plot:draw-poly plot ((derive-poly-n 1) '(1 2 5 -10)) xrange)
        (plot:draw-poly plot ((derive-poly-n 2) '(1 2 5 -10)) xrange)
        (plot:save plot "output/deriv.png")))


(define (lsfe-demo)
    (let* ((plot (plot:new 80 80))
           (xrange (list -40 40 1))
           (points '(
              (-40 -30)
              (-30 -10)
              (-20 -20)
              (-15 -5)
              (-5 10)
              (10 0)
              (20 15)
              (30.5 10)
              (40 25)
           ))
           (fit-func (best-fit_func points)))

        (plot:draw-points plot points '(0 0 0))
        (plot:draw-poly plot fit-func xrange)
        (plot:save plot "output/lsfe.png")))

(deriv-demo)
(lsfe-demo)
