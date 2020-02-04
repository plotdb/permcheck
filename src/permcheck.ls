(->
  acts = <[list read write admin]>

  check = ({obj, perm, action}) -> new Promise (res, rej) ->
    ret = {}
    for p in perm.list =>
      if !p.action => continue
      if !p.type => ret[p.action] = true
      if !(o = obj[p.type]) => continue
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
