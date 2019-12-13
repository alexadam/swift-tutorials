
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
