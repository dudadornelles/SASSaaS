SASSaaS
=======

A service that given a url with a SASS file returns the compiled CSS


## Features:
* It supports **'@import'** given the required files are in the same path, e.g:
 - If you have a file in **'localhost/scss/main.scss'** you will be able to **@import** any scss file into main.scss as long as these files are also located in **'localhost/scss/<here>'**
* It supports compass

## How-to
Deploy it and you can access compile files by accessing

```
<url>/compile?f=<url for the file>
```

Where:
* **url**: where you deployed your SASSaaS instance
* **url for the file**: where the file is

## Try it!
```
curl sassaas.herokuapp.com/compile?file=<url for your file>
```

