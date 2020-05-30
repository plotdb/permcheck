(->
  acts = <[list read write admin]>
  types = <[token team user]>

  err = -> new Error("1012 permission denied") <<< { id: 1012, name: \ldError, message: "permission denied" }

  check-by-config = ({role, perm, action}) -> new Promise (res, rej) ->
    ret = {}
    perms = if Array.isArray(perm) => perm else [perm]
    matched-perms = []
    for p in perms =>
      matched-types = []
      for t in p.list =>
        # !t.type => no type means anyone can match.
        if !t.type or t.key in (role[t.type] or []) => matched-types.push t.type
      if matched-types.length => matched-perms.push {types: matched-types, config: p.config}
    cs = []
    for p in matched-perms =>
      for type in p.types => cs.push {type, config: p.config}
    # priority of configs is by order in types
    cs.sort (a,b) ->
      a = types.indexOf(a.type)
      b = types.indexOf(b.type)
      return a - b
    config = {}
    for c in cs => config <<< c.config
    if !action => return res config
    if config[action] => return res true else rej(err!)

  check-by-access = ({role, perm, action}) -> new Promise (res, rej) ->
    ret = {}
    if Array.isArray(perm) =>
      plist = []
      perm.map (p) -> plist ++= p.list
    else plist = perm.list
    for p in plist =>
      if !p.action => continue
      # no type means anyone can match this.
      if !p.type => ret[p.action] = true
      if !(o = role[p.type]) => continue
      if p.key in o => ret[p.action] = true
    if action =>
      act = if Array.isArray(action) => action else [action]
      for a in act =>
        if ret[a] => v = true; break
        if ~(idx = acts.indexOf(a)) =>
          v = !!acts.slice(idx).map(-> ret[it]).reduce(((a,b) -> a or b), false)
          break
      return if v => res(v) else rej(err!)
    return res [k for k of ret]

  check = ({role, perm, action}) ->
    if perm.config or (perm.0 and perm.0.config) => check-by-config {role, perm, action}
    else check-by-access {role, perm, action}

  if module? => module.exports = check
  if window? => window.permcheck = check
)!
