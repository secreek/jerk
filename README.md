#jerk

*Yet another framework for Github Pages.*

*And, you know what, the jerk may not always be the bad guy.*

## Installation

clone this repo to your computer, and run `bundle install` in `scripts` folder, after that, you are all set!

## Usage

Open up a terminal, and get to the `scripts` folder, run `ruby jerk.rb` with command line arguments listed below

    -m, --markdown       path to your markdown folder
    -t, --template       path to your template folder
    -d, --destation      path to save the rendered html files

*Make sure your destation folder exists!*

After you see jerk backs off, go to your destation folder, and see the result.

## Example

We've wrote a simple example to show you what jerk can do. To play with jerk, go to the `example` folder, make some changes to the `markdown` files, or edit the `template`s, and run jerk with 

`ruby scripts/jerk.rb -m example/markdown -t example/templates -d example/results` 

and checkout what jerk has done for you in `example/results` folder.