(defn top-level-bindings
  "Return a list of top level bindings in (all-bindings)"
  []
  (filter |(not (string/find "/" $)) (all-bindings)))

(defn module-bindings
  "Return a list of bindings for a module in (all-bindings)"
  [module]
  (filter |(string/has-prefix? (string module "/") $)
          (all-bindings)))

(def- module-grammar
  (peg/compile '{:module-path (* (some (* (! "/") 1))
                                 "/")
                 :main (<- (some :module-path))}))

(defn modules
  "Return a list of modules in (all-bindings)"
  []
  (let [module-name |(when-let [m (peg/match module-grammar $)]
                       (m 0))]
    (map |(slice $ 0 (- (length $) 1))
         (distinct (filter |(not (= nil $))
                           (map module-name (all-bindings)))))))
