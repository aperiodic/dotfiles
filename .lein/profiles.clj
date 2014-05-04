{:user {:plugins [[lein-difftest "1.3.7"]
                  [lein-midje "3.0.0"]]
        :dependencies [[org.clojure/tools.namespace "0.2.4"]
                       [clj-stacktrace "0.2.7"]]
        :injections [(let [orig (ns-resolve (doto 'clojure.stacktrace require)
                                            'print-cause-trace)
                           new (ns-resolve (doto 'clj-stacktrace.repl require)
                                           'pst)]
                       (alter-var-root orig (constantly (deref new))))]}}
