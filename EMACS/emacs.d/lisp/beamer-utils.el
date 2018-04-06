;; ### GLOBAL ###
(defun bu-populate (title)
  "insert the presentation standard header"
  (interactive "sPresentation title: ")
  (save-excursion
    (insert (concat "\\documentclass[10pt,usenames,dvipsnames,svgnames]{beamer}\n"
                    "%%% beamer slides header %%%\n"
                    "\\usepackage{/home/pigo/.beamer/slide_header}\n\n"
                    "%%% Title and authors %%%\n"
                    "\\title[" title "]{" title "}\n"
                    "%\\subtitle{}\n\n"
                    "\\author[Simone Pigazzini]{Simone Pigazzini \\\\ \\vspace{30pt}\n"
                    "\\includegraphics[height=1cm,width=1cm,keepaspectratio]{/home/pigo/.beamer/unimib_logo.png}\n"
                    "\\includegraphics[height=1cm,width=1cm,keepaspectratio]{/home/pigo/.beamer/infn_logo.png}}\n\n"
                    "\\date{\\today}\n\n"
                    "%%% PRESENTATION %%%\n"
                    "\\begin{document}\n\n\n"
                    "\\end{document}\n")))
  (indent-region (point) (buffer-end 1))
  (search-forward "end")
  (previous-line 2))

(defun bu-get-slide-insert-position ()
  "Return the position where the new slide should be inserted"
  (setq next-begin-pos (search-forward "begin{frame}" nil t))
  (setq next-end-pos (search-forward "end{frame}" nil t))
  (setq prev-end-pos (search-backward "end{frame}" nil t))
  (cond ((or
          (and next-begin-pos next-end-pos (> next-begin-pos next-end-pos))
          (and (not next-begin-pos) next-end-pos))
         (goto-char next-end-pos)
         (next-line))
        ((and next-begin-pos next-end-pos (< next-begin-pos next-end-pos))
         (goto-char next-begin-pos)
         (previous-line 2))
        ((and (not next-begin-pos) (not next-end-pos) prev-end-pos)
         (goto-char prev-end-pos)
         (next-line))))

(defun bu-get-block-begin (block-type)
  "returns current block begin position"
  (save-excursion
    (setq current-slide-begin (search-backward "\\begin{frame}" nil t)))
  (save-excursion
    (setq current-block-begin (search-backward (concat "\\begin{" block-type "}") nil t)))
  (if (> current-block-begin current-slide-begin)
      (goto-char current-block-begin)))
      
(defun bu-get-block-end (block-type)
  "returns current block end position"
  (save-excursion
    (setq current-slide-end (search-forward "\\end{frame}" nil t)))
  (save-excursion
    (setq current-block-end (search-forward (concat "\\end{" block-type "}") nil t)))
  (if (< current-block-end current-slide-end)
      (goto-char current-block-end)))        

;; ### FRAMES ###
(defvar bu-prev-slide)

(defun bu-insert-slide (title)
  "Insert a basic new slide with title <title>"
  (interactive "sSlide title: ")
  (setq indent-begin (point))
  (save-excursion (bu-get-prev-slide-number))
  (setq bu-prev-slide (+ bu-prev-slide 1))
  (bu-get-slide-insert-position)
  (insert (concat "\n%----------slide " (number-to-string bu-prev-slide) (make-string 80 ?-)))
  (insert "\n\\begin{frame}")
  (insert (concat "\n\\frametitle{" title "}"))
  (insert "\n\n\\end{frame}\n")
  (indent-region indent-begin (point))
  (previous-line 2)
  (save-excursion
    (bu-fix-next-slides-number)))

(defun bu-goto-slide (slide-number)
  "Teke the point at the beginning of the slide number <number>"
  (interactive "p")
  (save-excursion
    (goto-char 1)
    (setq slide-pos (search-forward (concat "-slide " (number-to-string slide-number)) nil t)))
  (if (not slide-pos)
      (message "Warning: Slide not found!")
    (goto-char slide-pos)
    (next-line 3)
    (indent-for-tab-command)))

(defun bu-get-prev-slide-number ()
  "Search backward for the previous slide number"
  (setq prev-slide-point (search-backward "-slide " nil t))
  (if prev-slide-point
      (setq bu-prev-slide (string-to-number (buffer-substring-no-properties (+ prev-slide-point 7)
                                                                            (+ prev-slide-point 8))))
    (setq bu-prev-slide 0)))

(defun bu-fix-next-slides-number ()
  "After a new slide is inserted fix the numbers of the following slides (recursive)"
  (setq next-slide-point (search-forward "-slide " nil t))
  (when next-slide-point
    (setq next-slide-number (string-to-number
                             (buffer-substring-no-properties next-slide-point
                                                             (+ next-slide-point 1))))
    (if (>= next-slide-number 9)
        (delete-char 2)
      (delete-char 1))
    (insert (number-to-string (+ next-slide-number 1)))
    (bu-fix-next-slides-number)))

;; ### OVERPRINT ###
(defun bu-insert-overprint (n-slides)
  "Insert n item in overprint environment (using \onslide)"
  (interactive "nNumber of slides: ")
  (setq indent-begin (point))
  (insert "\\begin{overprint}\n")
  (dotimes (i-slides n-slides)
    (bu-insert-onslide (number-to-string (+ i-slides 1)))
    (insert "\n"))
  (insert "\\end{overprint}")
  (indent-region indent-begin (point))
  (goto-cha\end{overprint}r indent-begin)
  (next-line 2)
  (indent-for-tab-command))

(defun bu-insert-onslide (i-slide)
  "Insert a single onslide, with slide number <i-slides> (default 1)"
  (interactive "sOnslide number: ")
  (insert (concat "\\onslide<" i-slide ">\n")))

;; ### COLUMNS ###
(defun bu-insert-columns (n-columns)
  "Insert <n-columns> columns with width 1/<n-columns>"
  (interactive "nNumber of columns: ")
  (setq indent-begin (point))
  (insert "\\begin{columns}\n")
  (setq columns-width (substring (number-to-string (/ 1.0 n-columns)) 0 3))
  (bu-insert-column n-columns columns-width)
  (insert "\\end{columns}")
  (indent-region indent-begin (point))
  (goto-char indent-begin)
  (next-line 2)
  (indent-for-tab-command))

(defun bu-insert-column (n-columns width-in-txt)
  "Insert a single column of width <width-in-txt>\\textwidth. \n"
  "If a prefix is specified insert <n-columns> columns without header"
  (interactive "p\nsColumn width: ")
  (when (> n-columns 0)
    (insert (concat "\\begin{column}{" width-in-txt "\\textwidth}\n\n\\end{column}\n"))
    (bu-insert-column (- n-columns 1) width-in-txt))
  (when (called-interactively-p 'interactive)
    (previous-line 2)
    (indent-for-tab-command)))

;; ### FIGURES ###
(defun bu-insert-graphics (file &optional scale-type scale-factor)
  "Insert a figure scaled by <scale-factor> accordingly to <scale-type> (\\textwidth, scale, width, ...)"
  (interactive "fFigure file: ")
  (setq scale-type (completing-read "Scaling type: " '("height" "width")
                                 nil nil nil nil "width"))
  (setq scale-factor (completing-read "Scaling value: " '() nil nil nil nil "1."))
  (if (string= scale-type "width")
      (setq scaling (concat scale-factor "\\textwidth"))
    (setq scaling (concat scale-type " = " scaling)))
  (if (string= scale-type "height")
      (setq scaling (concat scale-factor "\\textheight"))
    (setq scaling (concat scale-type " = " scaling)))
  (insert (concat "\\includegraphics[" scaling "]{" file "}")))

;; ### ITEMIZE ###
(defun bu-insert-itemize (type &optional itemsep color)
  "Insert an itemize list of <color> items"
  "available type: bullets, arrows, void"
  (interactive (list
                (completing-read "Itemize type: " '("bullets" "arrows" "void")
                                 nil nil nil nil "bullets")))
  (setq indent-begin (point))
  (cond ((member type '("bullets" "arrows"))
         (setq itemsep (completing-read "Item separation: " '() nil nil nil nil "5"))
         (setq color (completing-read (concat type " color: ")
                                      '("mainfg", "blue" "red" "green" "orange" "yellow"
                                        "DarkBlue" "DarkGreen" "DarkOrange")
                                      nil nil nil nil "mainfg"))
         (if (string= type "bullets")
             (insert (concat "\\begin{itemize}[label=\\color{" color "}\\textbullet]\\itemsep" itemsep "pt")))
         (if (string= type "arrows")
             (insert (concat "\\begin{itemize}[label=\\color{" color "}\\MVRightArrow]\\itemsep" itemsep "pt")))
         (insert "\n\\item ")
         (insert "\n\\end{itemize}"))
        ((string= type "void")
         (insert "\\begin{itemize}")
         (insert "\n\n\\end{itemize}")))
  (indent-region indent-begin (point))
  (previous-line)
  (end-of-line))

(defun bu-new-item (type &optional color)
  "create a new item of type <type> and (if type = <bullet>) of color <color>"
  "available type: 0 -> xmark"
  "                1 -> cmark"
  "                2 -> void"
  "                3 -> bullet"
  "                4 -> bold arrow"
  (if (string= color "")
      (setq color "mainfg"))
  (cond ((= type 0)
         (insert "\\item[\\xmark] "))
        ((= type 1)
         (insert "\\item[\\cmark] "))
        ((= type 2)
         (insert "\\item "))
        ((= type 3)
         (insert "\\item[\\color{" color "}\\textbullet] "))
        ((= type 4)
         (insert "\\item[\\color{" color "}\\MVRightarrow] "))) 
  (indent-for-tab-command))

(defun bu-new-item-bullet (color)
  "create a new bullet item of color <color>"
  (interactive "sBullet color: ")
  (bu-new-item 3 color))

(defun bu-new-item-arrow (color)
  "create a new bold arrow item of color <color>"
  (interactive "sArrow color: ")
  (bu-new-item 4 color))

;; ### TABLEs & TABULARs ###
(defvar n-columns)
(defvar n-raws)
(defvar n-rec 0)

(defun bu-insert-tabular (raws columns)
  "Create a simple table with centered fields and line boarders (recursive)"
  (interactive "nNumber of raw: \nnNumber of columns: ")
  (when (= n-rec 0)
    (setq n-rec 1)
    (setq n-columns columns)
    (setq n-raws raws)
    (insert (concat "\\begin{tabular}{|" (make-string n-columns ?c) "}"))
    (save-excursion
      (replace-string "c" "c|" nil (line-beginning-position) (line-end-position)))
    (newline-and-indent)
    (insert "\\hline")
    (newline-and-indent))
  (cond ((> raws 0)
         (cond ((> columns 1)
                (insert "  & ")
                (setq columns (- columns 1))
                (bu-insert-tabular raws columns))
               ((= columns 1)
                (insert "  \\\\")
                (newline-and-indent)
                (setq raws (- raws 1))
                (bu-insert-tabular raws n-columns))))
        ((= raws 0)
         (insert "\\hline\n")
         (insert "\\end{tabular}")
         (indent-for-tab-command)
         (setq n-rec 0))))

;; ### Text style manipulation
(defun bu-highlight-text (begin end)
  "Highlight selected region. If no region is selected inizialize an empty highlight region"
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list nil nil)))
  (cond ((and begin end)
         (goto-char begin)
         (insert "\\hl{")
         (goto-char (+ end 4))
         (insert "}"))
        ((and (not begin) (not end))
         (insert "\\hl{}")
         (goto-char (- (point) 1)))))

(defun bu-scale-text-size (begin end &optional size)
  "Set font size for selected region. If no region is selected inizialize an empty region"
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list nil nil)))
  (setq size (completing-read "Font size: "
                              '("tiny", "footnotesize" "small" "large" "Large" "Huge")
                              nil nil nil nil "small"))
  (cond ((and begin end)
         (goto-char end)
         (insert "}")
         (goto-char begin)
         (insert "{\\" size " "))
        ((and (not begin) (not end))
         (insert "{\\" size " }")
         (goto-char (- (point) 1)))))

(defun bu-set-text-color (begin end &optional color)
  "Set text color for selected region. If no region is selected inizialize an empty region"
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list nil nil)))
  (setq color (completing-read "Text color: "
                               '("highlight" "mainfg" "blue" "green" "red")
                               nil nil nil nil "highlight"))
  (cond ((and begin end)
         (goto-char end)
         (insert "}")
         (goto-char begin)
         (insert "{\\color{" color "} "))
        ((and (not begin) (not end))
         (insert "{\\color{" color "} }")
         (goto-char (- (point) 1)))))

(defun bu-insert-rarrow (color)
  "Insert a bare MVRightArrow"
  (interactive (list
                (completing-read "Arrow color: "
                                 '("mainfg", "blue" "red" "green" "orange" "yellow"
                                   "DarkBlue" "DarkGreen" "DarkOrange")
                                 nil nil nil nil "")))
  (if (not (string= color ""))
      (insert "{\\color{" color "}\\MVRightarrow} ")
    (insert "\\MVRightarrow ")))

;; ### KEY BINDINGS} ###
(defun bu-set-kbds ()
  (local-set-key (kbd "C-c s") 'bu-insert-slide)
  (local-set-key (kbd "C-c i") 'bu-insert-itemize)
  (local-set-key (kbd "C-c h") 'bu-highlight-text)
  (local-set-key (kbd "C-c a") 'bu-insert-rarrow)
  (local-set-key (kbd "C-c t") 'bu-scale-text-size)  
  (local-set-key (kbd "C-c c") 'bu-set-text-color)  
  (local-set-key (kbd "C-i x") (lambda () (interactive) (bu-new-item 0)))
  (local-set-key (kbd "C-i v") (lambda () (interactive) (bu-new-item 1)))
  (local-set-key (kbd "C-i i") (lambda () (interactive) (bu-new-item 2)))
  (local-set-key (kbd "C-i b") 'bu-new-item-bullet)
  (local-set-key (kbd "C-i a") 'bu-new-item-arrow)
  (local-set-key (kbd "C-c g") 'bu-goto-slide)
  (local-set-key (kbd "C-n") (lambda ()
                               (interactive)
                               (bu-get-prev-slide-number)
                               (bu-goto-slide (+ bu-prev-slide 1))))
  (local-set-key (kbd "C-p") (lambda ()
                               (interactive)
                               (bu-get-prev-slide-number)
                               (bu-goto-slide (- bu-prev-slide 1)))))

(provide 'beamer-utils)

