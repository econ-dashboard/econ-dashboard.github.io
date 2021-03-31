"""
This is an an example data processing script.

It illustrates a few common workflows when creating
a script:

* Importing re-usable code from the lib package
* Using an environment variable supplied by the .env file
* Writing a json file to our standard data directory
"""
import os
from lib.utils import write_json

# This environment variable is created when
# you activate the virtual environment using "pipenv shell".
# DATA_DIR gets its value from variable of the same name
# in the project's .env file.
DATA_DIR = os.environ['DATA_DIR']


def main():
    # Print out the docstring at top of file
    print(__doc__)
    # Create the path for the JSON that will be output
    outfile = os.path.join(DATA_DIR, 'processed/sample.json')
    # Use the built-in write_json function that we imported from lib.utils
    write_json(outfile, {"foo": 1, "bar": 2})
    print("Wrote data to {}\n".format(outfile))

if __name__ == '__main__':
    main()
