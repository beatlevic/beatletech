---
layout: post
title: "Cake and Emacs: cake-swank"
meta_description: Connect or reconnect to swank while reloading cake class path files with cake -r
meta_keywords: post, emacs, cake, swank, clojure, lisp, linux
tags: [cake, emacs, clojure, leiningen, linux]
category: [emacs]
---

So far I have been using <a
href="https://github.com/technomancy/leiningen">leiningen</a> as my
standard build tool for Clojure, and together with a very nice Emacs
package
called <a href="http://blog.remvee.net/2010/08/19/elein_el_leiningen_functions_for_emacs">elein</a>
I was able to run leiningen tasks from within emacs. The functions I use
 most often are elein-swank and elein-reswank to (re)connect with slime.

Now this is all great, but lately an alternative build tool has catched my
eyes and is called <a href="https://github.com/ninjudd/cake">cake</a>. It features a
persistent JVM, which speeds up startup time tremendeously, and has an
easier way for setting up tasks similar to ruby rake
tasks. Now in order to make my swanking and reswanking work in emacs
with cake I thought of reusing the elein-swank code, but as it turns
out, in order to kill swank I had to kill cake and thereby killing the
persistent JVM (missing the whole purpose). So instead of doing that I
got the advice to just keep swank running, and only reload the
classpath. This resulted in me implementing the following elisp functions.

{% highlight clojure %}

(defun cake-project-root ()
  "Look for project.clj file to find project root."
  (let ((cwd default-directory)
        (found nil)
        (max 10))
    (while (and (not found) (> max 0))
      (if (file-exists-p (concat cwd "project.clj"))
        (setq found cwd)
        (setq cwd (concat cwd "../") max (- max 1))))
    (and found (expand-file-name found))))

(defmacro cake-in-project-root (body)
  "Wrap BODY to make 'default-directory' the project root."
  (let ((dir (gensym)))
    `(let ((,dir (cake-project-root)))
       (if ,dir
         (let ((default-directory ,dir)) ,body)
         (error "No cake project root found")))))

(defun cake-swank ()
  "Connect or reconnect to swank while reloading cake class path files."
  (interactive)
  (if (slime-connected-p)
      (slime-disconnect))
  (let ((buffer (get-buffer-create "*cake-swank*")))
    (flet ((display-buffer
             (buffer-or-name &optional not-this-window frame) nil))
      (bury-buffer buffer)
      (cake-in-project-root (shell-command "cake -r" buffer)))
    (slime-connect "127.0.0.1" "4005")))

{% endhighlight %}

In order for this to work one needs to get the latest cake master
version, so you can reload class path files (cake -r). Additionally one has
to turn on swank autostart for cake. This can be done by adding the
line "swank.autostart = localhost:4005" to your .cake/config file.

So now you can easily switch to cake, keeping reswank in your toolset.

Tip: If you find yourself always getting the following mini-buffer
message when connecting with slime: "Versions differ: nil (slime)
vs. 20100404 (swank). Continue? (y or n)", then all you should do is
removing the slime.elc file in your .emacs.d/elpa/slime-X folder, and
consider it history.
