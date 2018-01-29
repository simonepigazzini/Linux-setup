;; ### STARTUP ###
;; setup hidden directories
(setq gnus-home-directory "~/.GNUS"
      message-directory "~/.GNUS/Mail/"
      message-auto-save-directory "~/.GNUS/Mail/drafts"
      gnus-directory "~/.GNUS/News/"
      gnus-cache-directory "~/.GNUS/News/cache"
      minibuffer-history "~/.GNUS/Mail/"
      pattern "~/.GNUS/Mail/"
      smime-certificate-directory "~/.GNUS/Mail/cert/"
      smtpmail-queue-dir "~/.GNUS/Mail/queued-mail/"
      nnfolder-directory   "~/.GNUS/Mail/archive"
      nnfolder-active-file "~/.GNUS/Mail/archive/active")

;; ### STARTUP HOOKS ###
;; set terminal name at startup
(add-hook 'gnus-start-hook (lambda ()
                             (shell-command "export PROMPT_COMMAND=\"echo -ne \'\\033]0;GNUS\\007\'\"")))

;; show favourite groups at sturup (group level < 4)
(add-hook 'gnus-started-hook (lambda () 
                               (gnus-group-list-all-groups 3)))
;; sort groups alphabetically
(add-hook 'gnus-started-hook (lambda () 
                               (gnus-group-sort-groups-by-alphabet)))

;; ### EXIT HOOKS ###
;; exit emacs when exiting gnus
(add-hook 'gnus-exit-gnus-hook 'save-buffers-kill-terminal)

;; ### FRAMES LAYOUT ###
;; summary layout
(add-hook 'gnus-summary-prepared-hook (lambda()
                                        (gnus-configure-frame
                                         '(horizontal 1.0
                                                      (group 1.0)
                                                      (summary 0.75 point)))))

;; ### GROUP FORMAT AND NAMES ###
(setq gnus-group-line-format "%M%S%p%P%5y:%B%(%uG%)\n")
(defun gnus-user-format-function-G (arg)
  (let ((mapped-name (assoc gnus-tmp-group group-name-map)))
    (if (null mapped-name)
        gnus-tmp-group
      (cdr mapped-name))))

;; coversion map
(setq group-name-map '(("nnimap+CERN:INBOX" . "CERN: INBOX")
                       ("nnimap+CERN:Sent Items" . "CERN: Sent")
                       ("nnimap+CERN:Drafts" . "CERN: Drafts")
                       ("nnimap+CERN:done job" . "CERN: done job")
                       ("nnimap+CERN:failed job" . "CERN: failed job")
                       ("nnimap+CERN:CMS Elog" . "CERN: CMS Elog")
                       ("nnimap+ETHZ:INBOX" . "ETHZ: INBOX")
                       ("nnimap+ETHZ:Sent" . "ETHZ: Sent")
                       ("nnimap+ETHZ:Drafts" . "ETHZ: Drafts")
                       ("nnimap+INFN:INBOX" . "INFN: INBOX")
                       ("nnimap+INFN:mail/Sent" . "INFN: Sent")
                       ("nnimap+INFN:mail/Drafts" . "INFN: Drafts")
                       ("nnimap+UNIMIB:INBOX" . "UNIMIB: INBOX")
                       ("nnimap+UNIMIB:[Gmail]/Posta inviata" . "UNIMIB: Sent")
                       ("nnimap+UNIMIB:[Gmail]/Bozze" . "UNIMIB: Drafts")
                       ("nnimap+ARTESIA:INBOX" . "ARTESIA: INBOX")
                       ("nnimap+ARTESIA:[Gmail]/Sent Mail" . "ARTESIA: Sent")
                       ("nnimap+ARTESIA:[Gmail]/Drafts" . "ARTESIA: Drafts")))

;; highlight current line in group buffer
(defun gnus-group-hl-line ()
  (hl-line-mode 0))

;; restore the group buffer highlight color after exiting the summary buffer
(add-hook 'gnus-summary-exit-hook 'gnus-group-hl-line)

;; ### SUMMARY BUFFER ###
;; tweak summary format 
(setq gnus-summary-line-format "%U %R [%&user-date;] %B%-20,20n %-80,80s\n"
      gnus-user-date-format-alist '((t . "%Y-%m-%d %H:%M"))
      gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
      gnus-thread-sort-functions '(gnus-thread-sort-by-date)
      gnus-sum-thread-tree-false-root "⚫ "
      gnus-sum-thread-tree-indent " "
      gnus-sum-thread-tree-leaf-with-other "├► "
      gnus-sum-thread-tree-root "✪ "
      gnus-sum-thread-tree-single-leaf "╰► "
      gnus-sum-thread-tree-vertical "│")

;; highlight current line in summary buffer
(defun gnus-summary-hl-line ()
  (hl-line-mode 1)
  (set-face-bold-p 'hl-line t)
  (set-face-background 'hl-line "black")
  (set-face-foreground 'hl-line "green")
  (setq cursor-type nil))

(add-hook 'gnus-summary-mode-hook 'gnus-summary-hl-line)

;; set email ordering
(setq gnus-thread-sort-functions
      '(gnus-thread-sort-by-most-recent-date
        gnus-thread-sort-by-most-recent-number))

;; ### INCOMING MAILS ###
(require 'nnir)

;; personal stuff
(setq user-full-name "Simone Pigazzini"
      mail-host-address "cern.ch"
      user-mail-address "simone.pigazzini@cern.ch"
      message-from-style 'angles)

;; select stuff
(setq gnus-select-method '(nnnil "")
      gnus-secondary-select-methods '((nnml "")
                                      (nnimap "ARTESIA"
                                              (nnimap-address "imap.gmail.com")
                                              (nnimap-stream ssl)
                                              (nnimap-server-port 993)
                                              (nnimap-logout-timeout 10)
                                              (nnir-search-engine imap))
                                      (nnimap "UNIMIB"
                                              (nnimap-address "imap.gmail.com")
                                              (nnimap-stream ssl)
                                              (nnimap-server-port 993)
                                              (nnimap-logout-timeout 10)
                                              (nnir-search-engine imap))
                                      (nnimap "INFN"
                                              (nnimap-address "virgilio.mib.infn.it")
                                              (nnimap-stream ssl)
                                              (nnimap-server-port 993)
                                              (nnimap-logout-timeout 10)
                                              (nnir-search-engine imap))				      
                                      (nnimap "ETHZ"
                                              (nnimap-address "imap.phys.ethz.ch")
                                              (nnimap-stream ssl)
                                              (nnimap-server-port 993)
                                              (nnimap-logout-timeout 10)
                                              (nnir-search-engine imap))				      
                                      (nnimap "CERN"
                                              (nnimap-address "imap.cern.ch")
                                              (nnimap-stream ssl)
                                              (nnimap-server-port 993)
                                              (nnimap-logout-timeout 10)
                                              (nnir-search-engine imap))))

;; discourage HTML mail:
(eval-after-load "mm-decode"
  '(progn
     (add-to-list 'mm-discouraged-alternatives "text/html")
     (add-to-list 'mm-discouraged-alternatives "text/richtext")))

;; ### OUTGOING MAILs ###
;; mark archive copy of sent email as read
(setq gnus-gcc-mark-as-read t)

;; ### SPELL CHECK ###
(add-hook 'message-mode-hook (lambda () (flyspell-mode 1)))
;; A *circular* list of ispell languages, plus a special to keep track
;; of the current language in the list.
(defvar *ispell-languages* '#1=("english" "italiano" . #1#))
(defvar *current-language* "english")

;; Utility function to set current language, ensure flyspell-mode
;; is enabled, and maintain *current-language*.
(defun set-language (lang)
  "Set the current ispell language to lang and ensure flyspell-mode enabled."
  (flyspell-mode 1)
  (setf *current-language* lang)
  (ispell-change-dictionary lang))

;; This is the visible function that cycles languages. Note that it
;; also makes sure flyspell-mode is active (by virtue of the fact
;; that it calls set-language).
(defun cycle-language ()
  "Go to the next language in *ispell-languages*, setting ispell dictionary
and updating *current-language*."
  (interactive)
  (set-language (cadr (member *current-language* *ispell-languages*))))

;; I use this global binding to C-^ to cycle.
(global-set-key (kbd "C-^") 'cycle-language)

;; ### FROM FIELD ###
;; change from field accordingly to current group
(setq gnus-posting-styles
      '((".*"(address "simone.pigazzini@cern.ch"))
        ("^nnimap\\+CERN.*"(address "simone.pigazzini@cern.ch"))
        ("^nnimap\\+ETHZ.*"(address "psimone@phys.ethz.ch"))        
        ("^nnimap\\+INFN.*"(address "simone.pigazzini@mib.infn.it"))
        ("^nnimap\\+UNIMIB.*"(address "s.pigazzini@campus.unimib.it"))
        ("^nnimap\\+ARTESIA.*"(address "alloggi.artesia@gmail.com"))))

;; global stuff
(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      mail-from-style nil user-full-name "Simone Pigazzini"
      smtpmail-debug-info t smtpmail-debug-verb t
      smtpmail-smtp-service 587
      smtpmail-starttls-credentials nil)

;; switch smtp server on the fly (very nice&easy)
(defun gnus-smtp-change-server ()
  (interactive)
  (if (cl-search "cern" (mail-fetch-field "From") :from-end)
      (setq smtpmail-smtp-server "smtp.cern.ch"))
  (if (cl-search "ethz" (mail-fetch-field "From") :from-end)
      (setq smtpmail-smtp-server "mail.phys.ethz.ch"))
  (if (cl-search "infn" (mail-fetch-field "From") :from-end)
      (setq smtpmail-smtp-server "cassio.mib.infn.it"))
  (if (cl-search "unimib" (mail-fetch-field "From") :from-end)
      (setq smtpmail-smtp-server "smtp.gmail.com"))
  (if (cl-search "artesia" (mail-fetch-field "From") :from-end)
      (setq smtpmail-smtp-server "smtp.gmail.com"))
  (message "server changed to: %S" smtpmail-smtp-server))
;; hook the above function to the send-hook
(add-hook 'message-send-hook 'gnus-smtp-change-server)

;; change archive folder accordingly to from field
(defun gnus-archive-change-group ()
  (interactive)
  (if (cl-search "cern" (mail-fetch-field "From") :from-end)
      (setq tmp-gcc "\"nnimap+CERN:Sent Items\""))
  (if (cl-search "infn" (mail-fetch-field "From") :from-end)
      (setq tmp-gcc "\"nnimap+INFN:mail/Sent\""))
  (if (cl-search "unimib" (mail-fetch-field "From") :from-end)
      (setq tmp-gcc "\"nnimap+UNIMIB:[Gmail]/Posta inviata\""))
  (if (cl-search "artesia" (mail-fetch-field "From") :from-end)
      (setq tmp-gcc "\"nnimap+ARTESIA:[Gmail]/Sent Mail\""))
  (search-forward "Gcc: ")
  (kill-line)
  (insert tmp-gcc)
  (message "archive changed to: %S" tmp-gcc))
;; hook the above function to the setup-hook 
(add-hook 'message-setup-hook 'gnus-archive-change-group)

(require 'smtpmail)

;; ### NOTIFICATION ###
;; refresh every 1 min
(gnus-demon-add-handler 'gnus-demon-scan-news 1 nil)

;; set for a specific notification level
(defvar gnus-notify-level 3
  "Notify for unread articles at this level or under")

;; internal variables
(setq gnus-prev-unread-count-cern 0)
(setq gnus-unread-count-cern 0)
(setq gnus-prev-unread-count-ethz 0)
(setq gnus-unread-count-ethz 0)
(setq gnus-prev-unread-count-infn 0)
(setq gnus-unread-count-infn 0)
(setq gnus-prev-unread-count-unimib 0)
(setq gnus-unread-count-unimib 0)
(setq gnus-prev-unread-count-artesia 0)
(setq gnus-unread-count-artesia 0)
(setq gnus-unread-count-all 0)

(defun gnus-group-number-of-unread-mail (level groupname)
  "*Returns the number of unread mails in groups of subscription level LEVEL and below."
  (with-current-buffer "*Group*"
    (let ((num-of-unread 0)
	  (newsrc (cdr gnus-newsrc-alist))
	  info clevel)
      (while newsrc
	(setq info (car newsrc)
	      clevel (gnus-info-level info))
	(when (and (<= clevel level)
                   (cl-search groupname (gnus-info-group info) :from-end)
                   (setq num-of-unread
                         (+ num-of-unread
                            (or (car (gnus-gethash (gnus-info-group info) gnus-newsrc-hashtb))
                                0)))))
        (setq newsrc (cdr newsrc)))
      num-of-unread)))

(defun gnus-unread-update-unread-count ()
  "Update read count for each email account"
  ;; cern check mail
  (setq gnus-prev-unread-count-cern gnus-unread-count-cern)
  (setq gnus-unread-count-cern (gnus-group-number-of-unread-mail gnus-notify-level "CERN"))
  (if (> gnus-unread-count-cern gnus-prev-unread-count-cern)
      (gnus-notification-bubble "CERN" (number-to-string gnus-unread-count-cern)))
  ;; ethz check mail
  (setq gnus-prev-unread-count-ethz gnus-unread-count-ethz)
  (setq gnus-unread-count-ethz (gnus-group-number-of-unread-mail gnus-notify-level "ETHZ"))
  (if (> gnus-unread-count-ethz gnus-prev-unread-count-ethz)
      (gnus-notification-bubble "ETHZ" (number-to-string gnus-unread-count-ethz)))
  ;; infn check mail
  (setq gnus-prev-unread-count-infn gnus-unread-count-infn)
  (setq gnus-unread-count-infn (gnus-group-number-of-unread-mail gnus-notify-level "INFN"))
  (if (> gnus-unread-count-infn gnus-prev-unread-count-infn)
      (gnus-notification-bubble "INFN" (number-to-string gnus-unread-count-infn)))
  ;; unimib check mail
  (setq gnus-prev-unread-count-unimib gnus-unread-count-unimib)
  (setq gnus-unread-count-unimib (gnus-group-number-of-unread-mail gnus-notify-level "UNIMIB"))
  (if (> gnus-unread-count-unimib gnus-prev-unread-count-unimib)
      (gnus-notification-bubble "UNIMIB" (number-to-string gnus-unread-count-unimib)))
  ;; artesia check mail
  (setq gnus-prev-unread-count-artesia gnus-unread-count-artesia)
  (setq gnus-unread-count-artesia (gnus-group-number-of-unread-mail gnus-notify-level "ARTESIA"))
  (if (> gnus-unread-count-artesia gnus-prev-unread-count-artesia)
      (gnus-notification-bubble "ARTESIA" (number-to-string gnus-unread-count-artesia)))
  ;; set panel indicator status
  (gnus-indicator-set))

;; notify with bubble
(defun gnus-notification-bubble (account newcount)
  "notify new mail with GNOME bubble"
  (shell-command (concat "notify-send -t 2000 -i ~/.GNUS/Logos/"
                               account "_logo.jpeg '" account " MAIL' '"
                               newcount " new messages'")))

;; reset panel indicator status
(defun gnus-indicator-set ()
  "reset the gnus-indicator if there are no unread messages"
  (setq gnus-unread-count-all (+ (gnus-group-number-of-unread-mail gnus-notify-level "CERN")
                                 (gnus-group-number-of-unread-mail gnus-notify-level "ETHZ")
                                 (gnus-group-number-of-unread-mail gnus-notify-level "INFN")                                 
                                 (gnus-group-number-of-unread-mail gnus-notify-level "UNIMIB")
                                 (gnus-group-number-of-unread-mail gnus-notify-level "ARTESIA")))
  (cond ((= gnus-unread-count-all 0)
         (shell-command "gnus-indicator 0"))
        ((> gnus-unread-count-all 0)
         (shell-command "gnus-indicator 1"))))

;; ### NOTIFICATION HOOKS ###
;; run notification after the servers are fetched
(add-hook 'gnus-after-getting-new-news-hook 'gnus-unread-update-unread-count t)
;; start/reset gnus-indicator at startup
(add-hook 'gnus-group-mode-hook 'gnus-indicator-set)
;; reset gnus-indicator after a group has been visited
(add-hook 'gnus-summary-exit-hook 'gnus-indicator-set)
;; kill gnus-indicator while exiting gnus
(add-hook 'gnus-exit-gnus-hook (lambda () 
                                 (shell-command "gnus-indicator -1")))
