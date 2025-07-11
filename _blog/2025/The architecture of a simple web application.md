The architecture of a simple web application
====

Recently I came to appreciate the beautiful elegance of HTML only web applications once again. While there have been reasons we (as software industry) have moved away from server side rendered applications, it is not for the reasons commonly stated. Just some reasons found in the wild:

- "SSR is more complex and time consuming than client side development"
- "SSR incurs more server load"
- "SSR requires more developer skills"
- "SSR lacks in interactivity" 

While the last point has a sliver of truth in it, all other points are just plain skill issues.

It is fascinating to have seen the state of the art web development practices swing back and forth over the last decade or so. It had been in the 2010's that many web applications started to move over to a single page application model, where client side and global state were explicitly separated. While this move had its reasons, we have now moved to a state where SSR applications are the exception rather than the rule. This - in my humble opinion - is in part due to hype cycles, and in part due to a grave misunderstanding on the architecture of web applications; or perhaps a misunderstanding about software architecture in general.

The default assumption in new web development projects being a client-side application for the web is an indictment of the web developers' fetish for complexity, and misunderstanding of abstraction layers. By far the most convenient way to communicate between a client and a server is through forms and HTTP messages. Much of everything else is tacked onto this. Authorization for example can be tacked onto nearly for free as long as the browser sends a cookie along with every request it makes.

The fact that HTTP itself is a stateless protocol should act as encouragement for application developers to think thoroughly about the structure of their API in consolidation with the way users intend to use their applications. While client-side frontend applications allow one to create more dynamic applications, the quality of a clie