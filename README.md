Bat Detective
=============

Install
-------

    bundle install
    grabass assets.json

Run
---

    jekyll --auto --server
    open http://localhost:3475

Build
-----

    jekyll
    npm install -g requirejs
    cd bat-detective/scripts
    r.js -o baseUrl=. name=main out=main.build.js
    mv main.js main.src.js
    mv main.build.js main.js
