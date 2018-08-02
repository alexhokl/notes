# Anggular

#### General

- [Upgrade Guide](https://update.angular.io/)


# AngularJS

#### General

-	[The Unofficial Angular Docs](http://ngdoc.io/)
-	[Debugging Protractor Tests](http://www.protractortest.org/#/debugging)
-	[Migration Guides](https://docs.angularjs.org/guide/migration)
-	[Service vs provider vs factory](https://stackoverflow.com/questions/15666048/angularjs-service-vs-provider-vs-factory)
-	[Techniques for authentication in AngularJS applications](https://medium.com/opinionated-angularjs/techniques-for-authentication-in-angularjs-applications-7bbf0346acec)
-	[Angular data table from Swimlane](http://swimlane.github.io/angular-data-table/)
-	[Lifecycle hooks in Angular 1.5](https://toddmotto.com/angular-1-5-lifecycle-hooks)
-	[Angular 1.6 is here, this is what you need to know](https://toddmotto.com/angular-1-6-is-here)
-	[Improving ng-repeat Performance with “track by”](http://www.codelord.net/2014/04/15/improving-ng-repeat-performance-with-track-by/)

#### Checking AngularJS scope variables with inspector of a browser

```js
var s = angular.element($0).scope();
```

#### Refactoring on version 1.4

The refactoring is done to make sure the codebase can be ported to Angular2 and beyond (See [Refactoring Angular Apps to Component Style](http://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html)). Here are the steps involved.

##### 1. [Replace `ng-include` with directive](https://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#replace-ng-include-with-component-directive)

-	`ng-include` is a relatively low-level feature that pollutes your view with information about template file locations.
-	Create a directive, named after the template. Make it use a new inherited scope (`scope`: `true`).

##### 2. [Replace `ng-controller` with directive](https://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#replace-ng-controller-with-component-directive)

-	`ng-controller` often demarcates an area of the template that is somehow independent, or separate from its parents and siblings. If it is, it should be a component.
-	Create a directive, named after the controller. Make it use an inherited scope (`scope`: `true`).

##### 3. [Wrap Markup in directive](https://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#wrap-markup-in-component-directive)

-	There is a big template, with no `ng-controller`s or `ng-include`s inside it.
-	If there is some part inside the extracted HTML that you would rather leave in place, you can use transclusion.

##### 4. [Replace External Reference with Bound Input](https://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#replace-external-reference-with-bound-input)

-	In the template, find any functions or variables which bind to a foreign controller and introduce a binding for this external reference, and put it in the `bindToController` section of the directive. Lastly, replace the external reference with a reference to the new controller binding.
-	For `$watch`, `$watchCollection`, or `$watchGroup` referencing expressions in a foreign controller, ntroduce a binding for this external reference, and put it in the `bindToController` section of the directive. Lastly, replace the external reference with a reference to the new controller binding. In order words, the watch statements can be kept but we make sure it is not referencing a foreign controller.

##### 5. [Replace External Effect with Bound Output](https://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#replace-external-effect-with-bound-output)

-	Effectively same mechanics as in previous step. The key words to searach for like `ng-change` or `ng-click`. Instead of using `=` in `bindToController`, we use `&` to allow the expression to be evaluated in the context of the original scope, at a specific time.

##### 6. [Isolate Component](http://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#isolate-component)

-	Replace `scope: true` with isolated scope `scope: {}`

##### 7. [Replace State Mutation with Bound Output](http://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#replace-state-mutation-with-bound-output)

-	The idea is to avoid mutating inputs and, instead, make calls to outside method (via an `&` binding) to tell outside to make the actual change.
-	An example of mutating inputs is an array passed into a directive and the directive try to remove one (or more) items from that array.

##### 8. [Replace Two-way Binding with One-way Binding](http://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#replace-two-way-binding-with-one-way-binding)

-	If a component indeed does reassign the value on purpose, an explicit output binding should be used instead of piggybacking on the two-way input.
-	Replace a two-way `=` binding on the directive configuration with an expression binding `&`.
-	Change all accesses (not just assignments) to the binding inside the component to function calls.
-	This refactoring has the same spirit as the previous refactoring.

##### 9. [Toward Smart And Dumb Components](http://teropa.info/blog/2015/10/18/refactoring-angular-apps-to-components.html#toward-smart-and-dumb-components)

-	Smart components are connected to services. Though they may have inputs and outputs, they mostly know how to load their own data, and how to persist changes when they occur.
-	Dumb components are fully defined by their bindings: All data they use is given to them as inputs, and every change they introduce comes out as an output.
-	Try coming up with a component structure with few smart components at the root, and many dumb components downward from there.

#### Refactoring on version 1.5

The refactoring is done to make sure the codebase can be ported to Angular2 and beyond. Here are the steps involved.

-	Replace `$http.success(function (data))` with `$http.then(function (response))`.
-	Replace `$http.error(function (err))` with `$http.then(function (response), function (err))`.
-	Put all initialisation code in a controller (be it directive, component or just a controller) in `this.$onInit`. `$OnInit` is called right after the directive’s data-bound properties have been checked for the first time, and before any of its children have been checked. It is invoked only once when the directive is instantiated.
-	Convert all the component directive to component. That is, converting all directives where it does not involve DOM manipulation to components.

```js
// before
.directive('counter', function counter() {
  return {
    scope: {},
    bindToController: {
      count: '='
    },
    controller: 'AbcController',
    controllerAs: 'ctrl'
  };
});

// after
.component('counter', {
  bindings: {
    count: '='
  },
  controller: 'AbcController as ctrl'
});
```

-	Use one-way binding `<` as much as possible and to avoid two-way binding `=`.
-	Use `$onChanges` to make data flow within a component more explicit. `$onChanges` is called in the local component controller from changes that occurred in the parent controller. Changes that occur from the parent which are inputted into a component using `bindings: {}`.

```js
var childComponent = {
  bindings: {
    user: '<',
    onUpdateUser: '&'
  },
  controller: function () {
    this.$onChanges = function (changes) {
      if (!!changes.user) {
        if (changes.user.isFirstChange()) {
          return;
        }
        this.user = angular.copy(changes.user.currentValue);  // as oppose to previousValue
      } else {
        this.user = null;
      }
    };
    this.updateUser = function () {
      this.onUpdateUser({
        $event: {
          user: this.user,
        },
      });
    };
  }
};

angular
  .module('app')
  .component('childComponent', childComponent);
```

# Angular

#### Migrating Angular 1.5 application in ES6 to Angular 2.0

This documents the steps involved in such a migration (see [Migrating Angular 1 Applications to Angular2 in 5 Simple Steps](https://vsavkin.com/migrating-angular-1-applications-to-angular-2-in-5-simple-steps-40621800a25b)).

See [Addicted to AngularJS?](https://www.youtube.com/watch?v=RyY8Brjs-Hg) for a brief introduction on mixing AngularJS and Angular

##### 1. Bootstrap with UpgradeModule

Create an Angular2 module with a simple root component rendering an element with the `ng-view` class. This component bootstraps the application and plugs the upgrade module as well.

```js
// ng2_app.js

import {NgModule, Component} from '@angular/core';
import {BrowserModule} from '@angular/platform-browser';
import {UpgradeModule} from '@angular/upgrade/static';

@Component({
  selector: 'root-cmp',
  template: `
    <div class="ng-view"></div>
  `,
})
export class RootCmp {}

@NgModule({
  imports: [
    BrowserModule,
    UpgradeModule,
  ],
  bootstrap: [RootCmp],
  declarations: [RootCmp]
})
export class Ng2AppModule {
  constructor(public upgrade: UpgradeModule){}
}
```

Assuming the Angular 1.5 application looks like the following.

```js
// ng1_app.js

import * as angular from 'angular'
import 'angular-route'

import {MessagesModule} from './messages';
import {MenuModule} from './menu';
import {SettingsModule} from './menu';

export const Ng1AppModule = angular.module('Ng1AppModule', ['ngRoute', SettingsModule.name, MessagesModule.name, MenuModule.name]);
```

Write the "main" javascript file to bootstrap Angular2 first. We then bootstrap Angular1 using `NgUpgrade.bootstrap`. Note that the Angular1 router uses the `ng-view` created by `RootCmp` for instantiating its templates.

```js
// main.js

// import polyfills
import 'core-js/es7/reflect'
import 'zone.js/dist/zone'

// import angular2 dpes
import {platformBrowserDynamic} from '@angular/platform-browser-dynamic';

import {Ng1AppModule} from './ng1_app';
import {Ng2AppModule} from './ng2_app';

/**
 * We bootstrap the Angular2 module first, and then, once it's done,
 * bootstrap the Angular 1 module.
 */
platformBrowserDynamic().bootstrapModule(Ng2AppModule).then(ref => {
  // bootstrap angular1
  (<any>ref.instance).upgrade.bootstrap(document.body, [Ng1AppModule.name]);
});
```

##### 2. Make all modules export an NgModule

-	Update all the modules to export an `NgModule`
-	Add line `import {NgModule} from '@angular/core';`
-	At the bottom of the module export the module as `NgModule` by adding the following lines.

```js
// This is the Angular2 part of the module
@NgModule({})
export class AbcNgModule {}
```

-	At this moment `AbcNgModule` is empty. Eventually, we will move all the components, services, and routes from `AbcModule` to `AbcNgModule`.
-	Import `AbcNgModule` to `ng2_app.js` (right under `UpgradeModule`).

##### 3. Migrate individual components and services to Angular2, one module at a time

-	While migrating services is usually straightforward, migrating components can require more work, depending on how the components are implemented.
-	Assuming the migration of the component is done, and the required steps are to register it and to downgrade it.

```js
// messages/index.js

import * as angular from 'angular';
import {NgModule} from '@angular/core';
import {UpgradeModule, downgradeComponent} from '@angular/upgrade/static';

import {Repository} from './repository';
import {MessageTextCmp} from './message_text_cmp';
import {MessagesCmp} from './messages_cmp';
import {MessageCmp} from './message_cmp';

export const MessagesModule = angular.module('MessagesModule', ['ngRoute']);

MessagesModule.component('messages', MessagesCmp);
MessagesModule.component('message', MessageCmp);
MessagesModule.service('repository', Repository);
MessagesModule.config(($routeProvider) => {
  $routeProvider
    .when('/messages/:folder',     {template : '<messages></messages>'})
    .when('/messages/:folder/:id', {template : '<message></message>'});
});

@NgModule({
  // components migrated to Angular2 should be registered here
  declarations: [MessageTextCmp],
  entryComponents: [MessageTextCmp],
})
export class MessagesNgModule {}

// components migrated to Angular2 should be downgraded here
MessagesModule.directive('messageText', <any>downgradeComponent({
  component: MessageTextCmp,
  inputs: ['text']
}));
```

-	Make the Repository service available for Angular2 components.

```js
// messages/index.js

//...

export function exportRepository(m: UpgradeModule): Repository {
  return m.$injector.get('repository');
}

@NgModule({
  // components migrated to Angular2 should be registered here
  declarations: [MessageTextCmp],
  entryComponents: [MessageTextCmp],

  providers: [
    {provide: Repository, useFactory: exportRepository, deps: [UpgradeModule]}
  ]
})
export class MessagesNgModule {}

//...
```

-	At the end of this step we have all the components and services of a module migrated to Angular2. Now we can start migrating its routes.

##### 4. Divide the routes between the Angular 1 and the Angular2 routers

-	An example of a module having its routes migrated

```js
// settings/index.js

// This module was fully migrated to Angular2
import * as angular from 'angular';

import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {RouterModule} from '@angular/router';
import {FormsModule} from '@angular/forms';
import {SettingsCmp} from './settings_cmp';
import {PageSizeCmp} from './page_size_cmp';

// Since the whole module has been migrated to Angular2,
// there is nothing you need to do here anymore.
export const SettingsModule = angular.module('SettingsModule', []);

@NgModule({
  imports: [
    CommonModule,
    FormsModule,

    // migrated routes
    RouterModule.forChild([
      { path: 'settings', children: [
        { path: '', component: SettingsCmp },
        { path: 'pagesize', component: PageSizeCmp }
      ] },
    ])
  ],
  declarations: [SettingsCmp, PageSizeCmp]
})
export class SettingsNgModule {}
```

```js
// ng2_app.js

@NgModule({
  imports: [
    BrowserModule,
    UpgradeModule,

    // import all modules
    MenuNgModule,
    MessagesNgModule,
    SettingsNgModule,

    // You don't need to provide any routes.
    // The router will collect all routes from all the registered modules.
    RouterModule.forRoot([], {useHash: true, initialNavigation: false})
  ],
  providers: [
    // Providing a custom url handling strategy to tell the Angular2 router
    // which routes it is responsible for.
    { provide: UrlHandlingStrategy, useClass: Ng1Ng2UrlHandlingStrategy }
  ],

  bootstrap: [RootCmp],
  declarations: [RootCmp]
})
export class Ng2AppModule {
  constructor(public upgrade: UpgradeModule){}
}
```

```js
// Ng1Ng2UrlHandlingStrategy.js
class Ng1Ng2UrlHandlingStrategy implements UrlHandlingStrategy {
  shouldProcessUrl(url) { return url.toString().startsWith("/settings"); }
  extract(url) { return url; }
  merge(url, whole) { return url; }
}
```

-	Update the root component to include an Angular2 router outlet.

```js
@Component({
  selector: 'root-cmp',
  template: `
    <router-outlet></router-outlet>
    <div class="ng-view"></div>
  `,
})
export class RootCmp {}
```

-	In this setup the Angular2 router and the Angular1 router coexist on the same page. Every URL is handled by only one router, that is, the routers handle subsets of the URLs supported by the application.
-	If an application module has been migrated to Angular2, all its routes are handled by the Angular2 router. So when navigating from an Angular1 module to an Angular2 module, the Angular 1 router will remove its template from the `ng-view` element, and the Angular2 router will place its component into the router outlet.
-	The Angular2 Router uses the provided `UrlHandlingStrategy` to distinguish the URLs it should handle from those it should ignore.
-	Only when the user navigates from an Angular2 module back to an Angular1 module, the Angular2 router will reset its state to “empty” and will update the URL. This will destroy all the Angular2 components created by the router emptying the router outlet. The Angular1 router will pick up the URL change and will instantiate corresponding Angular1 components.

##### 5. Remove Angular 1 when every module has been migrated

-	Remove all the usages of `UpgradeModule`.

#### Links

-	[Animations in Angular 4.0.0](https://www.youtube.com/watch?v=Oh9wj-1p2BM)
-	[Automatic Progressive Web Apps using the Angular Mobile Toolkit](https://www.youtube.com/watch?v=ecu1vAO23ZM)

#### Directives and components

##### `&` binding syntax

Suppose there is a binding `onClick: '&'` and three parameters should be passed.

Within the controller of a directive, the parameters should be put in an object.

```js
if (!!ctrl.onClick) {
  ctrl.onClick({
    param1: value1,
    param2: value2,
    param3: value3,
  });
}
```

In the template using the directive,

```html
<my-directive on-click="ctrl.onButtonClick(param1, param2, param3)">
</my-directive>
```

#### ui.router

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

#### General Tips

-	In order to avoid collisions with some future standard, it is best to prefix your own directive names.
-	Attribute versus element. Use an element when you are creating a component that is in control of the template. The common case for this is when you are creating a Domain-Specific Language for parts of a template. Use an attribute when decorating an existing element with new functionality.
-	Directives should clean up after themselves. You can use `element.on('$destroy', ...)` or `scope.$on('$destroy', ...)` to run a clean-up function when the directive is removed.
-	Avoid using jQuery validators and use AngularJS ones as jQuery ones not quite testable due to DOM manipulation
