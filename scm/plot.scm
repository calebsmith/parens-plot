; Cairo plotting code
; ---------------------
(use-modules (cairo))
(use-modules (srfi srfi-11))


(define (plot:make-context width height)
    (let* ((surface (cairo-image-surface-create 'argb32 width height))
           (context (cairo-create surface))
           (half-width (/ width 2))
           (neg-half-width (- (/ width 2))))
      ; Set the matrix transform such that 0, 0 is in the middle and y
      ; increases in the up direction
      (cairo-set-matrix context (cairo-make-matrix 1 0 0 -1 0 0))
      (cairo-translate context half-width (/ (- height) 2))
      (cairo-set-antialias context 'subpixel)
      context))

(define (plot:load filename)
    (cairo-create
        (cairo-image-surface-create-from-png filename)))

(define (plot:save plot-context filename)
    (cairo-surface-write-to-png (cairo-get-target plot-context) filename))


(define (with-preserve context func)
    ; Calls the passed in func and returns the line-width and position to
    ; starting states
    (let ((start-line-width (cairo-get-line-width context)))
          (let-values (((start-x start-y) (cairo-get-current-point context)))
            (func)
            ; Reset to starting position/settings
            (cairo-set-line-width context start-line-width)
            (cairo-move-to context start-x start-y))))


(define (plot:draw-box context x1 y1 x2 y2 color)
    (with-preserve context (lambda ()
        (cairo-set-line-width context 0)
        (cairo-move-to context x1 y1)
        (cairo-line-to context x2 y1)
        (cairo-line-to context x2 y2)
        (cairo-line-to context x1 y2)
        (cairo-line-to context x1 y1)
        (cairo-stroke-preserve context)
        (apply cairo-set-source-rgb (cons context color))
        (cairo-fill context))))

(define (plot:draw-line context x1 y1 x2 y2 color)
    (with-preserve context (lambda ()
        (cairo-set-line-width context 1)
        (cairo-move-to context x1 y1)
        (cairo-line-to context x2 y2)
        (apply cairo-set-source-rgb (cons context color))
        (cairo-stroke-preserve context))))


(define (plot:draw-point context x y color)
    (plot:draw-box context x y (1+ x) (1+ y) color))

(define (plot:draw-points context points color)
    (map (lambda (point)
        (let ((x (list-ref point 0))
              (y (list-ref point 1)))
            (plot:draw-box context x y (1+ x) (1+ y) color)))
        points))



(define (plot:draw-poly context poly-func xrange)
    (let* ((surface (cairo-get-target context))
           (start-x (list-ref xrange 0))
           (max-y (/ (cairo-image-surface-get-height surface) 2))
           (min-y (- max-y)))
        (with-preserve context (lambda ()
            (cairo-set-source-rgb context 0 0 0)
            (cairo-set-line-width context 1)
            (cairo-move-to context start-x (poly-func start-x))
            (lazy-map (lambda (x)
                        (let ((y (poly-func x)))
                          (if (and (> y min-y) (< y max-y))
                              (cairo-line-to context x y))))
                      (apply make-lazy-range xrange))
            (cairo-stroke context)))))

(define (plot:new width height)
    (let ((plot (plot:make-context width height)))
      (plot:draw-box plot
        (- (/ width 2)) (- (/ height 2))
        (/ width 2) (/ height 2)
        '(1 1 1))
      plot))
