##### Checking AngularJS scope variables with inspector of a browser
``` js
var s = angular.element($0).scope();
```

##### ui.router
to debug state transitions
```js
$rootScope.$on('$stateChangeStart',function(event, toState, toParams, fromState, fromParams){
  console.log('$stateChangeStart to '+toState.to+'- fired when the transition begins. toState,toParams : \n',toState, toParams);
});
$rootScope.$on('$stateChangeError',function(event, toState, toParams, fromState, fromParams, error){
  console.log('$stateChangeError - fired when an error occurs during transition.');
  console.log(arguments);
});
$rootScope.$on('$stateChangeSuccess',function(event, toState, toParams, fromState, fromParams){
  console.log('$stateChangeSuccess to '+toState.name+'- fired once the state transition is complete.');
});
$rootScope.$on('$viewContentLoading',function(event, viewConfig){
   console.log('$viewContentLoading - view begins loading - dom not rendered',viewConfig);
});
$rootScope.$on('$viewContentLoaded',function(event){
  // runs on individual scopes, so putting it in "run" doesn't work.
  console.log('$viewContentLoaded - fired after dom rendered',event);
});
$rootScope.$on('$stateNotFound',function(event, unfoundState, fromState, fromParams){
  console.log('$stateNotFound '+unfoundState.to+'  - fired when a state cannot be found by its name.');
  console.log(unfoundState, fromState, fromParams);
});
```

##### Tips
- In order to avoid collisions with some future standard, it is best to prefix your own directive names.
- Attribute versus element. Use an element when you are creating a component that is in control of the template. The common case for this is when you are creating a Domain-Specific Language for parts of a template. Use an attribute when decorating an existing element with new functionality.
- Directives should clean up after themselves. You can use `element.on('$destroy', ...)` or `scope.$on('$destroy', ...)` to run a clean-up function when the directive is removed.
- Use `$broadcast` and `$emit` in directive to communicate to "outside" world.
- Avoid using jQuery validators and use AngularJS ones as jQuery ones not quite testable due to DOM manipulation
