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

There are three main options: use RStudio, the Terminal or Netlify. I personally use a combination of RStudio and Terminal since the former is excellent for editing and testing and it's always useful to know how to use the latter. The original guide can be found [here](https://sourcethemes.com/academic/docs/install/).

Independently of the method, the first step is to create an account on [Github](https://www.github.com). 

Then, add a new repository (`+` button in the top-right corner) called `namesurname.github.io` using your name and surname. Use the default settings when creating the repository. 

## Create Website

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

### Setup folder

Open RStudio and select:

- `New Project`
- `New Directory`
- `Website using blogdown`
  - `Directory name`: here input the name of the folder which will contain all the website files. I called mine `Website`.
  - `Create project as a subdirectory of`: select the directory in which you want to install your website (e.g. `user/Dropbox/`).
  - `Theme`: input `gcushen/hugo-academic` instead of the default theme.
  
Alternatively, you can simply go to the [Hugo Academic Github page](https://github.com/gcushen/hugo-academic) and download the content of the page. Copy-paste it into the `Website` folder and you are ready to go.

### Build website

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

The basic files that you want to modify in the `Website` folder are the following:

- `config/_default/config.toml`: general website information
- `config/_default/params.toml`: website customization 
- `config/_default/menus.toml`: top bar / menu customization 
- `content/authors/admin/_index.md`: personal information

For what concerns images, there are three main things you might wanto to modify:
- Profile picture: insert an `avatar.jpg` picture inside the `content/authors/admin/` folder
- Website icon: insert a 512x512 `img.png` picture inside the `static/img/` folder 
- Link preview: insert an `icon.png` picture inside the `assets/images/` file select `sharing_image = "icon.png"`

In order to modify the widgets on your homepage, go to `content/home/` and modify the files inside. If you want to remove a section, just open the corresponding file and select `active=false`.

You can generate three different types of content, each one corresponding to a subfolder in the `content/` folder:
- `post`: blog posts
- `publication`: academic publications
- `talk`: academic talks

I recomment to explore the sample website and proceed by trial and error.

## Advanced Customization

I personally advise against advanced customization but here are a few things one can edit. First, you have to go inside the `theme/academic/` folder. Depending on the installation procedure, the subfolder name might differ.
- `data\themes\` folder. Here you can find the original themes. Select the one you want to modify and copy it in `data\themes` in the main folder. For each theme, you can modify its colors as you prefer. A useful page to select the colors is [HTML Colors](https://htmlcolorcodes.com/). 
- `data\fonts\` folder. Here you can find the original themes. Select the one you want to modify and copy it in `data\fonts` in the main folder. A useful page to select fonts is [Google Fonts](https://fonts.google.com/). 
- `layout\partials\` folder. Here you can modify the structure of the different pages. Say for example that you want to modify the "powered by Academic theme for Hugo" footer in the front page. Open `site_footer.html` and you can modify (or remove) it. 

You can take inspiration from my personal repository: https://github.com/matteocourthoud/website.

## Site Management

Google offers many tools to monitor and manage your website. I personally recommend two of them.

### Google Search Console

You can access the page here: https://search.google.com/search-console.

This tool allows you to check whether your page is online and to receive useful SEO suggestions by Google.

In order for the website to be tracked, you need to request a Google Analytics identifyier and insert it into the `googleAnalytics` section of the `config.toml` file.

Recommended actions: 

- First, inspect your URL `https://namesurname.github.io` using the URL Inspection tool.
- Use **Request indexing** to request Google to index your website so that it will apprear in Google searches.
- Under **Sitemap** provide the link to your website sitemap to Google. It should be `https://namesurname.github.io/sitemap.xml`.

Another good free tool to analyze the "quality" of your website is [SEO Mechanic](https://www.seomechanic.com/seo-analyzer/).

### Google Analytics

The mobile application of [Google Analytics](https://analytics.google.com/analytics/web/) is particular intuitive and allows you to monitor your website traffic in detail. You just need to link the website from the [Google Sesarch Console](https://search.google.com/search-console) and then you can motitor you website from this platform. There is also a very nice mobile app to monitor your website from your smartphone.

## References

Here are some references:

 - Official Academic website: https://sourcethemes.com/academic/docs/install/
 - Official Bookdown website: https://bookdown.org/yihui/blogdown/installation.html
 - Guide for the Terminal: https://github.com/fliptanedo/FlipWebsite2017


