---
title: "Modifying Javascript ASTs using JINT and Esprima"
slug: "modifying-js-asts-using-jint-and-esprima"
date: 2024-05-13
toc: false
---

[JINT](https://github.com/sebastienros/jint) is an ES6 compliant Javascript Interpreter for .NET. Through JINT it becomes nearly trivial to run JS code in a .NET environment without the use of any external dependencies.

While JINT is responsible for the interpretation of Javascript code, the tokenization and parsing are done by another library called [Esprima](https://github.com/sebastienros/esprima-dotnet). With Esprima being a .NET port of [the JS tokenizer called Esprima as well](https://esprima.org/).

With Esprima being the tokenizer, it is also responsible for the construction of the Abstract Syntax Trees, or ASTs for short. By modifying these syntax trees we're able to change the execution of the code, alter the javascript itself, or both.

## AST Rewriters
Esprima provides a construct helping us to modify these syntax trees being the `AstRewriter` class. An provisional example rewriting array property access (`obj["field"]`) to dot access (`obj.field`) could look like this:

```csharp
public class BracketToDotNotationRewriter : AstRewriter
{
    public override T VisitAndConvert<T>(
        T node, 
        bool allowNull = false, 
        string? callerName = null)
    {
        if (node is ComputedMemberExpression cme
            && cme.Property is Literal l 
            && new Regex("^[a-zA-Z_][a-zA-Z0-9_]*$").IsMatch(
                l.Raw.Replace("'", "")
                     .Replace("\"", "")))
        {
            return base.VisitAndConvert(
                new StaticMemberExpression(
                    cme.Object, 
                    new Identifier(l.Raw.Replace("'", "").Replace("\"", "")), 
                    cme.Optional) as T,
                allowNull,
                callerName);
        }
        
        return base.VisitAndConvert(node, allowNull, callerName);
    }
}
```

Noteworthy is that each token contained in the javascript input is represented by its own object. Taking `obj["field"]` as example results in the following syntax tree:

```json
{
  "type": "Program",
  "body": [
    {
      "type": "ExpressionStatement",
      "expression": {
        "type": "MemberExpression",
        "computed": true,
        "object": {
          "type": "Identifier",
          "name": "obj"
        },
        "property": {
          "type": "Literal",
          "value": "field",
          "raw": "\"field\""
        }
      }
    }
  ],
  "sourceType": "script"
}
```

The syntax tree of the dot notation (`obj.field`) differs in two ways, being that the `MemberExpression` is no longer computed, and that the property is of the type `Identifier` rather than literal.

> To play around with these syntax trees, and as a handy help during the development of rewriters, [check out the Esprima parser demo here](https://esprima.org/demo/parse.html).

## Test Driven Development and syntax rewriters
The `AstRewriter` class does not really facilitate the implementation of broad sweeping syntax modifications. Instead it's more like a chefs' knife useful for rather subtle cuts and slices to the provided javascript code. Nonetheless, merely the composition of multiple smaller and less complex components allows one to achieve really complex and expansive syntax tree modifications.

To be able to do this in a reliable manner it is important for each small operation to be well defined and predictable. Important for this is to keep the rewriters really small (being not much more complex than the one showcased above). Additionally, the development of unit tests allow one to reliably construct these more complex compositions knowing that the individual components work correctly. All in all it is about setting up a feedback cycle validating any and all assumptions held about the code we're working with.

To do the testing I have set up this smallish base-class:

```csharp
public abstract class RewriterTest<T>
    where T : AstRewriter
{
    public readonly string Code;
    public readonly T Rewriter;
    public readonly Prepared<Script> OriginalScript;
    public readonly Script RewrittenScript;
    public readonly string RewrittenCode;

    protected RewriterTest(T rewriter, string code, bool strict = true)
    {
        Rewriter = rewriter;
        OriginalScript = Engine.PrepareScript(code);
        
        // Doing this to standardize code between input and output
        Code = OriginalScript.Program.ToJavaScriptString();
        Rewriter.VisitAndConvert(in OriginalScript.Program.Body, out var nodeList);
        RewrittenScript = new Script(in nodeList, strict);
        RewrittenCode = RewrittenScript.ToJavaScriptString();
    }
}
```

Note that this test base already shows how to achieve the following three things:
- How to get the AST from an aribtrary piece of JS code
- How to run the rewriter on this syntax tree
- How to output Javascript from the modified AST

This base class provides all the boiler plate we need when writing further tests asserting the correct functioning of rewriters we'll be developing. A concrete test for the sample above looks like this (using [XUnit](https://xunit.net/) and [FluentAssertions](https://fluentassertions.com/)):

```csharp
public abstract class BracketToDotNotationTest(string code)
    : RewriterTest<BracketToDotNotationRewriter>(
        new BracketToDotNotationRewriter(), 
        code)
{
    public class RewriteArrayAccess() : BracketToDotNotationTest("obj['field']")
    {
        [Fact]
        public void Succeeds()
            => RewrittenCode.Should().Be("obj.field");
    }

    public class IndexArrayAccessIsNotRewritten() : BracketToDotNotationTest("obj[1]")
    {
        [Fact]
        public void Succeeds()
            => RewrittenCode.Should().Be(Code);
    }

    public class ArrayAccessWithDashIsNotRewritten() : BracketToDotNotationTest("obj['some-field']")
    {
        [Fact]
        public void Succeeds()
            => RewrittenCode.Should().Be(Code);
    }
}
```

The interesting thing about the `AstRewriter` class is how it forces you to make really small changes to the code you're working on. Syntax trees are complex beasts which - as long as you want to output spec compliant Javascript - require you to work in really small steps and iterations, for it is way too easy to get tangled in these webs.

## Side notes
This work had been part of a significantly more complex test-driven reverse engineering effort. Working with the syntax tree of a dynamically typed language in a statically typed language proved to be an interesting and worthwhile choice significantly impacting the quality and the speed with which we could build (and reuse) the required AST transformations.

I'm open to related cybersecurity related work. [Message me.](mailto:corstian@whaally.com)