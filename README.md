SQL Interpreter Workshop
=========================

Curriculum is on [external-dsl-ruby.baroquebobcat.com](http://external-dsl-ruby.baroquebobcat.com/)

Writing a SQL interpreter in Ruby, driven by tests.

We'll be doing this iteratively
It'll go like this

* Pick a statement to implement
* Write an integration test

* Figure out what the semantic model should look like for it
* write tests for the semantic model
* then the parser
* then the transformer

First, we'll build a walking skeleton
We'll build a tiny bit of the parser, the transformer and the semantic model


Dependencies
----------------
* _Ruby_ of course
* _Parslet_ a PEG parser combinator toolkit
