# permcheck

Permission Control


## Spec

permcheck specifies the action level of a certain obj over certain permission:

```
    permcheck({obj, perm, action})
      .then( ... )
      .catch( ... );
```

### obj

`obj` provides information of the attributes of a certain instance, such as an user. For example, assume an user with key `1` is a member of team `1`, `2`, `3` and access certain resource with a token `a`, then the `obj` will be:

```
    {
      user: [1]
      team: [1,2,3]
      token: ["a"]
    }
```
 
### perm 

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


## Usage

To check permission for specific role over certain resource, prepare both `obj` (for role) and `perm` (for resource) object, and check for desired action:

```
    permcheck({obj, perm, action})
      .then( ... )   # action granted
      .catch( ... ); # action denied
```

`action` could be an array ( for checking multiple actions ) or a simple string:

```
    permcheck({obj, perm, action: ["read", "fork"]});
```

You can also ignore the `action` parameter at all for listing all granted actions for certain object:

```
    permcheck({obj, perm}).then(function(actionList) { ... });
```

All available actions will be listed as strings ( above `actionList` argument ) with Promise.


## Compatibility

permcheck uses following modern APIs and thus might need polyfill for using in older browsers:

 * Array.isArray
 * Promise


## License

MIT
