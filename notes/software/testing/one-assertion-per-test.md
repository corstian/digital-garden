---
title: "One assertion per test"
layout: default
date: 2024-05-12
---

# One assertion per test

The idea that a single test should only contain a single test relates to that of having rapid feedback cycles, as well as having (failing) tests clearly indicate the reason they had failed in the first place. With test driven development there is barely a smaller feedback cycle possible than validating one single assumption at a time.

From a technical perspective there are various ways to achieve this. A fairly well known paradigm is the "arrange-act-assert" way. Here the test is set up, executed, after which the results are compared. While you will see this happening everywhere, the way this happens differs slightly.

Perhaps the easiest and laziest way to achieve this is within the context of a single test:

```csharp
public class RandomTest {
    [Fact]
    public void IsLessOrEqualToOne() {
        var random = new Random();

        var result = random.Next();

        Assert.True(random <= 1);
    }
}
```

While this works well, and only contains a single assertion, it quickly becomes tedious to repeat this same pattern over and over again. More problematic is that with more complex test set ups the important details quickly get lost in the boilerplate.

For this reason I started setting up tests in a different way, where the set up no longer happens in the method itself, but in a base class. The methods in a concrete implementation are then to assert some properties of the operation. The sample above would then look like this:

```csharp
public abstract class RandomTest {
    readonly Random Rng = new Random();

    public class RandomGenerationTest : RandomTest {
        private double _random = Random.Next();

        [Fact]
        public void IsLessOrEqualToOne() => Assert.True(this._random <= 1);
    }
}
```

> This is a method which had already been written about by Phil Haack back in 2012: ["Structuring Unit Tests"](https://haacked.com/archive/2012/01/02/structuring-unit-tests.aspx).

If we were to apply this paradigm to a more complex case the benefits would become increasingly clear. Not only did we generalize the setup, and therefore omitted the tedious work of doing this manually over and over again, but we can now also easily add new assertions about the same operation. Essentially there are multiple layers having different meanings for the tests:

- The abstract base class: this is essentially the set up, and it may contain tests which should be run for all concrete implementations of the test _(this is a brilliant way to do data driven tests)_.
- The concrete implementation of the base class: this represents a specific input that is to be tested.
- Test methods: these assert various assumptions about the test case itself.

When using modern C# tests even become really easy and succint to write by using primary constructors on classes. In a more complex example this could look as follows:

```csharp
public abstract class TaskTest(Task Task, DateTime Now) {
    // Mock a time provider here or something; this is just an example

    public class TaskDeadlineExceeded() : TaskTest(
        new Task { 
            Deadline = DateTime.UtcNow.AddDays(-1),
            Title = "Random Task Title"
        }, 
        DateTime.UtcNow) 
    {
        [Fact]
        public void TaskIsDue()
            => Assert.True(Task.IsDue);
    }
}
```

While gaming the metrics is not the goal here, using this approach it is really easy to write hundreds of tests in a day or two. It's boring work, but in a good way.

When writing tests like this naming becomes increasingly important to be able to quickly navigate your way around the test project.
