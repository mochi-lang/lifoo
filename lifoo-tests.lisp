(defpackage lifoo-tests
  (:use cl cl4l-test lifoo))

(in-package lifoo-tests)

(define-test (:lifoo :stack)
  (assert (= 1 (do-lifoo () 1 dup drop)))
  (assert (= 2 (do-lifoo () 1 2 swap drop))))

(define-test (:lifoo :branch)
  (assert (eq :ok (do-lifoo () :ok (1 2 <) when)))
  (assert (eq :ok (do-lifoo () :ok (1 2 >) unless))))

(define-test (:lifoo :cmp)
  (assert (do-lifoo () "abc" "abc" eq?))
  (assert (not (do-lifoo () "abc" "abcd" eq?)))
  (assert (do-lifoo () "abc" "abcd" neq?))
  (assert (do-lifoo () "abc" "def" lt?))
  (assert (not (do-lifoo () "abc" "def" gt?))))

(define-test (:lifoo :eval)
  (assert (equal '(1 2 +) (do-lifoo () (1 2 +))))
  (assert (= 3 (do-lifoo () (1 2 +) eval))))

(define-test (:lifoo :format)
  (assert (string= "1+2=3"
                   (do-lifoo () "~a+~a=~a" (1 2 3) format))))

(define-test (:lifoo :compile)
  (assert (= 3 (do-lifoo () (1 2 +) compile eval))))

(define-test (:lifoo :list)
  (assert (equal '(1 . 2) (do-lifoo () 1 2 cons)))
  (assert (equal '(1 . 2) (do-lifoo () (1 . 2))))
  (assert (equal '(1 2 3) (do-lifoo () 1 2 3 list)))
  (assert (= 2 (do-lifoo () (1 2 3) rest first)))
  (assert (equal '(2 4 6) (do-lifoo () (1 2 3) (2 *) map))))

(define-test (:lifoo :print)
  (assert (string= (format nil "hello lifoo!~%")
                   (with-output-to-string (out)
                     (let ((*standard-output* out))
                       (do-lifoo ()
                         "hello lifoo!" print ln))))))