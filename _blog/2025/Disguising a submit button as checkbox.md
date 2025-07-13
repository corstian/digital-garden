Disguising a submit button as checkbox
====

The attempt to disguise submit buttons as checkboxes is part of my recent shenanigans with HTML-only web applications. During the design of these server-side rendered HTML pages you're faced with what turns out to be the modern usage of UI elements. In this case checkboxes.

The present case is best comparable with a sample todo list application, but then server side rendered. While I have issue with the notion of a todo list (they are never truly finished), this serves as a perfect example showcasing the disconnect between modern UI design and the original purpose HTML forms had been designed for. Naturally each todo item in such an application requires a checkbox to tick it off the list. 'Trivial' to do in a SPA-application, but more difficult to achieve when dealing with a fully static web page.

The form native way would be to render a submit button: "done". Doing so however drastically changes the user experience. Iconography is just more expressive than a button containing some text.