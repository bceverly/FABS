![](site/images/FABS-logo.png?raw=true)

Fortran + Apache + BSD + sqlite = Web framework

This is a web framework that leverages Fortran for the middle-tier.  The client
is a standard HTML5/CSS3/Javascript that talks to a REST API that is exposed
by the Fotran middle-tier code via an Apache content filter using CGI.  The
back-end data is stored in sqlite3.  All of this runs on OpenBSD with a goal
to port to FreeBSD at some point in the future.

The sqlite library from flibs is used by this project.  Please see the file
Copyright in the root of the repository for rights information on this library.
