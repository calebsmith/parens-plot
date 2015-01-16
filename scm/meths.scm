; numerical methods code
;------------------------
;
(define (poly poly-lst)
    (lambda (x)
        (let inner ((coefs (reverse poly-lst))
                     (power 0)
                     (value 0))
            (if (null? coefs)
                value
                (inner (cdr coefs) (1+ power)
                    (+ (* (car coefs) (expt x power)) value))))))


(define (derive-coefs poly-lst)
    (let inner ((coefs (cdr (reverse poly-lst)))
                 (power 1)
                 (value '()))
        (if (null? coefs)
            value
            (inner (cdr coefs) (1+ power)
                   (cons (* (car coefs) power) value)))))

(define (derive-poly-n num)
    (let* ((derivs (repeat num derive-coefs))
           (args (cons poly derivs)))
        (apply compose args)))


(define (best-fit points)
    ;; Use least-squares estimation to find best fit line for given set of points
    (let* ((sumx (apply + (map car points)))
          (sumy (apply + (map cadr points)))
          (sumxy (apply + (map (lambda (p) (* (car p) (cadr p))) points)))
          (sumx2 (apply + (map (lambda (p) (* (car p) (car p))) points)))
          (n (length points))
          (b1 (/ (- sumxy (/ (* sumx sumy) n)) (- sumx2 (/ (* sumx sumx) n))))
          (b0 (/ (- sumy (* b1 sumx)) n)))
      (cons b1 b0)))


(define (best-fit_func points)
    ;; Given a set of points, use `best-fit` to a return the function for the
    ;; best fit line. (Can be called with a given x to return f(x) and used to
    ;; estimate further points)
    (let* ((fx (best-fit points))
          (a-val (car fx))
          (c-val (cdr fx)))
        (lambda (x)
            (+ (* a-val x) c-val))))
