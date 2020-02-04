// Generated by LiveScript 1.3.1
(function(){
  var acts, check;
  acts = ['list', 'read', 'write', 'admin'];
  check = function(arg$){
    var obj, perm, action;
    obj = arg$.obj, perm = arg$.perm, action = arg$.action;
    return new Promise(function(res, rej){
      var ret, i$, ref$, len$, p, o, act, a, v, idx, k;
      ret = {};
      for (i$ = 0, len$ = (ref$ = perm.list).length; i$ < len$; ++i$) {
        p = ref$[i$];
        if (!p.action) {
          continue;
        }
        if (!p.type) {
          ret[p.action] = true;
        }
        if (!(o = obj[p.type])) {
          continue;
        }
        if (in$(p.key, o)) {
          ret[p.action] = true;
        }
      }
      if (action) {
        act = Array.isArray(action)
          ? action
          : [action];
        for (i$ = 0, len$ = act.length; i$ < len$; ++i$) {
          a = act[i$];
          if (ret[a]) {
            v = true;
            break;
          }
          if (~(idx = acts.indexOf(a))) {
            v = !!acts.slice(idx).map(fn$).reduce(fn1$, false);
            break;
          }
        }
        return v
          ? res()
          : rej();
      }
      return res((function(){
        var results$ = [];
        for (k in ret) {
          results$.push(k);
        }
        return results$;
      }()));
      function fn$(it){
        return ret[it];
      }
      function fn1$(a, b){
        return a || b;
      }
    });
  };
  if (typeof module != 'undefined' && module !== null) {
    module.exports = check;
  }
  if (typeof window != 'undefined' && window !== null) {
    return window.permcheck = check;
  }
})();
function in$(x, xs){
  var i = -1, l = xs.length >>> 0;
  while (++i < l) if (x === xs[i]) return true;
  return false;
}
