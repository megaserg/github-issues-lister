How to run
----------

- Install dependencies:
```
$ npm install
```

- Start Elm and Sass auto-rebuild:
```
$ gulp dev
```

- In another terminal, serve all endpoints with index.html:
```
$ ws --spa index.html
```

TODO
----

Required:
+ Routing+history (should work for any listpage and issue)
- Pagination: take note of next/prev
- "Main page" points to the last page
- Linkify users in issue text
- Better truncation

Nice to have:
- Break up in pieces
- Scroll to top when changing pages
- Better styles
- Change title on issue page
- Image preloading
- Updating user and repo
