---

title: How To Build A Website
linktitle: How To Build A Website
toc: true
date: "2019-08-16"
draft: false
type: post

tags:
 - tutorial
 - website
 - hugo
 - academic

menu: 
  resources:

---

In this tutorial I am going to explain how to build a website on [Github](https://www.github.com) using [Academic](https://sourcethemes.com/academic/) theme from [Hugo](https://gohugo.io/).

## Introduction

There are three main options: use RStudio, the Terminal or Netlify. I personally use a combination of RStudio and Terminal since the former is excellent for editing and testing and it's always useful to know how to use the latter. 

Independently of the method, the first step is to create an account on [Github](https://www.github.com). 

Then, add a new repository (`+` button in the top-right corner) called `namesurname.github.io` using your name and surname. Use the default settings when creating the repository. 

## Option 1: RStudio

First, you need to have R and RStudio installed.

- Download R form [https://www.r-project.org](https://www.r-project.org/)
- Download RStudio from [https://www.rstudio.com](https://www.rstudio.com/)

Then, you need to install all the relevant packages. In RStudio type the following commands

```r
# Install blogdown
install.packages("blogdown")

# Install Hugo
blogdown::install_hugo()
```

### Create website

Open RStudio and select:

- `New Project`
- `New Directory`
- `Website using blogdown`
  - `Directory name`: here input the name of the folder which will contain all the website files. I called mine `Website`.
  - `Create project as a subdirectory of`: select the directory in which you want to install your website (e.g. `user/Dropbox/`).
  - `Theme`: input `gcushen/hugo-academic` instead of the default theme.

To build the website, open the RProject file in your `Website` folder and type:

```r
blogdown::hugo_build()
```

This command will generate a `public/` subfolder in which the actual code of the website is stored.

To preview the website, open the RProject file in your `Website` folder and type:

```r
blogdown::serve_site()
```

Previewing the website is very useful as it allows you to see live changes locally inside RStudio, before publishing them. This is the **main advantage of working in RStudio**.

### Publish website

In order to publish the website, you have to push your changes from the `public/` folder to your `namesurname.github.io` repository on Github.

First, link the `public/` folder to the `namesurname.github.io` repository.

```r
# Remove public directory if it exists
rm -r public/

# Add git submodule
git submodule add -f -b master https://github.com/namesurname/namesurname.github.io.git public
```

To publish it, just push your `public/` subfolder to git

```r
# Enter the public subfolder and push the actual website
cd public
git add .
git commit -m "Update Website"
git push
```

Wait a few seconds (or minutes for heavy changes) and your website should be online.

### Automation

In general, to automate your website publishment, I suggest creating a shell script `update_website.sh` with the following code inside:

```r
# Directory
cd Dropbox/Website

# Update website
echo
hugo

# Publish website
cd public
git add .
git commit -m "Update website"
git push origin master
```

This routine updates your website and pushes it online.

## Basic Customization

The basic files that you want to modify in the `Website` folder are the following

- `config.toml`: website information
 - `baseurl`: insert your domain `namesurname.github.io` here
 - `title`: insert your name and surname `NAME SURNAME`
 - `theme`: by default should be `hugo-academic` but you can create custom themes in the `themes` folder
- `config/_default/params.toml`: website customization 
- `content/authors/admin/_index.md`: personal information

In order to modify the widgets on your homepage, go to `content/home/` and modify the files inside. If you want to remove a section, just delete the corresponding file.

If you need to add other pages, just create a folder inside `content/` and insert a `_index.md` file inside. If you want to create subfolders, just remember that each one should have its own `_index.md` inside.

## Advanced Customization

For the technical inclined.

You can take inspiration from my personal repository: https://github.com/matteocourthoud/website.

## Site Management

Google offers many tools to monitor and manage your website. I personally recommend two of them.

### Google Analytics

The mobile application of Google Analytics is particular intuitive and allows you to monitor your website traffic in detail.

### Google Search Console

You can access the page here: https://search.google.com/search-console.

This tool allows you to check whether your page is online and to receive useful SEO suggestions by Google.

In order for the website to be tracked, you need to request a Google Analytics identifyier and insert it into the `googleAnalytics` section of the `config.toml` file.

Recommended actions: 

- First, inspect your URL `https://namesurname.github.io` using the URL Inspection tool.
- Use **Request indexing** to request Google to index your website so that it will apprear in Google searches.
- Under **Sitemap** provide the link to your website sitemap to Google. It should be `https://namesurname.github.io/sitemap.xml`.

Another good free tool to analyze the "quality" of your website is [SEO Mechanic](https://www.seomechanic.com/seo-analyzer/).

## References

Here are some references:

 - Official Academic website: https://sourcethemes.com/academic/docs/install/
 - Official Bookdown website: https://bookdown.org/yihui/blogdown/installation.html
 - Guide for the Terminal: https://github.com/fliptanedo/FlipWebsite2017


