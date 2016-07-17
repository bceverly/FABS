cgi/api.cgi:	libfsqlite.a api.f90
	egfortran -o cgi/api.cgi api.f90 -L/usr/lib -lsqlite3 -L. -lfsqlite

libfsqlite.a:	csqlite.o fsqlite.o
	ar r libfsqlite.a fsqlite.o csqlite.o

csqlite.o:	csqlite.c
	gcc -c -DLOWERCASE -I/usr/local/include csqlite.c

fsqlite.o:	fsqlite.f90
	egfortran -c fsqlite.f90

.PHONY: clean deploy

clean:
	rm *.o *.mod libfsqlite.a cgi/api.cgi

deploy:
	doas /bin/sh deploy.sh
