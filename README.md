[![Netlify Status](https://api.netlify.com/api/v1/badges/350cdda6-b209-4f87-be6a-6a24e417c183/deploy-status)](https://app.netlify.com/sites/inspiring-hawking-028195/deploys)

This is the GitHub repository for the Julia Programming Language's main website, [julialang.org](http://julialang.org/). The repository for the source code of the language itself can be found at [github.com/JuliaLang/julia](https://github.com/JuliaLang/julia).

The Julia website is generated using GitHub pages and Hugo, as [explained here](https://gohugo.io/hosting-and-deployment/hosting-on-github/#github-project-pages).

# Making Simple Changes 

To suggest a change to the website, you can simply naviagte to the page with the content you think should be changed, and edit it. You will be prompted to fork the repo (if you haven't already) and then open a Pull Request. Once the Pull Request is open, Netlify will build a preview of the site with the changes you made. You can click the link there to validate that the changes appear as you would expect. 

Once your Pull Request is merged, you should see your changes show up on the website in a few minutes or less. 

# Making More Complex Changes 

To suggest a change to the website that is more signifcant, it is suggested that you make said changes and test them locally on your device. You can do this by simply forking the base repo, cloning it locally onto your device, making the changes you want, and then following the "Installing locally" instructions below. 

Once you have validated that everything looks good, you can open a Pull Request and check the Deploy Preview from Netlify as a final sanity check. 

# Installing locally

You can either download a single binary file for Hugo from
[Hugo releases](https://github.com/gohugoio/hugo/releases) or you can install
it as per the instructions [here](https://gohugo.io/getting-started/installing/).

To build and serve the website run:

    hugo server

in the root of this repository. You can then visit [http://localhost:1313](http://localhost:1313)
to view the site.
