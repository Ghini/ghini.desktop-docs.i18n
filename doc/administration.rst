Database Administration
--------------------------

If you are using a real DBMS to hold your botanic data, then you need do
something about database administration. While database administration is
far beyond the scope of this document, users are made aware of it.

SQLite
======

SQLite is not what one would consider a real DBMS: Each SQLite database is
in just one file. Make safety copies and you will be fine. If you don't know
where to look for your database files, consider that, per default, Bauble
puts its data in the ``~/.bauble/`` directory.

On Windows it is somewhere in the ``AppData`` directory, most likely in
``AppData\Roaming\Bauble``. Windows tries to hide the
``AppData`` directory structure from normal users. 

The fastest way to open it is with the file explorer: Type ``%APPDATA%`` and
hit ⏎.

MySQL
=====

Please refer to https://dev.mysql.com/doc/

PostgreSQL
==========

Please refer to https://www.postgresql.org/docs/. A very thorough discussion of
your backup options starts at `chapter_24`_.

.. _chapter_24: http://www.postgresql.org/docs/9.1/static/backup.html

Ghini Configuration
----------------------

Ghini uses a configuration file to store values across invocations. This
file is associated to a user account and every user will have their own
configuration file.

To review the content of the Ghini configuration file, type ``:prefs`` in
the text entry area where you normally type your searches, then hit ⏎.

You normally do not need to tweak the configuration file, but you can do so
with a normal text editor. The Ghini configuration file is in the
default location for SQLite databases.

Reporting Errors
----------------------

Should you notice anything unexpected about Ghini's behaviour, please consider
filing an issue on the Ghini development site.

It can be accessed via the Help menu.
