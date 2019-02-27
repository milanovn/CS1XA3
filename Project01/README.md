# Project 1

## Description
Currently, this repository contains two functional scripts for viewing and navigating through files.

## Installation
Download the CS1XA3 repository and execute project_analyze.sh from and command line

## Usage
You will be prompted for the script you want to run through the select menu, enter the **number** corresponding to
the script you want to execute.

### todo.sh
This script will find files with #TODO in them, **if** a corresponding file is found, it will display it. It will
then add print the file-path and each #TODO line. At the end it will ask you which file you would like to edit 
and it will open with nano.

### file_count.sh
This script will display how many [html,jss,css,py,hs and sh] files the directory contains and then prompt the user
on which files they would like to view, the user can select more than one or no files at all.

### deltmp.sh
This script will remove all untracked files ending in .tmp.

### diskspace.sh
This script will display a graph of each directory and its size (in MB) and all the size of all hidden files
beginning in ".", exlcuding current directory (.) and (..)

![Alt Text](https://github.com/milanovn/CS1XA3/blob/project01/Project01/Ex.1.png "Example on how to run todo.sh")
![Alt Text](https://github.com/milanovn/CS1XA3/blob/project01/Project01/Ex.2.png "Example on how to run file_count.sh")
