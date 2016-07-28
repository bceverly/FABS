FORTRAN = egfortran
FCFLAGS = -c

cgi/api.cgi:	libfsqlite.a student_m.o api_errors.o http_response_m.o \
	        http_response_codes.o student_collection_m.o \
		persistent_collection_m.o http_content_types.o api.f90 \
		xml_payload_m.o json_payload_m.o student_json_m.o \
		student_xml_m.o http_request_m.o url_helper.o string_utils.o
	${FORTRAN} -o cgi/api.cgi api.f90 student_m.o api_errors.o \
	    student_collection_m.o http_response_codes.o http_content_types.o \
	    persistent_collection_m.o json_payload_m.o xml_payload_m.o \
	    http_response_m.o student_json_m.o student_xml_m.o \
	    http_request_m.o url_helper.o string_utils.o \
	    -L/usr/lib -lsqlite3 -L. -lfsqlite

api_errors.o:	api_errors.f90 http_response_m.o
	${FORTRAN} ${FCFLAGS} api_errors.f90

string_utils.o:	string_utils.f90
	${FORTRAN} ${FCFLAGS} string_utils.f90

url_helper.o:	url_helper.f90
	${FORTRAN} ${FCFLAGS} url_helper.f90

student_collection_m.o:	student_m.o persistent_collection_m.o \
			student_collection_m.f90
	$(FORTRAN) $(FCFLAGS) student_collection_m.f90

persistent_collection_m.o:	persistent_collection_m.f90
	$(FORTRAN) $(FCFLAGS) persistent_collection_m.f90

student_m.o:	student_m.f90
	${FORTRAN} ${FCFLAGS} student_m.f90

http_request_m.o:	http_request_m.f90
	${FORTRAN} ${FCFLAGS} http_request_m.f90

http_response_m.o:	http_response_m.f90 http_response_codes.o \
			persistent_collection_m.o http_content_types.o
	${FORTRAN} ${FCFLAGS} http_response_m.f90

xml_payload_m.o:	http_response_m.o xml_payload_m.f90
	${FORTRAN} ${FCFLAGS} xml_payload_m.f90

json_payload_m.o:	http_response_m.o json_payload_m.f90
	${FORTRAN} ${FCFLAGS} json_payload_m.f90

student_json_m.o:	json_payload_m.o student_collection_m.o \
    student_json_m.f90
	${FORTRAN} ${FCFLAGS} student_json_m.f90

student_xml_m.o:	xml_payload_m.o student_collection_m.o \
    student_xml_m.f90
	${FORTRAN} ${FCFLAGS} student_xml_m.f90

http_response_codes.o:	http_response_codes.f90
	${FORTRAN} ${FCFLAGS} http_response_codes.f90

http_content_types.o:	http_content_types.f90
	${FORTRAN} ${FCFLAGS} http_content_types.f90

libfsqlite.a:	csqlite.o fsqlite.o
	ar r libfsqlite.a fsqlite.o csqlite.o

csqlite.o:	csqlite.c
	gcc -c -DLOWERCASE -I/usr/local/include csqlite.c

fsqlite.o:	fsqlite.f90
	${FORTRAN} ${FCFLAGS} fsqlite.f90

.PHONY: clean deploy

clean:
	rm *.o *.mod libfsqlite.a cgi/api.cgi

schema:
	- rm students.db.bak 
	- mv students.db students.db.bak 
	sqlite3 -init schema.sql students.db ""

deploy:
	doas /bin/sh deploy.sh
