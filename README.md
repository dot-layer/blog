# .layer blog

The objective behind this blog is to make it easy for the community members (and anybody else) to promote their work and share their thoughts and ideas related to the field of data science/machine learning.

## New post tutorial

Here is a quick tutorial that explains few steps to follow in order to contribute to this blog.

First, to maximize reproducibility through the time, and for all different users, **the repo should (and will) stay independent of any specific code compilations (R, Python, etc)**. For example, in a data analysis, the graphics, values and models should already have been calculated by the user and the results included in a compiled document such as a .md or .html extension.

1. The very first step is to create your post and compile your code in order to have a markdown or a html document. The code compilation should be done as part of another project (repo). If your post does not include any code compilation, you can start directly at step 2.
2. Fork the repository 
3. Create a new branch from `master`. The naming convention is: `post/your-initials_name-of-your-post` (all in *lower case* letter). 
4. Insert your post in the `content/blog/` directory. At this point, your post file should be a html or a markdown file. If you do not have any code to compile, you can simply create a new markdown file in that directory and start to write your post.
5. If you have static files like graphics or externals images, add them in `static/blog/slug-of-your-post/`. The slug is a parameter included in your YAML header. We decided to use the slug based on a [suggestion](https://bookdown.org/yihui/blogdown/configuration.html#options) from Yihui Xie.
6. If you want to add a cover image for your post, add it to the `static/img/header/` directory and add those 2 parameters in your YAML header:
- `featured: "file.jpg"`
- `featuredpath: "img/headers/"`
7. Build and test the website locally by using commands `hugo` (build) and `hugo server` (create a local server) or by using the `blogdown` command for RStudio users `blogdown::build_site()`.
8. Make a Pull Request to the `master` branch.
