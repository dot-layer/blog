---
title: How to submit a blog post
author: Samuel Perreault and David Beauchemin
date: '2020-04-21'
slug: howto-en
type: post
categories: ['Contribute']
tags: []
description: 'A template to contribute to the blog .Layer'
featured: 'howto-cover.png'
featuredpath: 'img/headers/'
reading_time: ''
aliases: [/blog/2020-03-19-howto/howto-en/]
---

Contributing to the blog has never been easier. First of all, it must be said that any submission, whatever its format (Markdown, Microsoft Word, Notepad, _name it_!), will be considered, and ultimately transcribed into Markdown by our team. We offer the option to submit an article [here](https://dotlayer.org/en/contribute), and we are already thinking of a way to review non-Markdown documents (possibly Google Docs). This being written, for those who would like to write and submit a post in the _conventional_ way, here is a simple procedure to get there.

1. **Blog post creation**
   1. Save the `.md` file used to create this post (available [here](https://github.com/dot-layer/blog/blob/master/content/blog/2020-03-19-howto/index.en.md)) under the name `index.en.md` (for posts in English) or` index.fr.md` (for posts in French).
   2. Insert your post and modify the header's essential fields as well as the content (duh). You must save your images in the same folder as the .md file (or in a sub-directory); except for the cover image, its location is specified with the `featured:" "` field.
2. **Submission of the blog post**
   1. `git fork https://github.com/dot-layer/blog` directory, i.e. _fork_ the [blog directory](https://github.com/dot-layer/blog).
   2. `git checkout -b post/your-initials_post-name`, i.e. create a new branch for your post.
   3. Create a new directory `content/ blog/YYYY-mm-dd-post-name` and insert your post (.md or .html) as well as the static files (e.g. images) necessary for its compilation.
   4. Make a _Pull Request_ to the branch _master_ on the [blog github](https://github.com/dot-layer/blog/pulls).

Let's take a closer look at each of the steps. But first, a few comments of interest.

## License and reproducibility

All blog posts are subject to the license [CC-BY](https://creativecommons.org/licenses/by/4.0/deed). Also, if you want to publish an article already published on another platform on the .Layer blog, please mention it in the post (at the end), as well as in the _Pull Request_. Finally, keep in mind that the main objective of the blog is education and knowledge sharing.

For reproducibility over time and for all, **the repository must remain independent of any code compilation (R, Python, Julia, etc.)**.
For example, if you use RMarkdown (.Rmd), which allows you to integrate R code in a Markdown file, you will have to compile everything and copy only .md or .html in the blog repository (at step 2.3).

# 1. Blog post creation

**Step 1.1.** Save, under the name `index.en.md` /` index.fr.md` (English / French), the .md file [source](https://github.com/dot-layer/blog/blob/master/content/blog/2020-03-19-howto/index.en.md) used to create this blog post. This step is simply to save you from copying the header (in [YAML] format(https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)), which contains some essential fields to fill in.

**Step 1.2.** The YAML header for this post is as follows.

```
---
title: How to submit a blog post
author: Samuel Perreault and David Beauchemin
date: '2020-04-21'
slug: howto-en
type: post
categories: ["Contribute"]
tags: []
description: "A template to contribute to the blog .Layer"
featured: "howto-cover.png"
featuredpath: "img/headers/"
reading_time: ""
---
```

The fields are almost all _self-explanatory_.
The `date` field should contain the creation date of the file. We will change it for the publication date in due time (in the _Pull Request_).
We will also take care of the `categories` and` tags` fields.
The `slug` field is a _nickname_ for your post, which will be used to name the various files linked to the post in the blog directory.
The `featured` field should contain the name of the cover image file, while` featuredpath` (which should remain unchanged) indicates where to find the file. This is where you should place your cover image.
Finally, if the post submitted is already published on another platform, please add the `canonical` field to specify the platform. For example, in the header of the post _What's wrong with Scikit-Learn_ published on the blog, we find

```
canonical: https://www.neuraxio.com/en/blog/scikit-learn/2020/01/03/what-is-wrong-with-scikit-learn.html
```

in addition to the mention at the end of the post, which refers to the original publication.

As for writing the post, you have to know the basics of Markdown.
In addition to the content already in the _template_ that constitutes this post, we recommend this little [*cheatsheet*] (https://github.com/adam-p/markdown-here/wiki/Markdown-Here-Cheatsheet) to use Markdown.

# 2. Submission of a blog post

**Steps 2.1. and 2.2.** These are classic operations of [Git](https://git-scm.com/). If you are not comfortable with Git, let us know and we will make it up! Otherwise, Atlassian offers great free online [training](https://www.atlassian.com/fr/git).

**Steps 2.3.** Create a new directory/folder `content/blog/YYYY-mm-dd-post-name` (in your new repository created in the previous step) and insert your post and the static files (e.g. images) necessary for its compilation. As mentioned earlier in the post, we ask to stick to the .md (or .html), it is no longer a question of compiling R code, Python, Julia, etc. when the post is included in the blog repository.

**Step 2.4.** Make a _Pull Request_ to the _master_ branch on the [blog github](https://github.com/dot-layer/blog). Another classic Git operation. From there, contributors who manage the blog will review the post, make constructive recommendations, and ensure that the rendering is _clean_.

So there ... No more complicated than that. We hope this will help you.
