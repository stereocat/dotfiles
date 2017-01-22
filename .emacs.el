;;;; -*- mode: lisp-interaction; syntax: elisp; coding: utf-8 -*-

(if window-system
    (progn
      ;; if use X
      (setq font-lock-support-mode 'jit-lock-mode)
      (setq font-lock-maximum-decoration t)
      (global-font-lock-mode t)
      ;; hide tool-bar and scroll-bar
      (menu-bar-mode 0)
      (tool-bar-mode 0)
      (scroll-bar-mode 0)
      ;; notice: keybind collision with screen/tmux
      (global-set-key "\C-t" 'hippie-expand)
      (windmove-default-keybindings)

      ;; color current line
      (require 'hl-line)
      (global-hl-line-mode t)

      ;; color-theme
      (setq load-path (cons "~/.emacs.d/color-theme-6.6.0" load-path))
      (require 'color-theme)
      (load "my-color4")
      (my-color-theme)

      ;; paren face
      (show-paren-mode t)
      (setq show-paren-style 'expression)
      (set-face-background 'show-paren-match-face "#006A6A")
      (set-face-foreground 'show-paren-match-face nil)
      (set-face-bold-p 'show-paren-match-face t)

      ;; white space
      (defface my-face-b-1 '((t (:background "gray"))) nil)
      (defface my-face-b-2 '((t (:foreground "RoyalBlue3" :underline t))) nil)
      (defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
     ;(defvar my-face-r-1 'my-face-r-1)
      (defvar my-face-b-1 'my-face-b-1)
      (defvar my-face-b-2 'my-face-b-2)
      (defvar my-face-u-1 'my-face-u-1)
      (defadvice font-lock-mode (before my-font-lock-mode ())
	(font-lock-add-keywords
	 major-mode
	 '(("\t" 0 my-face-b-2 append)
	   ("　" 0 my-face-b-1 append)
	   ("[ \t]+$" 0 my-face-u-1 append)
          ;("[\r]*\n" 0 my-face-r-1 append)
	   )))
      (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
      (ad-activate 'font-lock-mode)
      ;; For ubuntu desktop
      (set-face-attribute 'default nil :family "Noto Sans Mono CJK JP")
      )
  (progn
    ;; if use in terminal
    (setq font-lock-support-mode 'jit-lock-mode)
    (setq font-lock-maximum-decoration t)
    (global-set-key "\C-q" 'hippie-expand)
    (global-font-lock-mode t)
    (menu-bar-mode 0)
    (tool-bar-mode 0)
    (scroll-bar-mode 0)

    ;; interminal, cannot use S-<up|down|left|right> (why?)
    (windmove-default-keybindings)
    (global-set-key (kbd "C-c <left>")  'windmove-left)
    (global-set-key (kbd "C-c <right>") 'windmove-right)
    (global-set-key (kbd "C-c <up>")    'windmove-up)
    (global-set-key (kbd "C-c <down>")  'windmove-down)

    ;; paren face
    (show-paren-mode t)
    (setq show-paren-style 'expression)
    (set-face-background 'show-paren-match-face "#00006A")
    (set-face-foreground 'show-paren-match-face nil)
    (set-face-bold-p 'show-paren-match-face t)
    (transient-mark-mode t)

    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; line-number
(line-number-mode t)
(column-number-mode t)
(setq ring-bell-function
      (lambda ()
        (invert-face 'mode-line)
        (sit-for 0 50)
        (invert-face 'mode-line)))
;; GCを減らして軽くする(デフォルトの10倍)
(setq gc-cons-threshold (* 10 gc-cons-threshold))
;; ログの記録行数を増やす
(setq message-log-max 10000)
;; ミニバッファを再帰的に呼びだせるようにする
(setq enable-recursive-minibufferes t)
;; ダイアログボックスを使わないようにする
(setq user-dialog-box nil)
(defalias 'message-box nil)
;; 履歴をたくさん保存する
(setq history-length 10000)
;; キーストロークをエコーエリアに早く表示する
(setq echo-keystrokes 0.1)
;; ミニバッファで入力を取り消しても履歴に残す
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))

;; 1 行スクロール
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
;; 物理行移動(Emacs23)
(setq line-move-visual t)
;; 大量の undo に耐えられるようにする
(setq undo-limit 600000)
(setq undo-strong-limit 90000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fill/unfill paragraph
;; https://www.emacswiki.org/emacs/UnfillParagraph
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))
;; Handy key definition
(define-key global-map "\M-Q" 'unfill-paragraph)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SKK (ddskk)

(require 'skk-autoloads)
(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xj" 'skk-auto-fill-mode)
;;(global-set-key "\C-xt" 'skk-tutorial)

;; 辞書
(setq skk-cdb-large-jisyo "/usr/share/skk/SKK-JISYO.L.cdb")
;; sticky
(setq skk-sticky-key ";")
;; 変換時
(setq skk-egg-like-newline t)
;; メッセージは日本語で
(setq skk-japanese-message-and-error t)
;; "「"を入力したら"」"も自動で挿入
(setq skk-auto-insert-paren t)
;; 漢字登録のミスをチェックする
(setq skk-check-okurigana-on-touroku t)
;; 句読点
(setq skk-kuten-touten-alist
      '(
	(jp . ("。" . "、"))
	(en . ("．" . "，"))
	;;  (en . (". " . ", "))
	))
(setq-default skk-kutouten-type 'jp)
;; @で挿入する日付表示を半角に
(setq skk-number-style nil)
;; 送り仮名の自動処理
(setq skk-auto-okuri-process 1)
;; 変換候補のハイライト表示
(setq skk-use-face t)
;; SKK State
(setq skk-latin-mode-string "A")
(setq skk-hiragana-mode-string "あ")
(setq skk-cursor-hiragana-color "tomato")
(setq skk-katakana-mode-string "ア")
(setq skk-jisx0208-latin-mode-string "A")
;; for migemo
(setq skk-isearch-start-mode 'latin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; keybind

(global-set-key [home]      'beginning-of-buffer)
(global-set-key [end]       'end-of-buffer)
(global-set-key "\C-e"      'end-of-line)
(global-set-key [S-f12]     'locate-library) ;; where is the library ?
(global-set-key [f11]       'comment-region) ;; comment
(global-set-key [S-f11]     'uncomment-region) ;; uncomment

(global-set-key [f5]        'recenter)
(global-set-key [S-f5]      'balance-windows)
(global-set-key "\C-z"      'undo) ;; undo
(global-set-key "\C-]"      'redo) ;; redo
(global-set-key "\C-xg"     'goto-line)

(defun delete-windows-like ()
  (interactive)
  (if mark-active
      (progn
        (delete-region (point) (mark)))
    (progn
;     (delete-char 1) ;; Del
      (delete-backward-char 1) ;; BackSpace
      )))
(global-set-key [backspace] 'delete-windows-like) ;; BackSpace (delete region)
(global-set-key "\C-h"      'delete-windows-like) ;; BackSpace (delete region)

(global-unset-key [insert])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-install

(setq load-path (cons "~/.emacs.d" load-path))
(require 'auto-install)
(add-to-list 'load-path auto-install-directory)
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dynamic abbrev. / hippie expand

(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
	try-complete-file-name
	try-expand-all-abbrevs
	try-expand-dabbrev
	try-expand-dabbrev-all-buffers
	try-expand-dabbrev-from-kill
	try-complete-lisp-symbol-partially
	try-complete-lisp-symbol
	))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; color-moccur/moccur-edit

(require 'color-moccur)
(require 'moccur-edit)
(setq moccur-split-word t)
(setq *moccur-buffer-name-exclusion-list*
      '(".+TAGS.+" "*Completions*" "*Messages*" "newsrc.eld"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; buffer operation
;; http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=my-bury-buffer

(setq my-ignore-buffer-list
      '("*Help*" "*Compile-Log*" "*Completions*"
        "*Shell Command Output*" "*Apropos*" "*Buffer List*"
        "*Messages*" "*WoMan-Log*" "*GNU Emacs*" "*Ibuffer*"
        "*auto-install"))

(defun my-visible-buffer (blst)
  (let ((bufn (buffer-name (car blst))))
    (if (or (= (aref bufn 0) ? ) (member bufn my-ignore-buffer-list))
        (my-visible-buffer (cdr blst)) (car blst))))

(defun my-grub-buffer ()
  (interactive)
  (switch-to-buffer (my-visible-buffer (reverse (buffer-list)))))

(defun my-bury-buffer ()
  (interactive)
  (bury-buffer)
  (switch-to-buffer (my-visible-buffer (buffer-list))))

(defun my-bury-buffer ()
  (interactive)
  (bury-buffer)
  (switch-to-buffer (my-visible-buffer (buffer-list))))
(defun my-kill-buffer (buf)
  (interactive "bKill buffer: ")
  (if (fboundp 'make-local-hook)
      (make-local-hook 'kill-buffer-hook))
  (add-hook 'kill-buffer-hook 'my-bury-buffer nil t)
  (kill-buffer buf))
(global-set-key "\C-xk" 'my-kill-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *scratch* バッファを消さないようにする
;;     http://www-tsujii.is.s.u-tokyo.ac.jp/~yoshinag/tips/elisp_tips.html

(defun my-make-scratch (&optional arg)
  (interactive)
  (progn
    ;; "*scratch*" を作成して buffer-list に放り込む
    (set-buffer (get-buffer-create "*scratch*"))
    (funcall initial-major-mode)
    (erase-buffer)
    (when (and initial-scratch-message (not inhibit-startup-message))
      (insert initial-scratch-message))
    (or arg (progn (setq arg 0)
                   (switch-to-buffer "*scratch*")))
    (cond ((= arg 0) (message "*scratch* is cleared up."))
          ((= arg 1) (message "another *scratch* is created")))))

(defun my-buffer-name-list ()
  (mapcar (function buffer-name) (buffer-list)))

(add-hook 'kill-buffer-query-functions
          ;; *scratch* バッファで kill-buffer したら内容を消去するだけにする
          (function (lambda ()
                      (if (string= "*scratch*" (buffer-name))
                          (progn (my-make-scratch 0) nil)
                        t))))
(add-hook 'after-save-hook
          ;; *scratch* バッファの内容を保存したら *scratch* バッファを新しく作る
          (function (lambda ()
                      (unless (member "*scratch*" (my-buffer-name-list))
                        (my-make-scratch 1)))))

;; minibuffer C-d
;;     http://goas.no-ip.org/~shirai/diary/20030819.html#p01
(defvar minibuf-shrink-type0-chars '((w3m-input-url-history . (?/ ?+ ?:))
                                     (read-expression-history . (?\) ))
                                     (t . (?/ ?+ ?~ ?:)))
  "*minibuffer-history-variable とセパレータと見なす characters の alist。
type0 はセパレータを残すもの。")

(defvar minibuf-shrink-type1-chars '((file-name-history . (?.))
                                     (w3m-input-url-history . (?# ?? ?& ?.))
                                     (t . (?- ?_ ?. ? )))
  "*minibuffer-history-variable とセパレータと見なす characters の alist。
type1 はセパレータを消去するもの。")

(defun minibuf-shrink-get-chars (types)
  (or (cdr (assq minibuffer-history-variable types))
      (cdr (assq t types))))

(defun minibuf-shrink (&optional args)
  "point が buffer の最後なら 1 word 消去する。その他の場合は delete-char を起動する。
単語のセパレータは minibuf-shrink-type[01]-chars。"
  (interactive "p")
  (if (/= (if (fboundp 'field-end) (field-end) (point-max)) (point))
      (delete-char args)
    (let ((type0 (minibuf-shrink-get-chars minibuf-shrink-type0-chars))
          (type1 (minibuf-shrink-get-chars minibuf-shrink-type1-chars))
          (count (if (<= args 0) 1 args))
          char)
      (while (not (zerop count))
        (when (memq (setq char (char-before)) type0)
          (delete-char -1)
          (while (eq char (char-before))
            (delete-char -1)))
        (setq count (catch 'detect
                      (while (/= (if (fboundp 'field-beginning)
                                     (field-beginning) (point-min))
                                 (point))
                        (setq char (char-before))
                        (cond
                         ((memq char type0)
                          (throw 'detect (1- count)))
                         ((memq char type1)
                          (delete-char -1)
                          (while (eq char (char-before))
                            (delete-char -1))
                          (throw 'detect (1- count)))
                         (t (delete-char -1))))
                      ;; exit
                      0))))))
 
(defvar minibuf-expand-filename-original nil)
(defvar minibuf-expand-filename-begin nil)
 
(defun minibuf-expand-filename (&optional args)
  "file-name-history だったら minibuffer の内容を expand-file-name する。
連続して起動すると元に戻す。C-u 付きだと link を展開する。"
  (interactive "P")
  (when (eq minibuffer-history-variable 'file-name-history)
    (let* ((try-again (eq last-command this-command))
           (beg (cond
                 ;; Emacs21.3.50 + ange-ftp だと2回目に変になる
                 ((and try-again minibuf-expand-filename-begin)
                  minibuf-expand-filename-begin)
                 ((fboundp 'field-beginning) (field-beginning))
                 (t (point-min))))
           (end (if (fboundp 'field-end) (field-end) (point-max)))
           (file (buffer-substring-no-properties beg end)))
      (unless try-again
        (setq minibuf-expand-filename-begin beg))
      (cond
       ((and args try-again minibuf-expand-filename-original)
        (setq file (file-chase-links (expand-file-name file))))
       (args
        (setq minibuf-expand-filename-original file)
        (setq file (file-chase-links (expand-file-name file))))
       ((and try-again minibuf-expand-filename-original)
        (setq file minibuf-expand-filename-original)
        (setq minibuf-expand-filename-original nil))
       (t
        (setq minibuf-expand-filename-original file)
        (setq file (expand-file-name file))))
      (delete-region beg end)
      (insert file))))

(mapcar (lambda (map)
          (define-key map "\C-d" 'minibuf-shrink)
          (define-key map "\M-\C-d" 'minibuf-expand-filename))
        (delq nil (list (and (boundp 'minibuffer-local-map)
                             minibuffer-local-map)
                        (and (boundp 'minibuffer-local-ns-map)
                             minibuffer-local-ns-map)
                        (and (boundp 'minibuffer-local-completion-map)
                             minibuffer-local-completion-map)
                        (and (boundp 'minibuffer-local-must-match-map)
                             minibuffer-local-must-match-map))))

;; iswitchb
(iswitchb-mode t)
(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-my-keys)
(defun iswitchb-my-keys ()
  "Add my keybindings for iswitchb."
  (define-key iswitchb-mode-map [right] 'iswitchb-next-match)
  (define-key iswitchb-mode-map "\C-f"  'iswitchb-next-match)
  (define-key iswitchb-mode-map " "     'iswitchb-next-match)
  (define-key iswitchb-mode-map [left]  'iswitchb-prev-match)
  (define-key iswitchb-mode-map "\C-b"  'iswitchb-prev-match)
  )
(setq iswitchb-buffer-ignore '("^ " "*Help*" "*Compile-Log*" "*Completions*"
                               "*Shell Command Output*" "*Apropos*"
                               "*Buffer List*" "*Messages*" "*WoMan-Log*"
                               "*GNU Emacs*" "*Ibuffer*" "*auto-install"))

;; auto-save-buffers
(require 'auto-save-buffers)
(run-with-idle-timer 1.0 t 'auto-save-buffers)

;; minibuf-isearch
(require 'minibuf-isearch)
(setq minibuf-isearch-use-migemo nil)

;; ibuffer
(require 'ibuffer)
(setq ibuffer-default-sorting-mode 'alphabetic
      ibuffer-formats '((mark modified read-only " " (name 30 30)
                              " " (size 6 -1) " " (mode 16 16) " " filename)
                        (mark " " (name 30 -1) " " filename))
      )
(global-set-key "\C-xe" 'ibuffer) ;; ibuffer

(defun ibuffer-visit-buffer-other-window-scroll (&optional down)
  (interactive)
  (let ((buf (ibuffer-current-buffer)))
    (unless (buffer-live-p buf)
      (error "Buffer %s has been killed!" buf))
    (if (string=
         (buffer-name (window-buffer (next-window)))
         (buffer-name buf))
        (if down
            (scroll-other-window-down nil)
          (scroll-other-window))
      (ibuffer-visit-buffer-other-window-noselect))))

(defun ibuffer-visit-buffer-other-window-scroll-down ()
  (interactive)
  (ibuffer-visit-buffer-other-window-scroll t))

(define-key ibuffer-mode-map " " 'ibuffer-visit-buffer-other-window-scroll)
(define-key ibuffer-mode-map "b" 'ibuffer-visit-buffer-other-window-scroll-down)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; session
(when (require 'session nil t)
  (add-hook 'after-init-hook 'session-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; migemo

(when (and (executable-find "cmigemo")
           (require 'migemo nil t))
  (setq migemo-options '("-q" "--emacs"))

  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (load-library "migemo")
  (migemo-init)
  (setq migemo-command "cmigemo")
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Major Mode Settings

;; flymake (Emacs22から標準添付されている)
;; http://d.hatena.ne.jp/antipop/20080701/1214838633
(require 'flymake)

;; ruby-mode setting
(setq ruby-indent-tabs-mode nil)
(setq ruby-deep-indent-paren-style nil)
(defadvice ruby-indent-line (after unindent-closing-paren activate)
  (let ((column (current-column))
        indent offset)
    (save-excursion
      (back-to-indentation)
      (let ((state (syntax-ppss)))
        (setq offset (- column (current-column)))
        (when (and (eq (char-after) ?\))
                   (not (zerop (car state))))
          (goto-char (cadr state))
          (setq indent (current-indentation)))))
    (when indent
      (indent-line-to indent)
      (when (> offset 0) (forward-char offset)))))

;; Flymake ruby
;; EmacsWiki: Flymake Ruby http://www.emacswiki.org/emacs/FlymakeRuby

;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
	 (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook 'ruby-mode-hook
          '(lambda ()
	     ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
	     (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
		 (flymake-mode))
	     ))

;; rack-mode
(autoload 'racc-mode "racc-mode" "alternate mode for editing racc files" t)
(setq auto-mode-alist (append '(("\\.ry$" . racc-mode)) auto-mode-alist))

;; cucumber
;; https://github.com/michaelklishin/cucumber.el
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

;; yaml mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(put 'narrow-to-region 'disabled nil)

;; cperl mode
;; From: Perl Best Practices (D. Conway)
;; http://www.perlmonks.org/?displaytype=print;node_id=619780

;; Use cperl mode instead of the default perl mode
(defalias 'perl-mode 'cperl-mode)

;; turn autoindenting on
(global-set-key "\r" 'newline-and-indent)

;; Use 4 space indents via cperl mode
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cperl-close-paren-offset -4)
 '(cperl-continued-statement-offset 4)
 '(cperl-indent-level 4)
 '(cperl-indent-parens-as-block t)
 '(cperl-tab-always-indent t)
 '(safe-local-variable-values
   (quote
    ((syntax . elisp)
     (TeX-master . "main.tex")
     (TeX-master . main\.tex)))))

;; Insert spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default show-training-whitespace t)

;; Set line width to 78 columns
(setq fill-column 79)
(setq auto-fill-mode t)



;; set-perl5lib
;; 開いたスクリプトのパスに応じて、@INCにlibを追加してくれる
;; 以下からダウンロードする必要あり
;; http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el
(require 'set-perl5lib)

;; エラー、ウォーニング時のフェイス
(set-face-background 'flymake-errline "red1")
(set-face-foreground 'flymake-errline "white")
(set-face-background 'flymake-warnline "yellow")
(set-face-foreground 'flymake-warnline "black")

;; エラーをミニバッファに表示
;; http://d.hatena.ne.jp/xcezx/20080314/1205475020
(defun flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))

;; Perl用設定
;; http://unknownplace.org/memo/2007/12/21#e001
(defvar flymake-perl-err-line-patterns
  '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

(defconst flymake-allowed-perl-file-name-masks
  '(("\\.pl$" flymake-perl-init)
    ("\\.pm$" flymake-perl-init)
    ("\\.t$" flymake-perl-init)))

(defun flymake-perl-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "perl" (list "-wc" local-file))))

(defun flymake-perl-load ()
  (interactive)
  (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
  (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
  (set-perl5lib)
  (flymake-mode t))

(add-hook 'cperl-mode-hook 'flymake-perl-load)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; markdown mode
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; haml-mode
(require 'haml-mode)
(setq auto-mode-alist (cons '("\\.haml" . haml-mode) auto-mode-alist))
(add-hook 'haml-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (define-key haml-mode-map "\C-m" 'newline-and-indent)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ReStructured Text

(require 'rst)
(setq auto-mode-alist
      (append '(("\\.txt\\'" . rst-mode)
                ("\\.rst\\'" . rst-mode)
                ("\\.rest\\'" . rst-mode)) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yatex
;; YaTeX - TeX Wiki https://texwiki.texjp.org/?YaTeX

(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq auto-mode-alist
      (append '(("\\.tex$" . yatex-mode)
                ("\\.ltx$" . yatex-mode)
                ("\\.cls$" . yatex-mode)
                ("\\.sty$" . yatex-mode)
                ("\\.clo$" . yatex-mode)
                ("\\.bbl$" . yatex-mode)) auto-mode-alist))
(setq YaTeX-inhibit-prefix-letter t)
(setq YaTeX-kanji-code nil)
(setq YaTeX-latex-message-code 'utf-8)
(setq YaTeX-use-LaTeX2e t)
(setq YaTeX-use-AMS-LaTeX t)
(setq YaTeX-dvi2-command-ext-alist
      '(("TeXworks\\|texworks\\|texstudio\\|mupdf\\|SumatraPDF\\|Preview\\|Skim\\|TeXShop\\|evince\\|okular\\|zathura\\|qpdfview\\|Firefox\\|firefox\\|chrome\\|chromium\\|Adobe\\|Acrobat\\|AcroRd32\\|acroread\\|pdfopen\\|xdg-open\\|open\\|start" . ".pdf")))
;(setq tex-command "ptex2pdf -u -l -ot '-synctex=1'")
;(setq tex-command "platex-ng -synctex=1")
;(setq tex-command "pdflatex -synctex=1")
;(setq tex-command "lualatex -synctex=1")
;(setq tex-command "luajitlatex -synctex=1")
;(setq tex-command "xelatex -synctex=1")
(setq tex-command "latexmk -e '$latex=q/uplatex %O -synctex=1 %S/' -e '$bibtex=q/upbibtex %O %B/' -e '$biber=q/biber %O --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex %O -o %D %S/' -e '$dvipdf=q/dvipdfmx %O -o %D %S/' -norc -gg -pdfdvi")
;(setq tex-command "latexmk -e '$latex=q/uplatex %O -synctex=1 %S/' -e '$bibtex=q/upbibtex %O %B/' -e '$biber=q/biber %O --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex %O -o %D %S/' -e '$dvips=q/dvips %O -z -f %S | convbkmk -u > %D/' -e '$ps2pdf=q/ps2pdf %O %S %D/' -norc -gg -pdfps")
;(setq tex-command "latexmk -e '$pdflatex=q/platex-ng %O -synctex=1 %S/' -e '$bibtex=q/upbibtex %O %B/' -e '$biber=q/biber %O --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex %O -o %D %S/' -norc -gg -pdf")
;(setq tex-command "latexmk -e '$pdflatex=q/pdflatex %O -synctex=1 %S/' -e '$bibtex=q/bibtex %O %B/' -e '$biber=q/biber %O --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/makeindex %O -o %D %S/' -norc -gg -pdf")
;(setq tex-command "latexmk -e '$pdflatex=q/lualatex %O -synctex=1 %S/' -e '$bibtex=q/upbibtex %O %B/' -e '$biber=q/biber %O --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex %O -o %D %S/' -norc -gg -pdf")
;(setq tex-command "latexmk -e '$pdflatex=q/luajitlatex %O -synctex=1 %S/' -e '$bibtex=q/upbibtex %O %B/' -e '$biber=q/biber %O --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex %O -o %D %S/' -norc -gg -pdf")
;(setq tex-command "latexmk -e '$pdflatex=q/xelatex %O -synctex=1 %S/' -e '$bibtex=q/upbibtex %O %B/' -e '$biber=q/biber %O --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex %O -o %D %S/' -norc -gg -pdf")
(setq bibtex-command "latexmk -e '$latex=q/uplatex %O -synctex=1 %S/' -e '$bibtex=q/upbibtex %O %B/' -e '$biber=q/biber %O --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex %O -o %D %S/' -e '$dvipdf=q/dvipdfmx %O -o %D %S/' -norc -gg -pdfdvi")
(setq makeindex-command  "latexmk -e '$latex=q/uplatex %O -synctex=1 %S/' -e '$bibtex=q/upbibtex %O %B/' -e '$biber=q/biber %O --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex %O -o %D %S/' -e '$dvipdf=q/dvipdfmx %O -o %D %S/' -norc -gg -pdfdvi")
;(setq dvi2-command "xdg-open")
(setq dvi2-command "evince")
;(setq dvi2-command "okular --unique")
;(setq dvi2-command "zathura -x \"emacsclient --no-wait +%{line} %{input}\"")
;(setq dvi2-command "qpdfview --unique")
;(setq dvi2-command "texworks")
;(setq dvi2-command "texstudio --pdf-viewer-only")
;(setq tex-pdfview-command "xdg-open")
(setq tex-pdfview-command "evince")
;(setq tex-pdfview-command "okular --unique")
;(setq tex-pdfview-command "zathura -x \"emacsclient --no-wait +%{line} %{input}\"")
;(setq tex-pdfview-command "qpdfview --unique")
;(setq tex-pdfview-command "texworks")
;(setq tex-pdfview-command "texstudio --pdf-viewer-only")
(setq dviprint-command-format "xdg-open `echo %s | sed -e \"s/\\.[^.]*$/\\.pdf/\"`")

;; SyncTex, Linux/Evince
;; forward search (emacs[C-c e] -> evince)
;; https://texwiki.texjp.org/?YaTeX#h118b5e5
;; with fwdevince https://texwiki.texjp.org/?Evince%2Ffwdevince%2FPython
(defun evince-forward-search ()
  (interactive)
  (let* ((ctf (buffer-name))
         (mtf)
         (pf)
         (ln (format "%d" (line-number-at-pos)))
         (cmd "fwdevince")
         (args))
    (if (YaTeX-main-file-p)
        (setq mtf (buffer-name))
      (progn
        (if (equal YaTeX-parent-file nil)
            (save-excursion
              (YaTeX-visit-main t)))
        (setq mtf YaTeX-parent-file)))
    (setq pf (concat (car (split-string mtf "\\.")) ".pdf"))
    (setq args (concat pf " " ln " " ctf))
    (message (concat cmd " " args))
    (process-kill-without-query
     (start-process-shell-command "fwdevince" nil cmd args))))

(add-hook 'yatex-mode-hook
          '(lambda ()
             (define-key YaTeX-mode-map (kbd "C-c e") 'evince-forward-search)))

;; inverse search (evince[Ctrl-left_click] -> emacs)
;; https://texwiki.texjp.org/?cmd=read&page=Emacs&word=synctex#v19f2543
(require 'dbus)
(defun un-urlify (fname-or-url)
  "A trivial function that replaces a prefix of file:/// with just /."
  (if (string= (substring fname-or-url 0 8) "file:///")
      (substring fname-or-url 7)
    fname-or-url))
(defun evince-inverse-search (file linecol &rest ignored)
  (let* ((fname (decode-coding-string (url-unhex-string (un-urlify file)) 'utf-8))
         (buf (find-file fname))
         (line (car linecol))
         (col (cadr linecol)))
    (if (null buf)
        (message "[Synctex]: %s is not opened..." fname)
      (switch-to-buffer buf)
      (goto-line (car linecol))
      (unless (= col -1)
        (move-to-column col))
      (x-focus-frame (selected-frame)))))
(dbus-register-signal
 :session nil "/org/gnome/evince/Window/0"
 "org.gnome.evince.Window" "SyncSource"
 'evince-inverse-search)
(with-eval-after-load 'yatexprc
  (defun YaTeX-preview-jump-line ()
    "Call jump-line function of various previewer on current main file"
    (interactive)
    (save-excursion
      (save-restriction
        (widen)
        (let*((pf (or YaTeX-parent-file
                      (save-excursion (YaTeX-visit-main t) (buffer-file-name))))
              (pdir (file-name-directory pf))
              (bnr (substring pf 0 (string-match "\\....$" pf)))
              ;(cf (file-relative-name (buffer-file-name) pdir))
              (cf (buffer-file-name)) ;2016-01-08
              (buffer (get-buffer-create " *preview-jump-line*"))
              (line (count-lines (point-min) (point-end-of-line)))
              (previewer (YaTeX-preview-default-previewer))
              (cmd (cond
                    ((string-match "Skim" previewer)
                     (format "%s %d '%s.pdf' '%s'"
                             YaTeX-cmd-displayline line bnr cf))
                    ((string-match "evince" previewer)
                     (format "%s '%s.pdf' %d '%s'"
                             "fwdevince" bnr line cf))
                    ((string-match "sumatra" previewer)
                     (format "%s \"%s.pdf\" -forward-search \"%s\" %d"
                             previewer bnr cf line))
                    ((string-match "zathura" previewer)
                     (format "%s --synctex-forward '%d:0:%s' '%s.pdf'"
                             previewer line cf bnr))
                    ((string-match "qpdfview" previewer)
                     (format "%s '%s.pdf#src:%s:%d:0'"
                             previewer bnr cf line))
                    ((string-match "okular" previewer)
                     (format "%s '%s.pdf#src:%d %s'"
                             previewer bnr line (expand-file-name cf)))
                    )))
          (YaTeX-system cmd "jump-line" 'noask pdir))))))
(add-hook 'yatex-mode-hook
          '(lambda ()
             (auto-fill-mode -1)))
;;
;; RefTeX with YaTeX
;;
;(add-hook 'yatex-mode-hook 'turn-on-reftex)
(add-hook 'yatex-mode-hook
          '(lambda ()
             (reftex-mode 1)
             (define-key reftex-mode-map (concat YaTeX-prefix ">") 'YaTeX-comment-region)
             (define-key reftex-mode-map (concat YaTeX-prefix "<") 'YaTeX-uncomment-region)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
