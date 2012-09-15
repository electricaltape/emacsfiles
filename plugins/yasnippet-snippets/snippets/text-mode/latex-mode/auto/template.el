(TeX-add-style-hook "template"
 (lambda ()
    (TeX-add-symbols
     '("Brackets" 1)
     '("Integral" 2)
     '("Limit" 3)
     '("TwoMatrix" 4)
     '("TwoVectorColumn" 2)
     '("TwoVectorRow" 2)
     '("ThreeMatrix" 9)
     '("ToZero" 1)
     '("abs" 1)
     '("Norm" 1))
    (TeX-run-style-hooks
     "mathpazo"
     "sc"
     "fontenc"
     "T1"
     "beramono"
     "listings"
     "graphicx"
     "sagetex"
     "cancel"
     "amssymb"
     "amsthm"
     "amsfonts"
     "amsmath"
     "mathtools"
     "geometry"
     "latex2e"
     "art10"
     "article"
     "letterpaper"
     "10pt")))

