
## Get query parameters

src: https://stackoverflow.com/questions/54958244/how-to-use-query-parameters-in-nest-js

```
@Get('products/:id')
getProduct(@Param('id') id) 
```

matches the routes

```
localhost:3000/products/1
localhost:3000/products/2abc
```

To match multiple endpoints to the same method you can use route wildcards:

```
@Get('other|te*st')
```

will match

```
localhost:3000/other
localhost:3000/test
localhost:3000/te123st
```

----
src: https://softwareengineering.stackexchange.com/questions/331049/why-do-req-params-req-query-and-req-body-exist/331055

req.query comes from query parameters in the URL such as http://foo.com/somePath?name=ted where req.query.name === "ted".

req.params comes from path segments of the URL that match a parameter in the route definition such a /song/:songid. So, with a route using that designation and a URL such as /song/48586, then req.params.songid === "48586".

req.body properties come from a form post where the form data (which is submitted in the body contents) has been parsed into properties of the body tag.

----

src: https://stackoverflow.com/questions/14417592/node-js-difference-between-req-query-and-req-params

app.get('/hi/:param1', function(req,res){} );

and given this URL http://www.google.com/hi/there?qs1=you&qs2=tube

You will have:

req.query

{
  qs1: 'you',
  qs2: 'tube'
}

req.params

{
  param1: 'there'
}

-------

