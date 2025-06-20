Model - View - ViewModel (MVVM)
=======================

The MVVM pattern is a way to decouple various components of front-end applications from one another. There is a clear distinction between the data source (the model), what data and interactions are available for the end user to interact with (the view model) and how this is all presented (the view). A supposed benefit of this approach is the clear separation of concerns, as well as reusability of components.

> MVVM correctly implemented would allow one to reuse the model and viewmodels, while attaching these to newly developed views.

Reuse of the model and viewmodels is relevant in a number of situations:

- When the frontend needs to be implemented on multiple platforms (e.g. web and mobile), the main application model can be reused, only attaching a new frontend.
- When needing to migrate to a new frontend framework due to deprecations

The challenge with a proper MVVM implementation is not directly coupling the viewmodels to the views themselves (forget model to view bindings: you're out). This