permcheck = require "../src/permcheck"

perm = do
  list: [
    { action: \read }
    { type: \user, key: 1, action: \write}
    { type: \user, key: 2, action: \read}
    { type: \team, key: 2, action: \comment}
  ]

act = \comment
role = do
  user: [2]

permcheck {role, perm, action: \comment}
  .finally -> console.log "expect: fail:"
  .then -> console.log " * pass"
  .catch -> console.log " * fail"
  .then ->
    permcheck {role, perm}
  .finally -> console.log "expect: pass ['read']:"
  .then -> console.log " * pass", it
  .catch -> console.log " * fail"

