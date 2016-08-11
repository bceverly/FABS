FORTRAN = egfortran
FCFLAGS = -ggdb -c -J${MODDIR}

BINDIR = ./bin
CGIDIR = ./cgi
DBDIR  = ${WEBDIR}/cgi-data
LIBDIR = ./libs
LOGDIR = /var/log
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
	${OBJDIR}/string_utils.o ${OBJDIR}/json_parser_m.o \
	${OBJDIR}/object_parser_m.o ${OBJDIR}/xml_parser_m.o \
	${OBJDIR}/attribute_value_pair_m.o ${OBJDIR}/session_m.o \
	${OBJDIR}/persistent_object_m.o ${OBJDIR}/log_file_m.o

${CGIDIR}/api.cgi:	${LIBDIR}/libfsqlite.a ${OBJFILES} api.f90
	${FORTRAN} -J${MODDIR} -o ${CGIDIR}/api.cgi api.f90 ${OBJFILES} \
	    -L/usr/lib -lsqlite3 -L${LIBDIR} -lfsqlite

${OBJDIR}/api_errors.o:	api_errors.f90 ${OBJDIR}/http_response_m.o
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/api_errors.o api_errors.f90

${OBJDIR}/log_file_m.o:	log_file_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/log_file_m.o log_file_m.f90

${OBJDIR}/session_m.o:	${OBJDIR}/http_request_m.o ${OBJDIR}/http_response_m.o \
			session_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/session_m.o session_m.f90

${OBJDIR}/string_utils.o:	string_utils.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/string_utils.o string_utils.f90

${OBJDIR}/attribute_value_pair_m.o:	attribute_value_pair_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/attribute_value_pair_m.o \
			attribute_value_pair_m.f90

${OBJDIR}/url_helper.o:	${OBJDIR}/attribute_value_pair_m.o url_helper.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/url_helper.o url_helper.f90

${OBJDIR}/student_collection_m.o:	${OBJDIR}/student_m.o \
			${OBJDIR}/persistent_collection_m.o \
			student_collection_m.f90
	$(FORTRAN) $(FCFLAGS) -o ${OBJDIR}/student_collection_m.o \
			student_collection_m.f90

${OBJDIR}/persistent_collection_m.o:	persistent_collection_m.f90
	$(FORTRAN) $(FCFLAGS) -o ${OBJDIR}/persistent_collection_m.o \
			persistent_collection_m.f90

${OBJDIR}/persistent_object_m.o:	persistent_object_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/persistent_object_m.o \
			persistent_object_m.f90

${OBJDIR}/student_m.o:	${OBJDIR}/persistent_object_m.o student_m.f90
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

${OBJDIR}/object_parser_m.o:	object_parser_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/object_parser_m.o \
			object_parser_m.f90

${OBJDIR}/json_parser_m.o:	${OBJDIR}/object_parser_m.o json_parser_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/json_parser_m.o json_parser_m.f90

${OBJDIR}/xml_parser_m.o:	${OBJDIR}/object_parser_m.o xml_parser_m.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/xml_parser_m.o xml_parser_m.f90

${LIBDIR}/libfsqlite.a:	${OBJDIR}/csqlite.o ${OBJDIR}/fsqlite.o
	ar r ${LIBDIR}/libfsqlite.a ${OBJDIR}/fsqlite.o ${OBJDIR}/csqlite.o

${OBJDIR}/csqlite.o:	csqlite.c
	gcc -c -DLOWERCASE -I/usr/local/include -o ${OBJDIR}/csqlite.o csqlite.c

${OBJDIR}/fsqlite.o:	fsqlite.f90
	${FORTRAN} ${FCFLAGS} -o ${OBJDIR}/fsqlite.o fsqlite.f90

${LOGDIR}/fabs.log:
	doas touch ${LOGDIR}/fabs.log
	doas chown www ${LOGDIR}/fabs.log
	doas chmod 644 ${LOGDIR}/fabs.log

${DBDIR}:
	doas mkdir ${DBDIR}
	doas chown www ${DBDIR}
	doas chmod 755 ${DBDIR}

.PHONY: clean deploy schema

clean:
	rm ${OBJDIR}/*.o ${MODDIR}/*.mod ${LIBDIR}/libfsqlite.a cgi/api.cgi

schema:
	/bin/sh ${BINDIR}/schema.sh

deploy:	${DBDIR} ${LOGDIR}/fabs.log ${CGIDIR}/api.cgi
	doas /bin/sh ${BINDIR}/deploy.sh

debug: ${CGIDIR}/api.cgi
	doas /bin/sh ${BINDIR}/deploy_debug.sh
