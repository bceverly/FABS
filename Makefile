FORTRAN = egfortran
FCFLAGS = -ggdb -c -J${MODDIR}

BINDIR = ./bin
DBDIR  = ./db
LIBDIR = ./libs
OBJDIR = ./objs
MODDIR = ./mods
WEBDIR = /var/www

OBJFILES = ${OBJDIR}/student_m.o \
	${OBJDIR}/api_errors.o ${OBJDIR}/http_response_m.o \
        ${OBJDIR}/http_response_codes.o \
	${OBJDIR}/student_collection_m.o \
	${OBJDIR}/persistent_collection_m.o \
	${OBJDIR}/http_content_types.o \
	${OBJDIR}/xml_payload_m.o ${OBJDIR}/json_payload_m.o \
	${OBJDIR}/student_json_m.o ${OBJDIR}/student_xml_m.o \
	${OBJDIR}/http_request_m.o ${OBJDIR}/url_helper.o \
	${OBJDIR}/string_utils.o ${OBJDIR}/json_parser_m.o

cgi/api.cgi:	${LIBDIR}/libfsqlite.a ${OBJFILES}
	${FORTRAN} -J${MODDIR} -o cgi/api.cgi api.f90 ${OBJFILES} \
	    -L/usr/lib -lsqlite3 -L${LIBDIR} -lfsqlite

${OBJDIR}/api_errors.o:	api_errors.f90 ${OBJDIR}/http_response_m.o
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/api_errors.o api_errors.f90

${OBJDIR}/string_utils.o:	string_utils.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/string_utils.o string_utils.f90

${OBJDIR}/url_helper.o:	url_helper.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/url_helper.o url_helper.f90

${OBJDIR}/student_collection_m.o:	${OBJDIR}/student_m.o \
			${OBJDIR}/persistent_collection_m.o \
			student_collection_m.f90
	$(FORTRAN) $(FCFLAGS) -o ${OBJDIR}/student_collection_m.o \
			student_collection_m.f90

${OBJDIR}/persistent_collection_m.o:	persistent_collection_m.f90
	$(FORTRAN) $(FCFLAGS) -o ${OBJDIR}/persistent_collection_m.o \
			persistent_collection_m.f90

${OBJDIR}/student_m.o:	student_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/student_m.o student_m.f90

${OBJDIR}/http_request_m.o:	${OBJDIR}/url_helper.o \
			${OBJDIR}/string_utils.o http_request_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/http_request_m.o http_request_m.f90

${OBJDIR}/http_response_m.o:	http_response_m.f90 \
			${OBJDIR}/http_response_codes.o \
			${OBJDIR}/persistent_collection_m.o \
			${OBJDIR}/http_content_types.o
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/http_response_m.o http_response_m.f90

${OBJDIR}/xml_payload_m.o:	${OBJDIR}/http_response_m.o xml_payload_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/xml_payload_m.o xml_payload_m.f90

${OBJDIR}/json_payload_m.o:	${OBJDIR}/http_response_m.o json_payload_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/json_payload_m.o json_payload_m.f90

${OBJDIR}/student_json_m.o:	${OBJDIR}/json_payload_m.o \
			${OBJDIR}/student_collection_m.o student_json_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/student_json_m.o student_json_m.f90

${OBJDIR}/student_xml_m.o:	${OBJDIR}/xml_payload_m.o \
			${OBJDIR}/student_collection_m.o student_xml_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/student_xml_m.o student_xml_m.f90

${OBJDIR}/http_response_codes.o:	http_response_codes.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/http_response_codes.o \
			http_response_codes.f90

${OBJDIR}/http_content_types.o:	http_content_types.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/http_content_types.o \
			http_content_types.f90

${OBJDIR}/json_parser_m.o:	json_parser_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/json_parser_m.o json_parser_m.f90

${LIBDIR}/libfsqlite.a:	${OBJDIR}/csqlite.o ${OBJDIR}/fsqlite.o
	ar r ${LIBDIR}/libfsqlite.a ${OBJDIR}/fsqlite.o ${OBJDIR}/csqlite.o

${OBJDIR}/csqlite.o:	csqlite.c
	gcc -c -DLOWERCASE -I/usr/local/include -o ${OBJDIR}/csqlite.o csqlite.c

${OBJDIR}/fsqlite.o:	fsqlite.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/fsqlite.o fsqlite.f90

.PHONY: clean deploy

clean:
	rm ${OBJDIR}/*.o ${MODDIR}/*.mod ${LIBDIR}/libfsqlite.a cgi/api.cgi

schema:
	- rm ${DBDIR}/students.db.bak 
	- mv ${DBDIR}/students.db ${DBDIR}/students.db.bak 
	sqlite3 -init ${DBDIR}/schema.sql ${DBDIR}/students.db ""

deploy:
	doas /bin/sh ${BINDIR}/deploy.sh

debug:
	doas /bin/sh ${BINDIR}/deploy_debug.sh
