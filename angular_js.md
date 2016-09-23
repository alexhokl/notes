##### Checking AngularJS scope variables with inspector of a browser
``` js
var s = angular.element($0).scope();
```

##### Tips
- In order to avoid collisions with some future standard, it is best to prefix your own directive names.
- Attribute versus element. Use an element when you are creating a component that is in control of the template. The common case for this is when you are creating a Domain-Specific Language for parts of a template. Use an attribute when decorating an existing element with new functionality.
- Directives should clean up after themselves. You can use `element.on('$destroy', ...)` or `scope.$on('$destroy', ...)` to run a clean-up function when the directive is removed.
- Use `$broadcast` and `$emit` in directive to communicate to "outside" world.
- Avoid using jQuery validators and use AngularJS ones as jQuery ones not quite testable due to DOM manipulation
