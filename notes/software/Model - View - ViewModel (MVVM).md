Model - View - ViewModel (MVVM)
=======================

The MVVM pattern is a way to decouple various components of front-end applications from one another. There is a clear distinction between the data source (the model), what data and interactions are available for the end user to interact with (the view model) and how this is all presented (the view). A supposed benefit of this approach is the clear separation of concerns, as well as reusability of components.

> MVVM correctly implemented would allow one to reuse the model and viewmodels, while attaching these to newly developed views.

Reuse of the model and viewmodels is relevant in a number of situations:

- When the frontend needs to be implemented on multiple platforms (e.g. web and mobile), the main application model can be reused, only attaching a new frontend.
- When needing to migrate to a new frontend framework due to deprecations

The main challenge with a proper MVVM implementation is not directly coupling the viewmodel to the views. This can happen in multiple subtle ways:
- Providing hard-coded control instances from the viewmodel to the views
- Directly talking to view controls from the viewmodel
- Manually loading in views from viewmodels

Ideally the viewmodel should only exhibit data (bindable properties) and behaviour (commands).

## Testability
A properly set up viewmodel also brings the benefit of testability. It is possible to use viewmodels as an abstract representation of the application, without having to actually render an application. This allows to test the main interaction flows of the application. If these pass, one can be fairly sure behaviour is correctly implemented. The remaining error surface can generally be found in bindings between the viewmode