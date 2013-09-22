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

## When would you want to avoid using a DSL

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

3. `[{"dec"=>1,"eng"=>"one"},
    #... 
   ]`

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