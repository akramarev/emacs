;;; package --- My Package
;;; Commentary:

;;; Code

;; C# highlighting (fast)
(setq csharp-want-imenu nil)
(local-set-key (kbd "{") 'csharp-insert-open-brace)

(defun my-csharp-mode-hook ()
  ;; enable the stuff you want for C# here
  (electric-pair-mode 1)
  ;; for hide/show support
  (setq hs-isearch-open t)
  ;; ?
  (remove-dos-eol)
)
(add-hook 'csharp-mode-hook 'my-csharp-mode-hook)
;; (add-hook 'csharp-mode-hook 'omnisharp-mode)
(add-hook 'sql-mode-hook 'remove-dos-eol)

;; Mixed line ending disable
(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;; Makes allowed line width 2x more that in 70s
(setq whitespace-line-column 120)

;; Remove scroll bars
(scroll-bar-mode -1)

;; Indent
;(setq tab-width 4) ; or any other preferred value
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; Mouse scrolling fix
;; scroll one line at a time (less "jumpy" than defaults)
;(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
;(setq scroll-step 3)
;(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

;; Make emacs run in full screen mode always
(set-frame-parameter nil 'fullscreen 'fullboth)

;; Speedup search with projectile grep
(setq projectile-use-git-grep 1)

;; Chnage default action when switch projects
(setq projectile-switch-project-action 'helm-ls-git-ls)

;; Set comfortable font
(setq default-frame-alist '((font . "PragmataPro-16")))

;; Line number
;(setq linum-format "%d ")
(global-nlinum-mode 1)

;; При прокрутке применять font-lock не сразу, а после небольшой задежки.
;(setq jit-lock-defer-time 0.01)

;; Code Folding
(add-hook 'prog-mode-hook #'hs-minor-mode)

(defvar hs-special-modes-alist
  (mapcar 'purecopy
          '((c-mode "{" "}" "/[*/]" nil nil)
            (c++-mode "{" "}" "/[*/]" nil nil)
            (bibtex-mode ("@\\S(*\\(\\s(\\)" 1))
            (Java-mode "{" "}" "/[*/]" nil nil)
            (js-mode "{" "}" "/[*/]" nil)
            (csharp-mode "{" "}" "/[*/]" nil nil)
            (emacs-lisp- "(" ")" nil))))

(global-set-key (kbd "<f9>") 'hs-hide-block)
(global-set-key (kbd "C-<f9>") 'hs-show-block)

;; Bookmarks
;(global-set-key (kbd "C-b") 'bookmark-set)
;(global-set-key (kbd "M-b") 'bookmark-jump)
(global-set-key (kbd "<f4>") 'helm-bookmark)

;; Snippets
(require 'yasnippet)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

;; Fast search by file name
;(require 'helm-ls-git)
;(global-set-key (kbd "C-c p f") 'helm-ls-git-ls)

;; Chords
; (key-chord-define-global "xx" 'helm-M-x)
(key-chord-define-global "BB" 'helm-mini)
(key-chord-define-global "PP" 'helm-ls-git-ls)

;; Fast text navigation
(avy-setup-default)
;; It will bind, for example, avy-isearch to C-' in isearch-mode-map,
;; so that you can select one of the currently visible isearch candidates using avy.

;; Multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-.") 'mc/mark-next-like-this)
(global-set-key (kbd "C-,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-M-,") 'mc/mark-all-like)

;(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

;; Org mode
(setq org-todo-keywords
      '((sequence "TODO" "IN_PROGRESS" "BLOCKED" "|" "DONE" )))
; Set file for quick notes (org-capture)
(setq org-capture-templates
    '(
        ("t" "Todo" entry (file+headline "~/Documents/Org/tasks.org" "Tasks")
        "* TODO %?\n %i\n %a")
        ("j" "Journal" entry (file+datetree "~/Documents/Org/journal.org" "Journal")
        "* %?\nEntered on %U\n %i\n %a")
        ("d" "Dictionary" entry (file+datetree "~/Documents/Org/dictionary.org" "Dictionary")
        "* %?\nEntered on %U\n %i\n %a")
    )
)
(define-key global-map "\C-cc" 'org-capture)

;; SQL Indention
;; (eval-after-load "sql"
;;   '(load-library "sql-indent"))

;; Comment outglobal-unset-key
(defun comment-eclipse ()
  (interactive)
  (let ((start (line-beginning-position))
        (end (line-end-position)))
    (when (or (not transient-mark-mode) (region-active-p))
      (setq start (save-excursion
                    (goto-char (region-beginning))
                    (beginning-of-line)
                    (point))
            end (save-excursion
                  (goto-char (region-end))
                  (end-of-line)
                  (point))))
    (comment-or-uncomment-region start end)))

(global-set-key (kbd "C-;") 'comment-eclipse)

;; Project navigation panel
(require 'sr-speedbar)
(require 'projectile-speedbar)
(setq speedbar-show-unknown-files t) ; show all files
(setq speedbar-use-images nil) ; use text for buttons
(setq sr-speedbar-right-side nil) ; put on left side
(global-set-key (kbd "C-t") 'sr-speedbar-toggle)

;; delete extra whitespace on saving/writing files
(add-hook 'write-file-hooks 'delete-trailing-whitespace)
(add-hook 'before-saving-hooks 'delete-trailing-whitespace)

;; show time
(display-time)

;; browse on github
;(global-set-key (kbd "C-c g g") 'browse-at-remote/browse)
(key-chord-define-global "GG" 'browse-at-remote/browse)

;; Effective text editing
(global-set-key [M-delete] 'kill-word)
(global-set-key [delete] 'delete-char)

;; My macros

;; Better Header Bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(provide 'ak)
;;; ak.el ends here
