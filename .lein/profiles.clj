{:user {:plugins [[lein-ancient "0.6.10" :exclusions [org.apache.httpcomponents/httpclient com.fasterxml.jackson.core/jackson-core]]
                  [lein-difftest "2.0.0"]
                  [lein-midje "3.0.0"]
                  [lein-pprint "1.1.2"]
                  [spyscope "0.1.5"]]
        :dependencies [[pjstadig/humane-test-output "0.8.3"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]}}
