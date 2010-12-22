---
layout: post
title: "Cake and Emacs: cake-swank"
meta_description: Connect or reconnect to swank while reloading cake class path files with cake -r
meta_keywords: post, emacs, cake, swank, clojure
category: [javascript]
---

leiningen build tool + emacs + elein

cake: pros vs cons

auto start swank for cake

checkout master from cake

cake-swank

{% highlight clojure %}

(defun cake-swank ()
  "Connect or reconnect to swank while reloading cake class path files with cake -r."
  (interactive)
  (if (slime-connected-p) (slime-disconnect))
  (let ((buffer (get-buffer-create ecake-swank-buffer-name)))
    (flet ((display-buffer (buffer-or-name &optional not-this-window frame) nil))
      (bury-buffer buffer)
      (ecake-in-project-root (shell-command "cake -r" buffer)))
    (message "Connecting to swank..")
    (slime-connect "127.0.0.1" "4005")))

{% endhighlight %}

mismatch? => remove elc file in slime emacs folder
