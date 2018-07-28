I've never been a big user of the command line. One could even say I actively avoided it!
Heck, I haven't even written a program using command line arguments, since it always felt a bit like resurrecting a dinosaur - and we all know how that ends.

This carefully honed ignorance just came in handy when discussing how to improve the learning curve for Julia's shell interface.

Turns out it was designed by people born in the command line, making it confusing to use for someone like me.
Now enlightened of how things work, I want to share my newly acquired knowledge!

Let's start with the basics and my first mental model.
You can run a command like this:
```Julia
julia> run(`julia -e 'println("hello world")'`);
hello world
```

Since this looks exactly like what I would type into the terminal, I inferred that this is the general rule:
Just make it look like a command and it will run like a command!

But this falls apart as soon as we start interpolating into the command.
Let's consider the following:

```Julia
julia> flag1 = "-e 'println(\"hello world\")'";

julia> flag2 = "println(\"hello world\")";

julia> helloworld = "hello world";

julia> `julia $flag1`
`julia "-e 'println(\"hello world\")'"` # okay?! Guess strings get quotes

julia>` julia -e 'println($helloworld)'`
`julia -e 'println($helloworld)'` #what?

julia> `julia -e $flag2`
`julia -e 'println("hello world")'` # WHAT? Where are my "

julia> a = "some   thing";

julia> b = `some   thing`;

julia> run(`echo $a`);
some   thing

julia> run(`echo $b`);
some thing
```
If this all makes sense to you, welcome to the group of enlightened people!
I looked more like this:

![image](https://cloud.githubusercontent.com/assets/1010467/25554703/66a7ee96-2cd4-11e7-816b-496fcef9837e.png)


Obviously this is all well thought out and what was missing is the right mental model.

First of all, keep in mind that there is always a `main` sitting somewhere, patiently waiting for you to feed it an array of strings.
The good ol' `main(int argc,  char** argv)`!

Now, what the shell does is splitting the one command string we type in by spaces in order to pass it to this main.
This then obviously needs a method to create a string with spaces, which is where `'...'` or `"..."` comes into play.
If I understand correctly, all other characters are just conventions.
So the minus in `-e` isn't treated special, as I assumed at some point.
And therefore the `-e` and `'println("hello world")'` only belong together semantically, but not when constructing the array of strings.
So trying to interpolate `'-e'` together with the `'...'` block failed miserably, since Julia tried to interpret it as one string.
What made me fail to see the correct solution was, that Julia can actually do better than the shell,
since we can directly pass an array of strings to the command.
So this actually works:
```Julia
run(Cmd(["julia", "-e", "println(\"hello world\")"]))
```
Note that the above is equivalent to:
```Julia
run(`julia $(["-e", """println("hello world")"""])`)
```
So we can in fact have better interpolation, since we just need to insert a new string into the array.
Which is why this actually works:
`julia -e $("println(\"hello world\"))`
Just leave out any `'...'` and let Julia turn it into a command with correctly escaped strings.

Now, in Julia 0.7 Keno Fischer added a way of printing that makes the array nature of a command much clearer:

![image](https://cloud.githubusercontent.com/assets/1010467/25554611/afa146c2-2cd1-11e7-93ac-cfc851b67133.png)

Together with a few documentation improvements, I think this can fly even for dummies like me :)
