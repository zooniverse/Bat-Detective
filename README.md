Bat Detective
=============

Install
-------

    bundle install
    grabass assets.json
    npm install -g requirejs

Run
---

    jekyll --auto --server
    open http://localhost:3475

Build
-----

    jekyll
    cd _site/scripts
    r.js -o baseUrl=. name=main out=main.js
