permcheck = require "../src/permcheck"

perm1 = do
  list: [
    { action: \read }
    { type: \user, key: 1, action: \write}
    { type: \user, key: 2, action: \read}
    { type: \team, key: 2, action: \comment}
  ]

perm2 = [
  {
    name: "judge",
    list: [{type: \user, key: 2}]
    config: {read: true, write: true, comment: false, edit: false, judge: true}
  },
  {
    name: "default",
    list: [{}]
    config: {read: true, write: false, comment: true, edit: false}
  }
]

act = \comment
role = do
  user: [2]
  team: [4]
  token: [3]

permcheck {role, perm: perm1, action: \comment}
  .finally -> console.log "expect: fail"
  .then -> console.log " *      pass"
  .catch -> console.log " *      fail"
  .then ->
    permcheck {role, perm: perm1}
  .finally -> console.log 'expect: pass ["read"]'
  .then -> console.log " *      pass", JSON.stringify(it)
  .catch -> console.log " *      fail"
  .then ->
    permcheck {role, perm: perm2, action: 'judge'}
  .finally -> console.log "expect: pass true"
  .then -> console.log " *      pass", it
  .catch -> console.log " *      fail"
  .then ->
    permcheck {role, perm: perm2}
  .finally ->
    console.log 'expect: pass {"read":true,"write":true,"comment":false,"edit":false,"judge":true}'
  .then -> console.log " *      pass", JSON.stringify(it)
  .catch -> console.log " *      fail"


