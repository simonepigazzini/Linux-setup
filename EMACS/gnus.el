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

;; show favourite groups at sturup (group level < 4)
(defun gnus-group-list-fav-groups ()
  (interactive)
  (gnus-group-list-all-groups 3))

(add-hook 'gnus-started-hook 'gnus-group-list-fav-groups)

;; group format and names
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
                       ("nnimap+UNIMIB:INBOX" . "UNIMIB: INBOX")
                       ("nnimap+UNIMIB:[Gmail]/Posta inviata" . "UNIMIB: Sent")
                       ("nnimap+UNIMIB:[Gmail]/Bozze" . "UNIMIB: Drafts")
                       ("nnimap+INFN:INBOX" . "INFN: INBOX")
                       ("nnimap+INFN:mail/Sent" . "INFN: Sent")
                       ("nnimap+INFN:mail/Drafts" . "INFN: Drafts")
                       ("nnfolder+archive:sent.2014-11" . "ARCHIVE: Sent")))

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
                                      (nnimap "CERN"
                                              (nnimap-address "imap.cern.ch")
                                              (nnimap-stream ssl)
                                              (nnimap-server-port 993)
                                              (nnimap-logout-timeout 10)
                                              (nnir-search-engine imap))))

;; set email ordering
(setq gnus-thread-sort-functions
      '(gnus-thread-sort-by-most-recent-date
        gnus-thread-sort-by-most-recent-number))

;; discourage HTML mail:
(eval-after-load "mm-decode"
  '(progn
     (add-to-list 'mm-discouraged-alternatives "text/html")
     (add-to-list 'mm-discouraged-alternatives "text/richtext")))

;; ### OUTGOING MAILs ###
;; mark archive copy of sent email as read
(setq gnus-gcc-mark-as-read t)

;; ispell on the fly
(add-hook 'message-mode-hook (lambda () (flyspell-mode 1)))


;; change from field accordingly to current group
(setq gnus-posting-styles
      '((".*"(address "simone.pigazzini@cern.ch"))
        ("^nnimap\\+CERN.*"(address "simone.pigazzini@cern.ch"))
        ("^nnimap\\+INFN.*"(address "simone.pigazzini@mib.infn.it"))
        ("^nnimap\\+UNIMIB.*"(address "s.pigazzini@campus.unimib.it"))))

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
  (if (search "cern" (mail-fetch-field "From") :from-end)
      (setq smtpmail-smtp-server "smtp.cern.ch"))
  (if (search "infn" (mail-fetch-field "From") :from-end)
      (setq smtpmail-smtp-server "cassio.mib.infn.it"))
  (if (search "unimib" (mail-fetch-field "From") :from-end)
      (setq smtpmail-smtp-server "smtp.gmail.com"))
  (message "server changed to: %S" smtpmail-smtp-server))

(add-hook 'message-send-hook 'gnus-smtp-change-server)
 
(require 'smtpmail)

;; ### NOTIFICATION ###
;; refresh every 2 min
(gnus-demon-add-handler 'gnus-demon-scan-news 1 nil)

;; set for a specific notification level
(defvar gnus-notify-level 3
  "Notify for unread articles at this level or under")

;; internal variables
(setq gnus-prev-unread-count-cern 0)
(setq gnus-unread-count-cern 0)
(setq gnus-prev-unread-count-unimib 0)
(setq gnus-unread-count-unimib 0)
(setq gnus-prev-unread-count-infn 0)
(setq gnus-unread-count-infn 0)

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
                   (search groupname (gnus-info-group info) :from-end)
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
  ;; unimib check mail
  (setq gnus-prev-unread-count-unimib gnus-unread-count-unimib)
  (setq gnus-unread-count-unimib (gnus-group-number-of-unread-mail gnus-notify-level "UNIMIB"))
  (if (> gnus-unread-count-unimib gnus-prev-unread-count-unimib)
      (gnus-notification-bubble "UNIMIB" (number-to-string gnus-unread-count-unimib)))
  ;; infn check mail
  (setq gnus-prev-unread-count-infn gnus-unread-count-infn)
  (setq gnus-unread-count-infn (gnus-group-number-of-unread-mail gnus-notify-level "INFN"))
  (if (> gnus-unread-count-infn gnus-prev-unread-count-infn)
      (gnus-notification-bubble "INFN" (number-to-string gnus-unread-count-infn))))

;; notify with bubble
(defun gnus-notification-bubble (account newcount)
  "notify new mail with GNOME bubble"
  (interactive)
  (shell-command (concat "notify-send -t 2000 -i ~/.GNUS/Logos/"
                               account "_logo.jpeg '" account " MAIL' '"
                               newcount " new messages'")))


;; run notification after the servers are fetched
(add-hook 'gnus-after-getting-new-news-hook 'gnus-unread-update-unread-count t)

