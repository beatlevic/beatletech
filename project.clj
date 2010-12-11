(defproject beatletech "1.0.0-SNAPSHOT"
  :description "BeatleTech freelance website"
  :tasks [code-gen]
  :dependencies [[org.clojure/clojure "1.2.0"]
                 [org.clojure/clojure-contrib "1.2.0"]
                 [ring/ring-jetty-adapter "0.3.5"]
                 [compojure "0.5.3"]
                 [org.danlarkin/clojure-json "1.2-SNAPSHOT"]
                 [hiccup "0.3.1"]]
  :dev-dependencies [[lein-run "1.0.0-SNAPSHOT"]])

