# Demo Robot Framework test suite for API

**Table of contents**
- [Demo Robot Framework test suite for API](#demo-robot-framework-test-suite-for-api)
  - [Description](#description)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Project structure](#project-structure)
  - [Usage](#usage)
  - [Docker](#docker)



This is a Robot Framework test suite for the RESTful API. Its purpose is to show various aspects of the Robot Framework in relation to API testimg and custom application test framework design.

## Description

The demo Robot Framework test suite is designed to test API that provides various operations related to an online store, such as customer management, product catalog, orders, and more. It shows the use of custom libraries, custom test framework, global/suite/test variables in the API test suite.

Currently only customer management test suite is implemented.

## Prerequisites

- Python >= 3.11
- PostgreSQL
- [Demo API for Demo Robot Framework test suite](https://github.com/ZNenatzka/demo-fastapi-for-robotframework-test-suite) up and running

Best served with [Microsoft Visual Studio Code](https://code.visualstudio.com/) with following extensions:

- [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
- [Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)
- [Robot Framework Language Server](https://marketplace.visualstudio.com/items?itemName=robocorp.robotframework-lsp)

## Installation

1. Clone the repository:

    `git clone https://github.com/ZNenatzka/demo-robotframework-test-suite`

2. Navigate to the project directory:

    `cd demo-robotframework-test-suite`

3. Create a virtual environment and activate it:

    `python -m venv .venv`

    On Linux, use

    `source .venv/bin/activate`

    On Windows, use

    `.venv\Scripts\activate`

4. Install the required dependencies:

    `pip install -r requirements.txt`

5. Set up the environment variables for the database connection and API in the `demo-robotframework-test-suite/etc/env/local.py`

## Project structure

Project consists of following folders:

- Folder `etc` is designed to keep project-related configuration files
- Folder `etc/env` contains variable files named by test environments containing environment configuration details, i.e. database connection string, API url, etc.
- Folder `lib` contains custom libraries that provide keywords for the custom test framework
- Folder `log` is designed to keep test execution reports and logs
- Folder `res` contains custom test framework
- Folder `test` is a global test suite

## Usage

1. Navigate to the project directory:

    `cd demo-robotframework-test-suite`

2. Activate a virtual environment

    On Linux, use

    `source .venv/bin/activate`

    On Windows, use

    `.venv\Scripts\activate`

3. Run the test suite

    Using Robot Framework `robot` command

    `robot --name "Demo Test Suite" --pythonpath lib --variable ENV_NAME:local --outputdir log --suite Demo_Test_Suite.API.Customers test`

    or run in parallel using `robotframework-pabot`

    `pabot --processes 5 --name "Demo Test Suite" --pythonpath lib --variable ENV_NAME:local --outputdir log --include customers_api test`

    or use Microsoft Visual Studio Code to run individual test cases or suites from Editor or Testing view

4. Check test execution results in the `log/log.html` and/or `log/report.html`

## Docker

1. Build an image:

    `docker build --tag demo--robot-testsuite .`

2. Run container:

    `docker run -i -t --rm -v /path/to/demo-robotframework-test-suite:/robot demo--robot-testsuite`

3. Check test execution results in the `log/log.html` and/or `log/report.html`
