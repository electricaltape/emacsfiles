; things that I want to keep but don't really belong anywhere in particular.
(regexp-opt '("\\section" "\\subsection" "\\subsubsection"))
"\\(?:\\\\s\\(?:\\(?:ubs\\(?:ubs\\)?\\)?ection\\)\\)"

(append '(1 2 3) '(4 5 6) '(7 8 9))

(defun fix-ORDER-macro (start end)
  "Fix the order macro for any rectangular matrix."
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char 1)
    (let ((case-fold-search nil))
      (while (search-forward-regexp "ORDER(\\([0-9]\\), *\\([0-9]\\), *\\([0-9]\\))"
                                    nil t)
        (replace-match (concat "ORDER("
                               (match-string 1)
                               ", "
                               (match-string 2)
                               ", "
                               (match-string 3)
                               ", "
                               (match-string 3)
                               ")"))))))

ORDER(0,1, 2)

figuring out DGEMM_WRAPPER

we want to do C.T := B.T * A.T for row order.
A is m x k and B is k x n : C is m x n.
Therefore A.T is k x m and B.T is n x k.

How about C := A * B.T ?
then C.T = (A * B.T).T
         = B * A.T

A better way:
let D = A.T, E = B.T, and F = C.T : we want to do everything with these matricies
instead. if A is m x k and B.T is k x n, then:
1. D is k x m
2. E is k x n
3. F is n x m

and

C := A * B.T
C.T := B * A.T
F := E.T * D

; testing functions for ArgyrisPack
void print_matrix(double* matrix, int rows, int cols)
{
        int i, j;
        for (i = 0; i < rows; i++) {
                for (j = 0; j < cols; j++) {
                        printf("%f ", matrix[ORDER(i,j,rows,cols)]);
                }
                printf("\n");
        }
}

int main(int argc, char *argv[])
{
        double x[3] = {1,2,3};
        double y[3] = {9,8,7};
        double ref_dx[21*3];
        double ref_dy[21*3];

        ap_gradient_points(x, y, 3, ref_dx, ref_dy);

        printf("ref_dx:\n");
        print_matrix(ref_dx, 21, 3);
        return 0;
}