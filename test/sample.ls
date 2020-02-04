permcheck = require "../permcheck"

perm = do
  list: [
    { action: \read }
    { type: \user, key: 1, action: \write}
    { type: \user, key: 2, action: \read}
    { type: \team, key: 2, action: \comment}
  ]

act = \comment
obj = do
  user: [2]

permcheck {obj, perm, action: \comment}
  .then -> console.log "pass"
  .catch -> console.log "fail"

permcheck {obj, perm}
  .then -> console.log "pass", it
  .catch -> console.log "fail"

