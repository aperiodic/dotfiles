{:user {:plugins [[lein-difftest "2.0.0"]
                  [lein-midje "3.0.0"]
                  [lein-pprint "1.1.2"]]
        :dependencies [[clj-stacktrace "0.2.8"]]
        :jvm-opts ["-Xmx256m"]
        :injections [(let [orig (ns-resolve (doto 'clojure.stacktrace require)
                                            'print-cause-trace)
                           new (ns-resolve (doto 'clj-stacktrace.repl require)
                                           'pst)]
                       (alter-var-root orig (constantly (deref new))))]}}
