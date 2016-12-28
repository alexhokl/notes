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

#### Refactoring on version 1.4

The refactoring is done to make sure the codebase can be ported to Angular2 and beyond (See [Refactoring Angular Apps to Component Style](http://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html)). Here are the steps involved.

##### 1. [Replace `ng-include` with directive](https://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#replace-ng-include-with-component-directive)

- `ng-include` is a relatively low-level feature that pollutes your view with information about template file locations.
- Create a directive, named after the template. Make it use a new inherited scope (`scope`: `true`).

##### 2. [Replace `ng-controller` with directive](https://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#replace-ng-controller-with-component-directive)

- `ng-controller` often demarcates an area of the template that is somehow independent, or separate from its parents and siblings. If it is, it should be a component.
- Create a directive, named after the controller. Make it use an inherited scope (`scope`: `true`).

##### 3. [Wrap Markup in directive](https://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#wrap-markup-in-component-directive)

- There is a big template, with no `ng-controller`s or `ng-include`s inside it.
- If there is some part inside the extracted HTML that you would rather leave in place, you can use transclusion.

##### 4. [Replace External Reference with Bound Input](https://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#replace-external-reference-with-bound-input)

- In the template, find any functions or variables which bind to a foreign controller and introduce a binding for this external reference, and put it in the `bindToController` section of the  directive. Lastly, replace the external reference with a reference to the new controller binding.
- For `$watch`, `$watchCollection`, or `$watchGroup` referencing expressions in a foreign controller, ntroduce a binding for this external reference, and put it in the `bindToController` section of the  directive. Lastly, replace the external reference with a reference to the new controller binding. In order words, the watch statements can be kept but we make sure it is not referencing a foreign controller.

##### 5. [Replace External Effect with Bound Output](https://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#replace-external-effect-with-bound-output)

- Effectively same mechanics as in previous step. The key words to searach for like `ng-change` or `ng-click`. Instead of using `=` in `bindToController`, we use `&` to allow the expression to be evaluated in the context of the original scope, at a specific time.



##### Tips
- In order to avoid collisions with some future standard, it is best to prefix your own directive names.
- Attribute versus element. Use an element when you are creating a component that is in control of the template. The common case for this is when you are creating a Domain-Specific Language for parts of a template. Use an attribute when decorating an existing element with new functionality.
- Directives should clean up after themselves. You can use `element.on('$destroy', ...)` or `scope.$on('$destroy', ...)` to run a clean-up function when the directive is removed.
- Use `$broadcast` and `$emit` in directive to communicate to "outside" world.
- Avoid using jQuery validators and use AngularJS ones as jQuery ones not quite testable due to DOM manipulation
