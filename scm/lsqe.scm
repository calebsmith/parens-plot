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

