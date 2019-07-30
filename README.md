Excalibur -- The Simple App for Language Comparison
========================================================================================================================
In an Idomatic Way (common for the langauge) Implement a solution for the following:

* List of Financial Individual Transactions in JSON
* Put in Database
* Read from Database and produce Monthly Summary (how much money spent each month)
* REST Interface


Directory Layout
------------------------------------------------------------------------------------------------------------------------
At the top level, code is broken into "server_side", "browser_side" and "db"  This is to help prevent confusion arising
from angular's use of the word "service" to denote a browser-side artifact.

Within each of these top level directories, directories with langauge names should exist.  Though at the time of
writing many of them do not.

Writing "functionally" in a non-functional language is encourage, but anotate your language directory accordingly,
for example:

* python -- Python in a way most python programmers would write it
* python_objectOriented -- Python written in as Object Oriented a style as possible
* python_functional -- Python writtin in as functional a style as possible


```
+browser_side
|   +elm
|   +angularjs
|   +angular
|
+server_side
    +nest
    +nodejs
    +typescript
    +python
    +python_functional
    +haskell
```

Implementor Notes
------------------------------------------------------------------------------------------------------------------------
Track the number of bugs found in the following phases, this will have to be done manually, so it's a best effort
kind of thing:

Compiler refers to any of the following:  A compiler proper, an interpreter, a linter, or any combination normally
used by that language.  I.e. JavaScript programmers tend to rely heavily on lenters for "Compile Phase" error detection.

* Compiler Detected Bugs in Product, without Unit Test Execution
* Compiler Detected Bugs in Product found during Unit Test Execution
* Unit Test Detected Bugs in Product, these bugs are found by the unit tests, not the Compiler
* Human Detected Bugs in Product found outside of Unit Testing

The distinction between the first two points is for languages like JavaScript, which has no real compile phase,
and Typescript which has a large amount of compiler support, but it is still possible to implement errors which
go undetected until execution time.  Particularly in sophisticated SPA frameworks.

The two are not equivalent, in that a truely compiled language will not show "compiler detected" bugs at run time, but
interpreters often do.  So a language like JavaScript relies heavily on high unit-test coverage to get the interpreter
to analyse every line of code even for syntax errors, vs a language like Haskell where the compiler will always analyize
every line of code.

There are also a number of languages falling somewhere in-between. Java, Python, .Net, Typescript, etc.... all have a
compile phase, implicit or explicit, where the compiler is able to detect errors.  They also all have a largish class of
errors that is not detectable until run-time.  This typically includes things like Reflection in .Net or the "Duck
Typing" python does.  Things that definately add to the flexibility of the language, but make it much more difficult
for the compiler to find the errors.


Excalibur Specifications
========================================================================================================================


REST Interface
------------------------------------------------------------------------------------------------------------------------
GET /transactions -- gets all transactions
GET /transactions/:id -- gets 1 transaction
POST /transactions -- Creates a new transaction, must include JSON body
PATCH /transactions/:id -- Updates a transaction, must include JSON body with fields to update (or all fields)
DELETE /transactions/:id -- Deletes a transaction
GET /summaries/:year_number/:month_number -- Fetches a summary for the year and month specified



Browser Side Functionality
------------------------------------------------------------------------------------------------------------------------
NO AUTHENTICATION
Must be as simple as possible, meaning no UX work to distract from comparisons of functionality

Enter transactions
Read transactions
Display monthly summary, as fetched from REST interface


Server-Side Functionality
------------------------------------------------------------------------------------------------------------------------
Only write code sufficient to implement the REST Interface.

Try and keep long-descriptions in separate files.


Transaction
------------------------------------------------------------------------------------------------------------------------
```json
{
 "date": "2019-07-12",
 "amount": 23.34,
 "vendor": "Wal-Greens"
}
```


Monthy Summary
------------------------------------------------------------------------------------------------------------------------
```json
{
  "month_name": "October",
  [
   {
    "vendor": "Wal-Greens",
    "paid_to_vendor_this_month", 5645.00
   },
   ....
  ]
}
```
