## [0.3.0] - 02.03.2020
* Remove default `queryParameters` argument value
* Change `HttpMethod` enum names case 
## [0.2.0+3] - 01.03.2020
* Fixed call method body parameter type
## [0.2.0+2] - 09.02.2020
* Simplify gettting started code examples inside readme.md
## [0.2.0] - 08.02.2020
* Added experimental state management
  * Added `Updater` widget 
    * Added  `ApiLinkUpdater` widget
    * Added  `ApiStoreUpdater` widget
  * Added `ApiStorage` class
    * Added `ApiStore` 
      * Added `NotifierApiStore` class
  * Added `NotifierApiLink` class
* Improved `Query` widget
  * Added `variable` argument
  * Added `updaterBuilder` argument
  * Added `schouldUpdate` argument
  * Changed `initialData` to `initialDataBuilder` argument
  * `QueryState` `call` method now accepts (optional) variable 
## [0.1.0+1] - 07.02.2020
* Fix readme bugs
## [0.1.0] - 07.02.2020
* Initial release
* Removed `provider` package from dependencies
* Added `Query.of<A extends ApiBase>()` method which provide access to the API class instance
* Added readme section about `ApiLink`
* Added readme section about example app
  
## [0.0.2] - 01.02.2020
* Added getting started readme section
* Added support for `ApiLink`s
* Improved `Query` widget
  
## [0.0.1] - 14.01.2020
* Extracted Restui library from app
