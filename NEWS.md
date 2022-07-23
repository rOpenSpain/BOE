# BOE (development version)

 * Now `retrieve_sumario` provides informative error if a cve is provided 
 instead of a date (#17)

## Breaking changes: 

 * If a function returns a valid CVE now it has an sufix `_cve`. This affects `anuncio`, `disposicion` and specially `sumario*`.

# BOE 0.1.7

* Change to permissive MIT license.
* New `retrieve_document` to retrieve and tidy any document from BOE.
* Now codes are checked before requesting them to the API. 

# BOE 0.1.6

* Added a `NEWS.md` file to track changes to the package.
