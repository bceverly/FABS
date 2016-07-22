cgi/api.cgi:	libfsqlite.a student_m.o api_errors.o api.f90
	egfortran -o cgi/api.cgi api.f90 student_m.o api_errors.o \
	    -L/usr/lib -lsqlite3 -L. -lfsqlite

api_errors.o:	api_errors.f90
	egfortran -c api_errors.f90

student_m.o:	student_m.f90
	egfortran -c student_m.f90

libfsqlite.a:	csqlite.o fsqlite.o
	ar r libfsqlite.a fsqlite.o csqlite.o

csqlite.o:	csqlite.c
	gcc -c -DLOWERCASE -I/usr/local/include csqlite.c

fsqlite.o:	fsqlite.f90
	egfortran -c fsqlite.f90

.PHONY: clean deploy

clean:
	rm *.o *.mod libfsqlite.a cgi/api.cgi *.db

schema:
	- rm students.db.bak 
	- mv students.db students.db.bak 
	sqlite3 -init schema.sql students.db ""

deploy:
	doas /bin/sh deploy.sh
