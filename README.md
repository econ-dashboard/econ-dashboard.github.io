# Econ N Metrics

A project for Stanford's COMM 277T course.

## Setup

> Before using this project, please ensure all dependencies are installed. See the [project home page][] for details.

[project home page]: https://github.com/stanfordjournalism/cookiecutter-stanford-progj#requirements--setup

After creating this project:

* `cd bna-econ-n-metrics`
* `pipenv install`

## Save and push your work

This project includes a few command-line tasks that help
with the daily workflow of our course. The tasks were created using [invoke][], a task execution library.

Below are the most import commands:

```
invoke --list
Available tasks:

  code.push   Saves local work and pushes changes to GitHub
  code.save   Saves changes locally (in git)
```

After creating or modifying files in your text editor of choice,
you should use these tasks to save your changes locally and push them to GitHub.

> It's good to get in the habit of running these commands whenever you wrap up a coding session.

```
cd bna-econ-n-metrics

# Activate the virtual environment
pipenv shell

# Save the work and push to GitHub
invoke code.save
invoke code.push
```

## Installing Python libraries

Depending on the type of project you're working on,
you may want to install additional Python packages.
Below are some useful libraries for common tasks
such as interacting with APIs, scraping web pages,
and data analysis:

* APIs and web scraping - [requests][], [BeautifulSoup][], [selenium][]
* data analysis - [jupyter][], [pandas][], [matplotlib][]

The standard workflow is:

```
cd bna-econ-n-metrics
# Install one or libraries, e.g. requests and BeautifulSoup
pipenv install requests beautifulsoup4
```

## Files & Directories

Below is an overview of the project structure:

```   
├── Pipfile
├── Pipfile.lock
├── README.md
├── data
│   ├── processed (Raw data that has been transformed)
│   └── raw  (Copy of original source data)
├── lib (Re-usable Python code in .py files)
│   ├── __init__.py
│   └── utils.py
├── notebooks (Jupyter notebooks)
├── scripts (Number-prefixed data processing scripts)
│   └── 1-etl.py
└── tasks (invoke task definitions)
    ├── __init__.py
    └── code.py
        
```

## Reference

* [Hitchhiker's Guide to Python](https://docs.python-guide.org/)
* [Python Standard Library](https://docs.python.org/3.7/library/index.html). A few especially useful libraries:
  * csv - reading/writing CSV files
  * json - reading/writing JSON
  * os - working with OS, e.g. getting environment variables and walking directory/file trees


[BeautifulSoup]: https://www.crummy.com/software/BeautifulSoup/bs4/doc/
[invoke]: https://www.pyinvoke.org/
[jupyter]: https://jupyter.org/
[matplotlib]: https://matplotlib.org/tutorials/introductory/usage.html#sphx-glr-tutorials-introductory-usage-py
[pandas]: https://pandas.pydata.org/pandas-docs/stable/
[pipenv]: https://pipenv.readthedocs.io/en/latest/
[requests]: https://2.python-requests.org/en/master/
[selenium]: https://selenium-python.readthedocs.io/