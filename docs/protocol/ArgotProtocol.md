# The Argot Protocol

*The language that can be understood by our jerk*

## Basic Structure

Jerk is designed to build Github Pages, for that, he needs 2 repos, one of which contains the content that will be updated for the pages, the other repo is where the page will be published.

Jerk also needs to know which pages should be updated, you'll need to know the target page path in the repo, the main content (which is a markdown file) for that page, and the scrawling template for the corresponding pages.

## Example

We've provided a example for argot protocol, check the file `argot_protocol.json` file.

## Interesting part

Note that the argot protocol uses ERB actually, so you can even use ruby variables or even expressions. And for your benefits, we provide a built-in variable named `env`. This variable is a ruby hash, and there are two built-in keys, one is `CONTENT-REPO` which point to the downloaded repo folder path on the server, so you can use this to find your markdown files in that repo. The other one is the `GH-PAGES-REPO` which points to the Github Pages repo.

## Jerk needs access

Jerk need access to both of the repos to fetch files and help you update the repo, so you need to give your ssh key that can get access to your git repo to jerk. This sounds crazy, but jerk is a trusted citizen in git world, so go ahead and upload it.