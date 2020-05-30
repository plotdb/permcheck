# permcheck

Permission Control


## Spec

permcheck specifies the action level of a certain role over certain permission:

```
    permcheck({role, perm, action})
      .then( ... )
      .catch( ... );
```

### role

`role` provides information of the attributes of a certain instance, such as an user. For example, assume an user with key `1` is a member of team `1`, `2`, `3` and access certain resource with a token `a`, then the `role` will be:

```
    {
      user: [1]
      team: [1,2,3]
      token: ["a"]
    }
```
 
### perm - by action level

In the meanwhile, the requested resource contains permission information for controlling access to it. It will be an object in following format:

```
    {
      list: [
        {type: "...", key: "...", action: "..."},
        ...
      ]
    }
```

Each entry in the list contains following fields:

 * type - can be `user`, `team`, `token` or any string defined by user, or `null` to apply to any request.
 * key - primary key for certain type.
 * action - what kind of action does this entry grant. could be user defined or one of following:
   - list: can access metadata of this resource.
   - read: can read full content of this resource.
   - write: can modify content of this resource.
   - admin: full control ( delete )

For default actions, admin action is by default can write, write action is by default can read, etc.

### perm - by action type

```
    {
      name: 'optional-group-name',
      list: [
        {type: "...", key: "..."},
        ...
      ]
      config: { ... }
    }
```

Additionally, if config is supplied within the perm object, permcheck will instead check if

 * `role` matches any entry in `list`
 * action is true in `config`.

`config` is an object with actions as each of its key.

If `perm` is an array, then permission should be granted if `role` matches any of the permission matched.


## Usage

To check permission for specific role over certain resource, prepare both `role` and `perm` object, and check for desired action:

```
    permcheck({role, perm, action})
      .then( ... )   # action granted
      .catch( ... ); # action denied
```

`action` could be an array ( for checking multiple actions ) or a simple string:

```
    permcheck({role, perm, action: ["read", "fork"]});
```

You can also ignore the `action` parameter at all for listing all granted actions for certain object:

```
    permcheck({role, perm}).then(function(actionList) { ... });
```

All available actions will be listed as strings ( above `actionList` argument ) with Promise.


### Multiple Permission Sets

You can combine multiple permission objects to make it easier to check through different set of permission rules:

```
    permcheck({role, perm: [perm1, perm2]}).then( ... );
```

For example, following example controls permission with a per-object permission and per-type permission:

```
    require("perms");
    objperm = {
      list: [
        {action: 'list'},
        {type: 'user', key: 1, action: 'read'},
      ]
    };
    role = {
      user: [2],
      role: ["reviewer"]
    };
    permcheck({role, perm: [objperm, perms.article]}).then( ... );
```

where perms can be a hardcoded file with following content:

```
    module.exports {
      article: {
        list: [
          {'type': 'role', 'key': 'admin', action: 'admin'},
          {'type': 'role', 'key': 'owner', action: 'admin'}
          {'type': 'role', 'key': 'reviewer', action: 'comment'}
        ]
      }
    };
```


## Compatibility

permcheck uses following modern APIs and thus might need polyfill for using in older browsers:

 * Array.isArray
 * Promise


## License

MIT
