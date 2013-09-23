External DSLs in Ruby
======================

Schedule
--------

 * 8:00 - 9:00: Overview of DSLs / what we're doing today
 * 9:00 - 9:10: break
 * 9:10 - 11:30: Curriculum

Overview
--------

# Rocking the workshop

 * Ask questions
 * Type along w/ me
 * Notes are on github.com/baroquebobcat/dsl_workshop
 * If you've got Q's after
   * twitter: @baroquebobcat
   * email: ndh@baroquebobcat.com

# Goals

 * Know when to use DSL
 * Know how to build an External DSL
 * Introduced to Compiler concepts like parsing

# DSLs

> Domain-specific language (noun): a computer programming language of limited 
> expressiveness focused on a particular domain.

-- http://martinfowler.com/dsl.html

DSLs are languages that let you describe computation in a particular domain in a way that's well tailored to that domain. Often that means that they are easier to understand than the equivalent code in a general language because they have no content that's not related to the problem at hand.

There are whole bunches of them: haml, sass, arel, jQuery, SQL, graphviz, regex, rake, make, rspec, Gherkin ...

## Internal vs External DSLs

Internal DSLs are embedded in a host programming language, eg rake. External DSLs have their own syntax, so they require their own parser.

Examples of Internal DSLs include libraries like Rake, or Arel from ActiveRecord.

### Builder vs Haml
Builder and Haml are both libraries that allow you to generate HTML. Haml is an External DSL. It has it's own syntax and parser, which allows it to have features like semantic whitespace and short ways of describing common HTMLisms.

Builder is an Internal DSL that builds arbitrary XML. Because it's an Internal DSL, it has to keep to Ruby's syntax, which means that it is more verbose than using Haml. But, writing the equivalent with regular imperative Ruby would be a lot more annoying and the structure of the data would be obscured more by other language constructs.

#### Haml
```haml
%section.container
  %h1= "title"
  %h2= "subtitle"
  .content
    = "some content"
```
#### Builder
```ruby
builder = Builder::XmlMarkup.new
builder.section(class: "container") do |b|
  b.h1 "title"
  b.h2 "subtitle"
  b.div("some content", class: "content")
end
```

### SQL

Since we're building a SQL implementation, I thought I'd also show some examples for representing equivalent computations with it.

SQL
```sql
select name, age from persons where favorite_food = 'bananas' limit 10
```
Ruby
```ruby
tables["persons"].select{|p|p["favorite_food"]=="bananas"}.map{|p| {name: p["name"], age: p["age"]}.first 10
```
Rails
```ruby
Person.where(favorite_food: 'bananas').select(:name, :age).limit(10)
```
Java
```java
// don't even get me started
```

## Why Use DSLs & Why External specifically?

As I showed in the examples above, DSLs are handy because they allow you to write programs that are closer to the problem you are trying to solve with less extraneous bits. They might not be good at solving problems outside their domain (eg: Regex for XML), but they are great at the domain they are designed for.

DSLs can also be a communication tool with non-technical stakeholders. When you write programs using only domain terminology, you make those programs grokable by domain experts.

External DSLs are especially good for this because they don't carry any extra features / syntax from another language.

DSLs allow you to represent different models of computation than your host language. The most popular languages today are imperative ones but sometimes the best way to describe a computation is not with an imperative model.

E.g. State Machines. State Machines in an imperative language show up as big blocks of if statements or case statements, which don't represent very well what you are actually modeling. State machines are all about transitions and states, not ifs or cases. With a DSL you can model those relationships more effectively.

Another common pattern are Production Rule Systems. An example in Ruby / Rails would be ActiveRecord's validations. It would be super annoying to write imperative code equivalent to `validates :age, inclusion: { in: 0..9 }`. With the validation DSL, you don't have to.

## When would you want to avoid using a DSL

* DSLs are great when you have lots of code you need to write that's going to all look almost the same, but with some fiddly differences. Smaller domains probably don't need it as much.
* Writing parsers and interpreters isn't intrisicly hard, but it requires a certain meta point of view and if you aren't used to building them it takes a bit to put your head around them.
* DSLs add another thing to learn to a project. Learning a new language on top of groking a whole project could be challenging to new people. On the other hand, DSLs can more susinctly describe a problem domain, _and_ the domain is what is complicated.
* Maintenance: When you write a DSL, if it gets used a lot, you will have to maintain it. That means dealing with versioning, deprecation, etc--everything a language designer deals with.



-------------------------------------------------


Convert to slides
-----------------

# one plus one
(0) `1 + 2`
(1) 

digraph hello {
  plus[label="+"];
  plus -> 1;
  plus -> 2;
}
(2) `Add.new Int.new("1"), Int.new("2")`
(3) `#=> 3`

# Hello World Transitions

(0) -> (1) Tree Construction
(1) -> (2) Transformation
(2) -> (3) Evaluation

# Tree Construction

> In order to construct the tree, we need to write a grammar
> a dumb grammar for this would be

`int.as(:left) >> plus.as(:add) >> int.as(:right)`

> which would leave us with

`{left: "1", add: "+", right: "2"}`

# Transform

> We'd then need to transform that.
> In parslet, that'd look like this:
```ruby
  rule(left: simple(:l),
       add: simple(:op),
       right: simple(:r)) { Add.new Int.new(l), Int.new(r) }
```

> `rule` takes a pattern that matches portions of the intermediate tree, & then runs the resulting block on that subtree.



----------------------


#Walking Skeleton

```


                 .-"```"-.
                /         \
                |  _   _  |
                | (_\ /_) |
                (_   A   _)
                 | _____ |
                 \`"""""`/
                  '-.-.-'
                   _:=:_                   \\|
            .-""""`_'='_`""""-.           \///
           (`,-- -`\   /`- --,`)          (`/
           / //`-_--| |--_-`\\ \         .//
          / /(_-_  _| |_  _-_)\ \       ///
         / / (_- __ \ / __ -_) \ \     ///
        / /  (_ -_ - ^ - _- _)  \ \   ///
       / /   (_-  _ /=\ _ - _)   \ \ '//
      / /     (_ -.':=:'. -_)     \ \//
     (`;`     (_-'  :=:  '-_)      (_,'
      \\.   jgs __  :=:  __
       \\\    .'  `':=:'`  '.
        \\\  |  .--. = .--.  |
         \\\ |  (  / = \  )  |
          \\` \ _`' \=/ '`_ /
          ;`)  ( ;_/`v`\_; )
          |||\ | |       | |
          |\\  | |       | |
               | |       | |
               | |       | |
               | |       | |
               | |       | |
               | |       | |
              (._)       (_.)
               ||,       ,||
               ||:       :||
               ||:       :||
               ||:       :||
               ||:       :||
               ||'       '||
              ///)       (\\\
            .///`         `\\\.
           `//`             `\\`
```
[source](http://www.retrojunkie.com/asciiart/health/skeleton.htm)

# Wild Card Walking Skeleton

Walking Skeleton

> an implementation of the thinnest possible slice of real functionality that we can build, deploy and test end-to-end.
-- GOOGbT

For our SQL language, the thinnest possible query is a select star from a single table with no conditionals. In order to build that, we'll have to start the parser, the semantic model, the transformer that populates the semantic model and the basics of execution.


Our first SQL query to implement is this one:

`SELECT * FROM one_to_five`

Through it, we'll build a small part of all the needed pieces of our interpreter.


It's transitions

 0. `SELECT * FROM one_to_five`
 1.
```
digraph wildcard_0 {
  query -> from_table;
  from_table[shape="record"; label="FROM|one_to_five"]
}
```
We could build a tree like this, but I'm anticipating that we'll likely want to have different behavior for other SELECT args in the future. So, we'll make one that looks more like this:

```
digraph wildcard_0 {
  query -> from_table;
  query -> args[shape="record"; label="args|*"]
  from_table[shape="record"; label="FROM|one_to_five"]
}
```

 2. `SelectQuery.new(WildCard.new, FromTable.new("one_to_five"))`

 3. ```ruby
[{"dec"=>1,"eng"=>"one"},
    #... 
   ]
```

End slides
------------------------



## First Step of the Skeleton: Acceptance spec.

Open up `spec/sql_awesome_spec.rb`.

```ruby
describe SQLAwesome do
  # acceptance specs go here
end
```

Here we're going to add our first spec.

```ruby
describe SQLAwesome do
  it "retrieves all columns for all rows with a wildcard" do
    db = SQLAwesome.new_from_csv_dir "#{File.dirname(__FILE__)}/../data/"

    result = db.eval "SELECT * FROM one_to_five"
    result.must_equal db["one_to_five"]
  end
end
```

Some of this I wrote already to simplify things

```ruby
    db = SQLAwesome.new_from_csv_dir "#{File.dirname(__FILE__)}/../data/"
```

builds a `RDBMS` object with tables populated from the passed directory. It's specs are in `spec/rdbms_spec.rb` if you're interested.

The neat bit of the spec is
```ruby
    result = db.eval "SELECT * FROM one_to_five"
    result.must_equal db["one_to_five"]
```

What we're saying here is that evaling our wildcard query is equivalent to looking at the table directly. As in, it's got all the rows and all the columns. Just like if you were to run a `*` query with no `WHERE` clause. It's not an amazing test, but it'll serve to build our walking skeleton.

Let's run our specs:

```
$ rake
Run options: --seed 1845

# Running tests:

E.

Finished tests in 0.021476s, 93.1272 tests/s, 139.6908 assertions/s.

  1) Error:
test_0001_retrieves all columns for all rows with a wildcard(SQLAwesome):
NoMethodError: private method `eval' called for #<SQLAwesome::RDBMS:0x007f9ea196c480>
...
2 tests, 3 assertions, 0 failures, 1 errors, 0 skips
rake aborted!
```

Oops, I didn't write the `eval` method for the RDBMS! What should that look like? First, let's back up and talk architecture a little. Our little RDMS is going to need to be able to go through all the stages we talked about earlier. To do that, we'll need to split up some responsibilities.

```
digraph {
  query_string -> parser[shape=rect];
  parser -> tree;
  tree -> transformer[shape=rect];
  transformer -> semantic_model;
  semantic_model -> execution[shape=rect];
}
```


Let's drop some code in there to get started.

```ruby
  def eval query_string
    intermediate_tree = Parser.new.parse program
    model = Transformer.new.apply intermediate_tree
    model.eval @tables
  end
```

I've already setup classes for the Parser and Transformer in `lib/sql_awesome/`.

Both of these are using Parslet's parser generator framework classes as superclasses.

Let's see what happens now.

```
$ rake
Run options: --seed 4422

# Running tests:

E.

Finished tests in 0.017203s, 116.2588 tests/s, 174.3882 assertions/s.

  1) Error:
test_0001_retrieves all columns for all rows with a wildcard(SQLAwesome):
NameError: undefined local variable or method `root' for #<SQLAwesome::Parser:0x007f90e4944658>
```

That's an interesting error. Let's look at `lib/sql_awesome/parser.rb`

```ruby
module SQLAwesome
  # The Parser takes a string and turns it into an intermediate representation.
  # This representation can be used to populate the Semantic Model.
  class Parser < Parslet::Parser
    # root :statement

    # handy list pattern x.repeat(1,1) > (y >> x).repeat

    rule(:ident) { match('[a-zA-Z]') >> match('\w').repeat }
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    rule(:integer)    { match('[0-9]').repeat(1).as(:integer) }

    rule(:comma)      { str(',') >> space? }
  end
end
```

The reason it is complaining is because we need to define a root rule.

Parslet is an internal DSL for describing PEGs. Parser Expression Grammars. I've included some handy rules we'll use as building blocks.

Let's try uncommenting `# root :statement` and see what happens.

```
$ rake
Run options: --seed 41503

# Running tests:

E.

Finished tests in 0.016246s, 123.1072 tests/s, 184.6608 assertions/s.

  1) Error:
test_0001_retrieves all columns for all rows with a wildcard(SQLAwesome):
NoMethodError: undefined method `statement' for #<SQLAwesome::Parser:0x007f9ce407c618>
```

We haven't defined a rule for statements yet, so it blows up. Before we do that, let's write a test that shows what the input / output for the kind of statement we're building should look like.

Open up `spec/parser_spec.rb` and we'll write our first parser spec.

```ruby
it "converts a wildcard statement with no where into an intermediate tree" do
  tree = SQLAwesome::Parser.new.parse "SELECT * FROM a"
  tree.must_equal args: "*", from: "a"
end
```

Remember the tree diagram from before?

`Tree Diagram goes here`

> do we want parsing to be case-insensitive wrt keywords?

Now we have a new failing test

```
  2) Error:
test_0001_converts a wildcard statement with no where into an intermediate tree(SQLAwesome::Parser):
NoMethodError: undefined method `statement' for #<SQLAwesome::Parser:0x007f83cb089c00>
```

Let's make that one pass. In parser.rb, add this rule:

```ruby
    rule(:statement) { str("SELECT") >> space? >>
                       str("*").as(:args) >> space? >>
                       str("FROM") >> space? >> ident.as(:from)
                     }
```

That probably looks a little complicated, so let's break it down a little.

Parslet parsers are defined in terms of rules. You define a new rule by calling `rule` with a name and a block containing the grammar snippet that it matches. Rules are available in blocks as instance variables, which makes it easy to refer to them from other rules.

What this rule is doing is:

 1. `str("SELECT")` looking for the string `SELECT`
 2. `>> space?` This refers to the `space?` rule that was already written. It matches space characters or nothing.
 3. `str("*")` looks for the string `*`

 Parslet provides a number of small parsers or parslets that you combine to build a full parser. For example `str` is a helper method that actually creates an instance of a class that only recognizes strings.

 ```ruby
  def str(str)
    Atoms::Str.new(str)
  end
 ```
 [str impl](https://github.com/kschiess/parslet/blob/142f33bb147edede1753de7fc0ea066e07f565fb/lib/parslet.rb#L155-L157)


Parslet isn't the only way to build grammars for external DSLs in Ruby. It's just nice because as an internal DSL it doesn't have a separate compile step.

After adding the new code, the parser test is passing, and we're back to having a failing acceptance test. But, the error has changed.

```
  1) Error:
test_0001_retrieves all columns for all rows with a wildcard(SQLAwesome):
NoMethodError: private method `eval' called for {:args=>"*"@7, :from=>"one_to_five"@14}:Hash
    sql_workshop/lib/sql_awesome/rdbms.rb:13:in `eval'
```

What's going on here? Let's look back at `eval`

```ruby
    def eval query_string
      intermediate_tree = Parser.new.parse query_string
      model = Transformer.new.apply intermediate_tree
      model.eval @tables # line 13
    end
```

The problem is our `Transformer` isn't transforming anything! If you look in `lib/sql_awesome/transformer.rb`, you'll see it doesn't have much in it yet.

Parslet's transform framework helps you to convert the intermediate data structure created by it's parser into something more useful. In our case, we're going to use it to populate our semantic model of a SQL query.

It shares a similar interface with the parser's DSL, but instead of naming things on the left and describing what they match on the right, it describes what to match on the left and what to do with it on the right.

For our current tree, we only need one rule to transform into the right model classes--but before we do that, let's write a test.

```ruby
it "converts {args:'*', from:'a'} into a wild card query object" do
  result = SQLAwesome::Transformer.new.apply args:'*', from:'a'

  result.inspect.must_equal "Query: Fields:all FromTable:a"
end
```

This is probably not the best test we could write, but again, the point of the walking skeleton is to get all the pieces in place for building out more things. We can clean it up later if it comes to that.

Let's run tests again:

```
  2) Failure:
test_0001_converts {args:'*', from:'a'} into a wild card query object(SQLAwesome::Transformer) [sql_workshop/spec/transformer_spec.rb:8]:
--- expected
+++ actual
@@ -1 +1 @@
-"Query: Fields:all FromTable:a"
+"{:args=>\"*\", :from=>\"a\"}"
```

Sweet! A new failure! Since a transform with no rules does nothing, the resulting object is currently the input. Let's change that.

Here's the implementation:

```ruby
    rule(args: simple(:args),
         from: simple(:table_name)) { 
           SemanticModel::SelectQuery.new(SemanticModel::WildCard.new, table_name)
         }
```

Put this inside `lib/sql_awesome/transformer.rb` next to / replacing the commented out rules.

What does it do? Like I said above, Parslet's transforms work as pattern matchers. Our pattern is

```ruby
{        args: simple(:args),
         from: simple(:table_name)}
```

Which tells parslet to look for hashes inside the intermediate tree that have the keys `:args` and `:from` whose values are `simple`. When it finds a matching hash, it calls the block and replaces the matched portion of the tree with the result. While it's matching, it walks the tree leaves up, so each subtree is completed before going to it's parent. This lets you do some neat stuff, for example you could potentially write a calculator language that does all it's calculating in the transformer.

Values are `simple` if they are not arrays or hashes. So in our code, `args: simple(:args)` will match a hash that has the key args whose value is not an array or hash, eg `{args: "*"}`. It also matches things that are not strings, so something like `{args: WildCard.new}` would also work. Keep that in mind for later.

Let's run tests again.

```
  2) Error:
test_0001_converts {args:'*', from:'a'} into a wild card query object(SQLAwesome::Transformer):
NameError: uninitialized constant SQLAwesome::SemanticModel::SelectQuery
    sql_workshop/lib/sql_awesome/transformer.rb:5:in `block in <class:Transformer>'
```

Our semantic model classes don't exist yet! What should we do? Write more tests of course. To start, we'll just write enough to make the Transformer happy.

In `spec/semantic_model_spec.rb`
```ruby
describe SelectQuery do
  it "has a nice inspect format" do
    query = SelectQuery.new "args", "table"
    query.inspect.must_equal "Query: \"args\" FromTable:table"
  end
end
```

```
$ rake
sql_workshop/spec/semantic_model_spec.rb:6:in `block in <top (required)>': uninitialized constant SelectQuery (NameError)
```

Missing constant? Easily done.

```ruby
module SQLAwesome
  module SemanticModel
    class SelectQuery < Struct.new(:args, :from_table)
    end
  end
end
```

```

  2) Failure:
test_0001_has a nice inspect format(SQLAwesome::SemanticModel::SQLAwesome::SemanticModel::SelectQuery) [sql_workshop/spec/semantic_model_spec.rb:9]:
--- expected
+++ actual
@@ -1 +1 @@
-"Query: \"args\" FromTable:table"
+"#<struct SQLAwesome::SemanticModel::SelectQuery args=\"args\", from_table=\"table\">"
```

Let's add a better `inspect`.

```ruby
  def inspect
    "Query: #{args.inspect} FromTable:#{from_table}"
  end
```

Bam! now that test passes. But the transformer is still unhappy:
```
  2) Error:
test_0001_converts {args:'*', from:'a'} into a wild card query object(SQLAwesome::Transformer):
NameError: uninitialized constant SQLAwesome::SemanticModel::WildCard
```

Let's add it, but first a test.

```ruby
  describe WildCard do
    it "has an inspect that says it shows all fields" do
      WildCard.new.inspect.must_equal "Fields:all"
    end
  end
```

Failure on const after running `rake`:
```
sql_workshop/spec/semantic_model_spec.rb:12:in `block in <top (required)>': uninitialized constant WildCard (NameError)
```

Fix it in `lib/sql_awesome/semantic_model.rb`:

```ruby
class WildCard
end
```

Now it's failing properly:

```
  2) Failure:
test_0001_has an inspect that says it shows all fields(SQLAwesome::SemanticModel::SQLAwesome::SemanticModel::WildCard) [sql_workshop/spec/semantic_model_spec.rb:14]:
--- expected
+++ actual
@@ -1 +1 @@
-"Fields:all"
+"#<SQLAwesome::SemanticModel::WildCard:0xXXXXXX>"
```

Let's fix that now with

```ruby
  def inspect
    "Fields:all"
  end
```

And we're back to one failing test, our acceptance test.

```
  1) Error:
test_0001_retrieves all columns for all rows with a wildcard(SQLAwesome):
NoMethodError: private method `eval' called for Query: Fields:all FromTable:one_to_five:SQLAwesome::SemanticModel::SelectQuery
    sql_workshop/lib/sql_awesome/rdbms.rb:13:in `eval'
```

Now the problem is that we are calling eval on a SelectQuery object. Isn't that cool. It looks like all that's left is to add tests, and a method.


```ruby
  it "gives you back all the things in the table when args is a wild card" do
    query = SelectQuery.new WildCard.new, "a"
    result = query.eval "a" => [{"x"=>1}]
    result.must_equal [{"x"=>1}]
  end
```

Tests fail, as expected.
```
  2) Error:
test_0002_gives you back all the things in the table when args is a wild card(SQLAwesome::SemanticModel::SQLAwesome::SemanticModel::SelectQuery):
NoMethodError: private method `eval' called for Query: Fields:all FromTable:a:SQLAwesome::SemanticModel::SelectQuery
```
Add the missing method:
```ruby
def eval database
end
```
```
  2) Failure:
test_0002_gives you back all the things in the table when args is a wild card(SQLAwesome::SemanticModel::SQLAwesome::SemanticModel::SelectQuery) [sql_workshop/spec/semantic_model_spec.rb:15]:
Expected: [{"x"=>1}]
  Actual: nil
```

What should a SelectQuery do in this case? Well the simplest thing that could possibly work is to just look up the table.

```ruby
  database[from_table]
```

Now everything should be passing, but the acceptance test isn't. Why is that? If we took the time to put debug print statements in RDBMS.eval, what you'd see is that we are looking up the right table and the table is in the `@tables` hash. What gives?

This is a Parslet being a little tricky problem. Parslet, when it tokenizes, doesn't give you strings, it gives you `Slice`s, which means that when you try to use them as hash keys, weird things can happen(I bet there's a way to fix it, but I digress).

For now, the easiest way to ensure it works is to call `to_s` on the strings in the transformer.

```ruby
SemanticModel::SelectQuery.new(SemanticModel::WildCard.new, table_name.to_s)
```

```
$ rake
Run options: --seed 17061

# Running tests:

.......

Finished tests in 0.021596s, 324.1341 tests/s, 416.7438 assertions/s.

7 tests, 9 assertions, 0 failures, 0 errors, 0 skips
```

Now everything's passing and we've got our walking skeleton. The walking skeleton was the trickiest bit because we didn't have any structure in place yet. Now that it's done things should go more easily.

Next we'll start looking at filtering what fields we want to get out.


# Selecting a Single Field

The next feature we're planning on supporting is allowing users to specify what fields they want to pull out of a table.

```
SELECT eng FROM one_to_five
```

For this one we're going to modify our tree to make it able to represent both wild card and single field arguments. To do this we'll change the `args` subtree to let it support different types of things below it.

0. `SELECT eng FROM one_to_five`
 1.
```
digraph one_column {
  query -> from_table;
  query -> args;
  args -> field[shape="record"; label="field|eng"]
  from_table[shape="record"; label="FROM|one_to_five"]
}
```

 2. `SelectQuery.new(Field.new("eng"), FromTable.new("one_to_five"))`

 3. ```ruby
[{"eng"=>"one"},
    #... 
   ]
```

First, we'll put together the acceptance test.

```ruby
  it "retrieves one column for all rows when only that column is specified" do
    db = SQLAwesome.new_from_csv_dir "#{File.dirname(__FILE__)}/../data/"

    result = db.eval "SELECT eng FROM one_to_five"
    result.must_equal [
       {"eng" => "one"},
       {"eng" => "two"},
       {"eng" => "three"},
       {"eng" => "four"},
       {"eng" => "five"}
    ]
  end
```

Let's see what that gets us

```
$ rake
Run options: --seed 42840

# Running tests:

.E......

Finished tests in 0.021725s, 368.2394 tests/s, 414.2693 assertions/s.

  1) Error:
test_0002_retrieves one column for all rows when only that column is specified(SQLAwesome):
Parslet::ParseFailed: Failed to match sequence ('SELECT' SPACE? args:'*' SPACE? 'FROM' SPACE? from:IDENT) at line 1 char 8.
```

Failed to parse. As expected, since our current parser only works for `SELECT * FROM _` queries. That message is kind of ugly, we should fix it, but right now let's focus on getting selecting a column working.

> TODO
> * customize parse error handling to be nicer

Let's begin with changing the existing wildcard parser test to reflect our different tree.

```
digraph one_column {
  query -> from_table;
  query -> args;
  args -> field[shape="record"; label="wildcard|*"]
  from_table[shape="record"; label="FROM|one_to_five"]
}
```

We could leave it and create a new grammar rule that's separate, but I don't think it's as neat.

So our old test becomes:
```ruby
  it "converts a wildcard statement with no where into an intermediate tree" do
    tree = SQLAwesome::Parser.new.parse "SELECT * FROM a"
    tree.must_equal args: {wildcard: "*"}, from: "a"
  end
```

Which fails understandably.
```
  2) Failure:
test_0001_converts a wildcard statement with no where into an intermediate tree(SQLAwesome::Parser) [sql_workshop/spec/parser_spec.rb:7]:
--- expected
+++ actual
@@ -1 +1 @@
-{:args=>{:wildcard=>"*"}, :from=>"a"}
+{:args=>"*"@7, :from=>"a"@14}
```

We update the parser's rules.

```ruby
    rule(:statement) { str("SELECT") >> space? >>
                       args.as(:args) >> space? >>
                       str("FROM") >> space? >> ident.as(:from)
                     }
    rule(:args) { str("*").as(:wildcard)}
```

What I'm doing here is expanding the grammar to treat args as it's own rule. Right now it's kind of boring, just a wildcard, but it gives us a place to change the grammar.

That causes the parser tests to pass, but breaks our previous integration test, because the transformer doesn't know about the new structure. Let's fix it.

Test first:
```ruby
  it "converts {args:{wildcard:'*'}, from:'a'} into a wild card query object" do
    result = SQLAwesome::Transformer.new.apply args: {wildcard:'*'}, from:'a'

    result.inspect.must_equal "Query: Fields:all FromTable:a"
  end
```
Expected Failure:
```
  3) Failure:
test_0001_converts {args:'*', from:'a'} into a wild card query object(SQLAwesome::Transformer) [sql_workshop/spec/transformer_spec.rb:8]:
--- expected
+++ actual
@@ -1 +1 @@
-"Query: Fields:all FromTable:a"
+"{:args=>{:wildcard=>\"*\"}, :from=>\"a\"}"
```

Now for the implementation. Here we're creating a new rule specifically for wildcards. This will make it easy to drop in the field support next.
```ruby
rule(args: simple(:args),
     from: simple(:table_name)) { 
       SemanticModel::SelectQuery.new(args, table_name.to_s)
     }
rule(wildcard: simple(:asterisk)) { SemanticModel::WildCard.new }
```

Now we're back to one failing test. It's the one we're working on. I'd call that a good refactor.

Let's add a new parser test for the one field case.

```ruby
  it "converts a one field statement with no where into an intermediate tree" do
    tree = SQLAwesome::Parser.new.parse "SELECT b FROM a"
    tree.must_equal args: {field: "b"}, from: "a"
  end
```

Run tests and we see our good old parse error. But, now there's an simple place to drop in support.

All we have to do is add an OR to the new `args` rule we extracted in the last step.

```ruby
    rule(:args) { ident.as(:field) | str("*").as(:wildcard)}
```
In parslet, the `|` operator is overridden to construct a parser that accepts either the right side or left side. Here we make the args rule accept either an ident, in which case we call it field, or an asterisk, in which case we call it wildcard.

And, bam! Our error message changed, as expected, in the same way it did for the first task.

```
  1) Error:
test_0002_retrieves one column for all rows when only that column is specified(SQLAwesome):
NoMethodError: private method `eval' called for {:args=>{:field=>"eng"@7}, :from=>"one_to_five"@16}:Hash
```

This means that the transformer didn't do it's job because it couldn't recognize the new intermediate tree.

So, let's fix that up.
Test:
```ruby
  it "converts {args:{field:'b'}, from:'a'} into a single field query object" do
    result = SQLAwesome::Transformer.new.apply args: {field:'b'}, from:'a'

    result.inspect.must_equal "Query: Fields:[b] FromTable:a"
  end
```

```
  2) Failure:
test_0002_converts {args:{field:'b'}, from:'a'} into a single field query object(SQLAwesome::Transformer) [sql_workshop/spec/transformer_spec.rb:14]:
--- expected
+++ actual
@@ -1 +1 @@
-"Query: Fields:[b] FromTable:a"
+"{:args=>{:field=>\"b\"}, :from=>\"a\"}"
```

Implementation
```ruby
rule(field: simple(:field_name)) { SemanticModel::Field.new field_name.to_s }
```
It works the same as the wildcard transformation, only we want to pass that into the object we are constructing. And this time, we'll remember to `to_s` it.

> There may be times when you want to delay `to_s` when using parslet because you can use the Slice's metadata to your advantage when reporting errors.

That gets us our familiar const error.
```
  2) Error:
test_0002_converts {args:{field:'b'}, from:'a'} into a single field query object(SQLAwesome::Transformer):
NameError: uninitialized constant SQLAwesome::SemanticModel::Field
```

So, we go and start a new `describe` block in the `semantic_model_spec.rb`

```ruby
describe Field do
  it "has an inspect method that shows its field" do
    field = Field.new "myfield"
    field.inspect.must_equal "Fields:[myfield]"
  end
end
```

Then we go through the constant not found, define class, inspect uses default, redefine it dance to end up at this implementation.

```ruby
class Field < Struct.new(:name)
  def inspect
    "Fields:[#{name}]"
  end
end
```

And now we're back to the acceptance test, but with a new and interesting error.

```
  1) Failure:
test_0002_retrieves one column for all rows when only that column is specified(SQLAwesome) [sql_workshop/spec/sql_awesome_spec.rb:16]:
--- expected
+++ actual
@@ -1 +1 @@
-[{"eng"=>"one"}, {"eng"=>"two"}, {"eng"=>"three"}, {"eng"=>"four"}, {"eng"=>"five"}]
+[#<CSV::Row "dec":"1" "eng":"one">, #<CSV::Row "dec":"2" "eng":"two">, #<CSV::Row "dec":"3" "eng":"three">, #<CSV::Row "dec":"4" "eng":"four">, #<CSV::Row "dec":"5" "eng":"five">]
```

Back when we implemented the wildcard before, we just passed the table's values through without filter. But, what we really want is to have the SELECT's args determine what is passed through from each row. Let's change that for SelectQuery and WildCard, and then go back and finish this out.

SelectQuery doesn't need any test changes to support this, but currently WildCard has no notion about it, so let's write a test.

```ruby
  describe WildCard do
    # ...
    it "passes back the row as is when asked to filter" do
      wildcard = WildCard.new
      original = {"a"=>1,"b"=>2}
      result = wildcard.filter original
      result.must_equal original
    end
```

This results in a `NoMethodError` as expected. Let's implement it.

```ruby
  def filter row
    row
  end
```

And we're back to our failing acceptance test. But we're not done with the refactor. Now we can change SelectQuery to map all the rows of the table through the filter method and no new tests should break!

```ruby
class SelectQuery
  def eval database
    database[from_table].map{|row| args.filter(row) }
  end
```

Now our in-progress acceptance test is complaining in a new way that tells us what to do next.
```
  1) Error:
test_0002_retrieves one column for all rows when only that column is specified(SQLAwesome):
NoMethodError: undefined method `filter' for Fields:[eng]:SQLAwesome::SemanticModel::Field
```
Let's add the filter method to Field. First the test:
```ruby
  it "should filter out all but it's field" do
    field = Field.new "a"
    original = {"a" => 1,"b" => 2}
    result = field.filter original
    result.must_equal "a" => 1
  end
```

Implementation

```ruby
  def filter row
    {name => row[name]}
  end
```

Bam!
```
$ rake
Run options: --seed 28160

# Running tests:

.............

Finished tests in 0.021960s, 591.9854 tests/s, 683.0601 assertions/s.

13 tests, 15 assertions, 0 failures, 0 errors, 0 skips
```


# Multiple Fields
`SELECT year, name FROM hats`
SelectQuery.new Fields.new(["year", "name"]), From.new("hats")

# Single Element Where clauses
## Numeric Equality
SELECT * FROM one_to_five WHERE dec = 1
SelectQuery.new(WildCard.new,
                From.new("one_to_five"),
                Where.new(
                  NumericEquality.new("dec", 1)))
## String Equality
SELECT * FROM one_to_five WHERE eng = "one"
SelectQuery.new(WildCard.new,
                From.new("one_to_five"),
                Where.new(
                  StringEquality.new("eng", "one")))

Where to go from here:
 * Language Features
   * Compound Where clauses (AND and OR).
   * Functions (COUNT(*))
   * Aliases (SELECT name AS real_name)
   * Joins
   * Indices / Query Planning
 * Tooling
   * Better Error Messages for parsing / missing tables/columns.
   * Syntax highlighting.