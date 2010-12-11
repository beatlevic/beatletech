(ns beatletech.core
  (:use compojure.core hiccup.core ring.adapter.jetty)
  (:require [compojure.route :as route]))

(def PORT 3434)

(defn home []
  (html [:div
         [:h1 "BeatleTech"]]))

(defroutes beatletech
  (GET "/" [] (home))
  (GET "/ping" [] "pong")
  (route/not-found "<h1>Page not found</h1>"))

(defonce server* (atom nil))

(defn start-server []
  (swap! server* (fn [_] (run-jetty #'beatletech {:port PORT
                                               :join? false}))))

(defn stop-server []
  (swap! server* #(.stop %)))


