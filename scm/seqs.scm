; lazy sequences and related code
(define (make-lazy-range x max-x step)
    (if (> (+ x step) max-x)
        (delay #nil)
        (delay (cons x (make-lazy-range (+ x step) max-x step)))))

(define (lazy-map func stream)
    (let inner ((next (force stream)))
        (if (not (null? next))
            (begin
                (func (car next))
                (inner (force (cdr next)))))))


(define (repeat num arg)
    (let inner ((current 0))
        (if (>= current num)
            #nil
            (cons arg (inner (1+ current))))))
