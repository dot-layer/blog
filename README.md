# .layer blog

The objective behind this blog is to make it easy for the community members (and anybody else) to promote their work and share their thoughts and ideas related to the field of data science/machine learning.

## New post tutorial

Here is a quick tutorial that explains some steps to follow in order to contribute to this blog.

First, to be reproducible through the time, and mainly through all different users, this repo should be independent of any specific code compilations (R, Python, etc). For example, in a data analysis, the graphics, values and models should already have been calculated by the user and included in a compiled document such as a .md or .html extension.

1. The very first step is to create your post and compile your code in order to have a markdown or a html document. The code compilation should be done as part of another project (repo). If your post does not include any code compilation, you can start directly at step 2.
2. Create a new branch from `master`. You could use this naming convention: `post/your-initials_name-of-your-post`.
3. Insert your post in the `content/blog/` directory. At this point, your post file should be a html or a markdown file. If you do not have any code to compile, you can simply create a new markdown in that directory and start to write your post.
4. If you have static files likes graphics and externals images, add them into `static/blog/slug-of-your-post/`. [^footnote]

[^footnote]: Test, [Link](https://google.com).

5. If you wanna add a cover image for your post, add it to the `static/img/header/` directory.
6. Build and test the website locally by using `hugo` (build) and `hugo server` (create a local server) commands.
7. Make a Pull Request to the `master` branch.