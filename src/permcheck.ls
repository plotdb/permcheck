(->
  acts = <[list read write admin]>

  check = ({role, perm, action}) -> new Promise (res, rej) ->
    ret = {}
    if Array.isArray(perm) =>
      plist = []
      perm.map -> plist ++= perm.list
    else plist = perm.list
    for p in plist =>
      if !p.action => continue
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
      return if v => res! else rej!
    return res [k for k of ret]
  if module? => module.exports = check
  if window? => window.permcheck = check
)!
