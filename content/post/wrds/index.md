---

title: How to access WRDS in Python
linktitle: How to access WRDS in Python
toc: true
date: "2021-01-01"
draft: false
type: post

tags:
 - tutorial
 - economics
 - programming
 - python
 - wrds

---



In this page, I explain how to work with the WRDS database using Python. 



## Setup

The first thing we need to do, is to set up a connection to the [WRDS database](https://wrds-www.wharton.upenn.edu/). I am assuming you have credentials to log in. Check the [log in page](https://wrds-www.wharton.upenn.edu/login/) to make sure.

The second requirement is the [wrds](https://pypi.org/project/wrds/) Python package. 

```shell
pip3 install wrds
```

Now, in order to connect to the WRDS database, you just need to run the following commang in Python.

```python
import wrds
db = wrds.Connection() 
```

Then, you will be propted to input your WRDS username and password. 

However, if you are using a Python IDE such as [PyCharm](https://www.jetbrains.com/pycharm/), you cannot run the command from the Python Console. Moreover, you might want to save your credentials once and for all, so that you don't have to log in every time.

First, walk to your home directory from the Terminal (`/Users/username`).

```shell
cd
```

Now create an empty `.pgpass` file.

```shell
touch .pgpass
```

Now you write `your_username` and `your_password` into the `.pgpass` file.

```shell
echo "wrds-pgdata.wharton.upenn.edu:9737:wrds:your_username:your_password" >> .pgpass
```

You also need to restrict permissions to the file.

```shell
chmod 600 ~/.pgpass
```

Now you can go back to your Python IDE and access the database by just inputing your username.

```python
import wrds
db = wrds.Connection(wrds_username='your_username')
```



## Query





## Resources

- [Setting up WRDS connection](https://wrds-www.wharton.upenn.edu/documents/1443/wrds_connection.html)
- [Intro to WRDS Python Package](https://sites.duke.edu/kevinstandridge/2020/03/07/introduction-to-the-wrds-python-package/)
- [WRDS Data Access Via Python API](https://wizardkingz.github.io/wrdsdataaccesspython-tutorial/)

