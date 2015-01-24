#! /usr/bin/env guile
!#

(define (load-all)
    (load "scm/seqs.scm")
    (load "scm/meths.scm")
    (load "scm/plot.scm"))

(load-all)


(define (deriv-demo)
    (let ((plot (plot:new 1000 1000))
          (xrange (list -500 500 .01))
          (poly-values '(.0008 0.1 1 -10)))
        (plot:draw-poly plot (poly poly-values) xrange)
        (plot:draw-poly plot ((derive-poly-n 1) poly-values) xrange)
        (plot:draw-poly plot ((derive-poly-n 2) poly-values) xrange)
        (plot:save plot "output/deriv.png")))


(define (lsfe-demo)
    (let* ((plot (plot:new 500 500))
           (xrange (list -250 250 1))
           (points '(
              (-80 -60)
              (-60 -20)
              (-40 -40)
              (-30 -10)
              (-10 20)
              (20 0)
              (40 30)
              (60.5 20)
              (80 50)
           ))
           (fit-func (best-fit_func points)))
        (plot:draw-points plot points '(0 0 0))
        (plot:draw-poly plot fit-func xrange)
        (plot:save plot "output/lsfe.png")))

(deriv-demo)
(lsfe-demo)
