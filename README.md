# .layer blog

The objective behind the blog is to make it easy for the community members (and anybody else) to promote their work and share their thoughts and ideas related to the field of data science/machine learning.

## Actual Hugo version

The website is currently using `HUGO_VERSION = 0.42`

## New post tutorial

Here is a quick tutorial explaining the steps to follow in order to contribute to the blog.

First, to assure reproducibility through time, and for all different users, **the repo should (and will) stay independent of any specific code compilations (R, Python, etc)**. For example, in a data analysis, the graphics, values and models should already have been calculated by the user and the results included in a compiled document such as a .md or .html extension.

1. The very first step is to create your post and compile your code in order to have a markdown or a html document. The code compilation should be done as part of another project (repo). If your post does not include any code compilation, you can start directly at step 2.
2. Fork the repository 
3. Create a new branch from `master`. The naming convention is: `post/your-initials_name-of-your-post` (all in *lower case* letter). 
4. Create a new directory for your post using this naming convention: `content/blog/YYYY-mm-dd-name-of-your-post`. 
5. Add your post and and all static files inside that directory. At this point, your post file should be a html or a markdown file. If you do not have any code to compile, you can simply create a new markdown file in that directory and start to write your post. Also, you have to name your post file as: `index.md`.
6. If you wanna add a french version of your post, create a `index.fr.md` file.
7. If you have static files such as images or graphics different for both languages, name them using `image.fr.png` extension. Be sure to have correct paths in your post.
8. The slug will be used to copy your post directory in the `public/` folder. The slug is a parameter included in your YAML header. We decided to use the slug based on a [suggestion](https://bookdown.org/yihui/blogdown/configuration.html#options) from Yihui Xie.
9. If you want to add a cover image for your post, add it to the `static/img/header/` directory and add those 2 parameters in your YAML header:
- `featured: "file.jpg"`
- `featuredpath: "img/headers/"`
10. Build and test the website locally by using commands `hugo` (build) and `hugo server` (create a local server). If you are using RStudio, do not use the `blogdown` functions such as `blogdown::build_site()` or `blogdown::serve_site()`. Use the commands mentionned earlier instead.
11. Make a Pull Request to the `master` branch.
