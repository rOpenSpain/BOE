# BOE (development version)

 * Now `retrieve_sumario()` provides informative error if a cve is provided 
 instead of a date (#17).
 
 * New functions to access the supplements, `suplemento_cve()` and 
  `sumario_suplementos()`. 
  These are only accessible for 3 months.
  
 * New function `valid_code()` returns a logical value instead of an error as 
  `check_code()`.
 
 * New function `last_date_boe()` returning the date of the last valid publication.
 
 * Better handling of dates (new fecha_anulacion).
 
 * `retrieve_sumario()` keeps all columns even if they are empty.
 
 * `retrieve_document()` works for some documents before 2009. 
 

## Breaking changes: 

 * If a function returns a valid CVE now it has an suffix `_cve`. This affects `anuncio`, `disposicion` and specially `sumario*`.

# BOE 0.1.7

* Change to permissive MIT license.
* New `retrieve_document` to retrieve and tidy any document from BOE.
* Now codes are checked before requesting them to the API. 

# BOE 0.1.6

* Added a `NEWS.md` file to track changes to the package.
