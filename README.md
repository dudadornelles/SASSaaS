SASSaaS
=======

A service that given a url with a SASS file returns the compiled CSS

## Try it!
```
curl sassaas.herokuapp.com/compile?f=https://raw.githubusercontent.com/twbs/bootstrap-sass/master/assets/stylesheets/_bootstrap.scss
```

## Features:
* You can import files in your folder structur
* It supports compass
* Simple cache control

## How-to
Deploy it and you can access compile files by accessing

```
<url>/compile?f=<url for the file>&clean=<true|false>
```

Where:
* **url**: where you deployed your SASSaaS instance
* **url for the file**: where the file is
* **clean**: send 'clean=true' to clean the cache



