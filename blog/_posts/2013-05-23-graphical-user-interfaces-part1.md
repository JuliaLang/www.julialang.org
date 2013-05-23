---
layout: post
title:  Building GUIs with Julia, Tk, and Cairo, Part I
author: <a href="http://holylab.wustl.edu">Timothy E. Holy</a>
---


This is the first of two blog posts designed to walk users through the process of creating GUIs in Julia.
Those following Julia development will know that plotting in Julia is still evolving, and one could therefore expect that it might be premature to build GUIs with Julia.
My own recent experience has taught me that this expectation is wrong: compared with building GUIs in Matlab (my only previous GUI-writing experience), Julia already offers a number of quite compelling advantages.
We'll see some of these advantages on display below.

We'll go through the highlights needed to create an image viewer GUI.
Before getting into how to write this GUI, first let's play with it to get a sense for how it works.
It's best if you just try these commands yourself, because it's difficult to capture things like interactivity with static text and pictures.

You'll need the `ImageView` package:

    Pkg.add("ImageView")

It's worth pointing out that this package is expected to evolve over time; however, if things have changed from what's described in this blog, try checking out the "blog" branch directly from the [repository](https://github.com/timholy/ImageView.jl).
I should also point out that this package was developed on the author's Linux system, and it's possible that things may not work as well on other platforms.

First let's try it with a photograph. Load one this way:

    using Images
    using ImageView
    img = imread("my_photo.jpg")

Any typical image format should be fine, it doesn't have to be a jpg.
Now display the image this way:

    display(img, pixelspacing = [1,1])

The basic command to view the image is `display`.
The optional `pixelspacing` input tells `display` that this image has a fixed aspect ratio, and that this needs to be honored when displaying the image. (Alternatively, you could set `img["pixelspacing"] = [1,1]` and then you wouldn't have to tell this to the `display` function.)

You should get a window with your image:

![photo](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/photo1.jpg?raw=true)

OK, nice.
But we can start to have some fun if we resize the window, which causes the image to get bigger or smaller:

![photo](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/photo2.jpg?raw=true)

Note the black perimeter; that's because we've specified the aspect ratio through the `pixelspacing` input, and when the window doesn't have the same aspect ratio as the image you'll have a perimeter either horizontally or vertically.
Try it without specifying `pixelspacing`, and you'll see that the image stretches to fill the window, but it looks distorted:

    display(img)

![photo](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/photo3.jpg?raw=true)

(This won't work if you've already defined `"pixelspacing"` for `img`; if necessary, use `delete!(img, "pixelspacing")` to remove that setting.)

Next, click and drag somewhere inside the image.
You'll see the typical rubberband selection, and once you let go the image display will zoom in on the selected region. 

![photo](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/photo4.jpg?raw=true)
![photo](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/photo5.jpg?raw=true)

Again, the aspect ratio of the display is preserved.
Double-clicking on the image restores the display to full size.

If you have a wheel mouse, zoom in again and scroll the wheel, which should cause the image to pan vertically.
If you scroll while holding down Shift, it pans horizontally; hold down Ctrl and you affect the zoom setting.
Note as you zoom via the mouse, the zoom stays focused around the mouse pointer location, making it easy to zoom in on some small feature simply by pointing your mouse at it and then Ctrl-scrolling.

Long-time users of Matlab may note a number of nice features about this behavior:

- The resizing and panning is much smoother than Matlab's
- Matlab doesn't expose modifier keys in conjunction with the wheel mouse, making it difficult to implement this degree of interactivity
- In Matlab, zooming with the wheel mouse is always centered on the middle of the display, requiring you to alternate between zooming and panning to magnify a particular small region of your image or plot.

These already give a taste of some of the features we can achieve quite easily in Julia.

However, there's more to this GUI than meets the eye.
You can display the image upside-down with

    display(img, pixelspacing = [1,1], flipy=true)

or switch the `x` and `y` axes with

    display(img, pixelspacing = [1,1], xy=["y","x"])

![photo](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/photo6.jpg?raw=true)
![photo](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/photo7.jpg?raw=true)

To experience the full functionality, you'll need a "4D  image," a movie (time sequence) of 3D images.
If you don't happen to have one lying around, you can create one via `include("test/test4d.jl")`, where `test` means the test directory in `ImageView`.
(Assuming you installed `ImageView` via the package manager, you can say `include(joinpath(Pkg.dir(), "ImageView", "test", "test4d.jl"))`.)
This creates a solid cone that changes color over time, again in the variable `img`.
Then, type `display(img)`.
You should see something like this:

![GUI snapshot](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/display_GUI.jpg?raw=true)

The green circle is a "slice" from the cone.
At the bottom of the window you'll see a number of buttons and our current location, `z=1` and `t=1`, which correspond to the base of the cone and the beginning of the movie, respectively.
Click the upward-pointing green arrow, and you'll "pan" through the cone in the `z` dimension, making the circle smaller.
You can go back with the downward-pointing green arrow, or step frame-by-frame with the black arrows.
Next, clicking the "play forward" button moves forward in time, and you'll see the color change through gray to magenta.
The black square is a stop button. You can, of course, type a particular `z`, `t` location into the entry boxes, or grab the sliders and move them.

If you have a wheel mouse, Alt-scroll changes the time, and Ctrl-Alt-scroll changes the z-slice.

You can change the playback speed by right-clicking in an empty space within the navigation bar, which brings up a popup (context) menu:

![GUI snapshot](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/popup.jpg?raw=true)

<br />
<br />

By default, `display` will show you slices in the `xy`-plane.
You might want to see a different set of slices from the 4d image:

    display(img, xy=["x","z"])

Initially you'll see nothing, but that's because this edge of the image is black.
Type 151 into the `y:` entry box (note its name has changed) and hit enter, or move the "y" slider into the middle of its range; now you'll see the cone from the side.

![GUI snapshot](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/display_GUI2.jpg?raw=true)

This GUI is also useful for "plain movies" (2d images with time), in which case the `z` controls will be omitted and it will behave largely as a typical movie-player.
Likewise, the `t` controls will be omitted for 3d images lacking a temporal component, making this a nice viewer for MRI scans.

Again, we note a number of improvements over Matlab:

- When you resize the window, note that the controls keep their initial size, while the image fills the window. With some effort this behavior is possible to achieve in Matlab, but (as you'll see later in these posts) it's essentially trivial with Julia and Tk.
- When we move the sliders, the display updates while we drag it, not just when we let go of the mouse button.
- If you try this with a much larger 3d or 4d image, you may also notice that the display feels snappy and responsive in a way that's sometimes hard to achieve with Matlab.

Altogether advantages such as these combine to give a substantially more polished feel to GUI applications written in Julia.

This completes our tour of the features of this GUI.
Now let's go through a few of the highlights needed to create it.
We'll tackle this in pieces; not only will this make it easier to learn, but it also illustrates how to build re-useable components.
Let's start with the navigation frame.

## First steps: the navigation frame

First, let me acknowledge that this GUI is built on the work of many people who have contributed to Julia's Cairo and Tk packages.
For this step, we'll make particular use of John Verzani's contribution of a huge set of convenience wrappers for most of Tk's widget functionality.
John wrote up a nice set of [examples](https://github.com/JuliaLang/Tk.jl/tree/master/examples) that demonstrate many of the things you can do with it; this first installment is essentially just a "longer" example, and won't surprise anyone who has read his documentation.

Let's create a couple of types to hold the data we'll need.
We need a type that stores "GUI state," which here consists of the currently-viewed location in the image and information needed to implement the "play" functionality:

    type NavigationState
        # Dimensions:
        zmax::Int          # number of frames in z, set to 1 if only 2 spatial dims
        tmax::Int          # number of frames in t, set to 1 if only a single image
        z::Int             # current position in z-stack
        t::Int             # current moment in time
        # Other state data:
        timer              # nothing if not playing, TimeoutAsyncWork if we are
        fps::Float64       # playback speed in frames per second
    end

Next, let's create a type to hold "handles" to all the widgets:

    type NavigationControls
        stepup                            # z buttons...
        stepdown
        playup
        playdown
        stepback                          # t buttons...
        stepfwd
        playback
        playfwd
        stop
        editz                             # edit boxes
        editt
        textz                             # static text (information)
        textt
        scalez                            # scale (slider) widgets
        scalet
    end

It might not be strictly necessary to hold handles to all the widgets (you could do everything with callbacks), but having them available is convenient.
For example, if you don't like the icons I created, you can easily initialize the GUI and replace, using the handles, the icons with something better.

We'll talk about initialization later; for now, assume that we have a variable `state` of type `NavigationState` that holds the current position in the (possibly) 4D image, and `ctrls` which contains a fully-initialized set of widget handles.

Each button needs a callback function to be executed when it is clicked.
Let's go through the functions for controlling `t`.
First there is a general utility not tied to any button, but it affects many of the controls:

    function updatet(ctrls, state)
        set_value(ctrls.editt, string(state.t))
        set_value(ctrls.scalet, state.t)
        enableback = state.t > 1
        set_enabled(ctrls.stepback, enableback)
        set_enabled(ctrls.playback, enableback)
        enablefwd = state.t < state.tmax
        set_enabled(ctrls.stepfwd, enablefwd)
        set_enabled(ctrls.playfwd, enablefwd)
    end

The first two lines synchronize the entry box and slider to the current value of `state.t`;
the currently-selected time can change by many different mechanisms (one of the buttons, typing into the entry box, or moving the slider), so we make `state.t` be the "authoritative" value and synchronize everything to it.
The remaining lines of this function control which of the `t` navigation buttons are enabled (if `t==1`, we can't go any earlier in the movie, so we gray out the backwards buttons).

A second utility function modifies `state.t`:

    function incrementt(inc, ctrls, state, showframe)
        state.t += inc
        updatet(ctrls, state)
        showframe(state)
    end

Note the call to `updatet` described above.
The new part of this is the `showframe` function, whose job it is to display the image frame (or any other visual information) to the user.
Typically, the actual `showframe` function will need additional information such as where to render the image, but you can provide this information using anonymous functions.
We'll see how that works in the next installment; below we'll just create a simple "stub" function.

Now we get to callbacks which we'll "bind" to the step and play buttons:

    function stept(inc, ctrls, state, showframe)
        if 1 <= state.t+inc <= state.tmax
            incrementt(inc, ctrls, state, showframe)
        else
            stop_playing!(state)
        end
    end

    function playt(inc, ctrls, state, showframe)
        if !(state.fps > 0)
            error("Frame rate is not positive")
        end
        stop_playing!(state)
        dt = 1/state.fps
        state.timer = TimeoutAsyncWork(i -> stept(inc, ctrls, state, showframe))
        start_timer(state.timer, iround(1000*dt), iround(1000*dt))
    end

`stept()` increments the `t` frame by the specified amount (typically 1 or -1), while `playt()` starts a timer that will call `stept` at regular intervals.
The timer is stopped if play reaches the beginning or end of the movie.
The `stop_playing!` function checks to see whether we have an active timer, and if so stops it:

    function stop_playing!(state::NavigationState)
        if !is(state.timer, nothing)
            stop_timer(state.timer)
            state.timer = nothing
        end
    end

An alternative way to handle playback without a timer would be in a loop, like this:

    function stept(inc, ctrls, state, showframe)
        if 1 <= state.t+inc <= state.tmax
            incrementt(inc, ctrls, state, showframe)
        end
    end

    function playt(inc, ctrls, state, showframe)
        state.isplaying = true
        while 1 <= state.t+inc <= state.tmax && state.isplaying
            tcl_doevent()    # allow the stop button to take effect
            incrementt(inc, ctrls, state, showframe)
        end
        state.isplaying = false
    end

With this version we would use a single Boolean value to signal whether there is active playback.
A key point here is the call to `tcl_doevent()`, which allows Tk to interrupt the execution of the loop to handle user interaction (in this case, clicking the stop button).
But with the timer that's not necessary, and moreover the timer gives us control over the speed of playback.

Finally, there are callbacks for the entry and slider widgets:

    function sett(ctrls,state, showframe)
        tstr = get_value(ctrls.editt)
        try
            val = int(tstr)
            state.t = val
            updatet(ctrls, state)
            showframe(state)
        catch
            updatet(ctrls, state)
        end
    end

    function scalet(ctrls, state, showframe)
        state.t = get_value(ctrls.scalet)
        updatet(ctrls, state)
        showframe(state)
    end

`sett` runs when the user types an entry into the edit box; if the user types in nonsense like "foo", it will gracefully reset it to the current position.

There's a complementary set of these functions for the `z` controls.

These callbacks implement the functionality of this "navigation" GUI.
The other main task is initialization.
We won't cover this in gory detail (you are invited to browse the code), but let's hit a few highlights.

#### Creating the buttons

You can use image files (e.g., .png files) for your icons, but the ones here are created programmatically.
To do this, specify two colors, the "foreground" and "background", as strings.
One also needs the `data` array (of type `Bool`) for the pixels that should be colored by the foreground color, and false for the ones to be set to the background.
There's also the `mask` array, which can prevent the `data` array from taking effect in any pixels marked as false in the `mask`.

Given suitable `data` and `mask` arrays (here we just set the mask to `trues`), and color strings, we create the icon and assign it to a button like this:

    icon = Tk.image(data, mask, "gray70", "black")  # background=gray70, foreground=black
    ctrls.stop = Button(f, icon)

Here `f` is the "parent frame" that the navigation controller will be rendered in.
A frame is a container that organizes a collection of related GUI elements.
Later we'll find out how to create one.

#### Assigning callbacks to widgets

The "stop" and "play backwards" buttons look like this:

    bind(ctrls.stop, "command", path -> stop_playing!(state))
    bind(ctrls.playback, "command", path -> playt(-1, ctrls, state, showframe)

The `path` input is generated by Tk/Tcl, but we don't have to use it.
Instead, we use anonymous functions to pass the arguments relavant to this particular GUI instantiation.
Note that these two buttons share `state`; that means that any changes made by one callback will have impact on the other.

#### Placing the buttons in the frame (layout management)

Here our layout needs are quite simple, but I recommend that you read the [excellent](http://www.tkdocs.com/tutorial/concepts.html#geometry) [tutorial](http://www.tkdocs.com/tutorial/grid.html) on Tk's `grid` layout engine.
`grid` provides a great deal of functionality missing in Matlab, and in particular allows flexible and polished GUI behavior when resizing the window.

We position the stop button this way:

    grid(ctrls.stop, 1, stopindex, padx=3*pad, pady=pad)

After the handle for the button itself, the next two inputs determine the row, column position of the widget.
Here the column position is set using a variable (an integer) whose value will depend on whether the z controls are present.
 The `pad` settings just apply a bit of horizontal and vertical padding around the button.

To position the slider widgets, we could do something like this:

    ctrls.scalez = Slider(f, 1:state.zmax)
    grid(ctrls.scalez, 2, start:stop, sticky="we", padx=pad)

This positions them in row 2 of the frame's grid, and has them occupy the range of columns (indicated by `start:stop`) used by the button controls for the same `z` or `t` axis.
The `sticky` setting means that it will stretch to fill from West to East (left to right).

In the main GUI we'll use one more feature of `grid`, so let's cover it now.
This feature controls how regions of the window expand or shrink when the window is resized:

    grid_rowconfigure(win, 1, weight=1)
    grid_columnconfigure(win, 1, weight=1)

This says that row 1, column 1 will expand at a rate of `1` when the figure is made larger.
You can set different weights for different GUI components.
The default value is 0, indicating that it shouldn't expand at all.
That's what we want for this navigation frame, so that the buttons keep their size when the window is resized.
Larger weight values indicate that the given component should expand (or shrink) at faster rates.

### Putting it all together and testing it out

We'll place the navigation controls inside a Tk frame.
Let's create one from the command line:

    using Tk
    win = Toplevel()
    f = Frame(win)
    pack(f, expand=true, fill="both")

The first three lines create the window and the frame. `pack` is an alternative layout engine to `grid`, and slightly more convenient when all you want is to place a single item so that it fills its container.
(You can mix `pack` and `grid` as long as they are operating on separate containers.
Here we'll have a frame `pack`ed in the window, and the widgets will be `grid`ded inside the frame.)
After that fourth line, the window is rather tiny; the call to `pack` causes the frame to fill to expand the whole window, but at the moment the frame has no contents, so the window is as small as it can be.

![GUI snapshot](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/navigation1.jpg?raw=true)

We need a `showframe` callback; for now let's create a very simple one that will help in testing:

    showframe = x -> println("showframe z=", x.z, ", t=", x.t)

Next, load the GUI code (`using ImageView.Navigation`) and create the `NavigationState` and `NavigationControls` objects:

    ctrls = NavigationControls()
    state = NavigationState(40, 1000, 2, 5)

Here we've set up a fake movie with 40 image slices in `z`, and 1000 image stacks in `t`.

Finally, we initialize the widgets:

    init_navigation!(f, ctrls, state, showframe)

![GUI snapshot](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/navigation2.jpg?raw=true)

Now when you click on buttons, or change the text in the entry boxes, you'll see the GUI in action.
You can tell from the command line output, generated by `showframe`, what's happening internally:

![GUI snapshot](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/GUI_figures/navigation_repl.jpg?raw=true)

Hopefully this demonstrates another nice feature of developing GUIs in Julia: it's straightforward to build re-usable components.
This navigation frame can be added as an element to any window, and the grid layout manager takes care of the rest.
All you need to do is to include `ImageView/src/navigation.jl` into your module, and you can make use of it with just a few lines of code.

Not too hard, right? The next step is to render the image, which brings us into the domain of Cairo.
