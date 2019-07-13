package com.monitorz.webapi;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.util.logging.Level;
import java.util.logging.Logger;

@ControllerAdvice
public class RestResponseEntityExceptionHandler  extends ResponseEntityExceptionHandler {

    static final Logger LOG = Logger.getLogger(RestResponseEntityExceptionHandler.class.getSimpleName());
    @ExceptionHandler(value = java.lang.NullPointerException.class)
    protected ResponseEntity<Object> handleNullPointer(
            RuntimeException ex, WebRequest request) {

        String bodyOfResponse = "\uD83C\uDF4E\uD83C\uDF4E\uD83C\uDF4E ERROR: " + ex.toString() + "; contextPath: " + request.toString() + "\uD83C\uDF4E";
        LOG.log(Level.INFO,"................. \uD83D\uDD06 \uD83D\uDD06 handleNullPointer: Do we get here, \uD83D\uDD06 Senor?? ");
        return handleExceptionInternal(ex, bodyOfResponse,
                new HttpHeaders(), HttpStatus.BAD_REQUEST, request);
    }
//    @ExceptionHandler(value = Exception.class)
//    protected ResponseEntity<Object> handleException(
//            RuntimeException ex, WebRequest request) {
//        LOG.log(Level.INFO,"................. \uD83D\uDD06 \uD83D\uDD06 handleException: Do we get here, \uD83D\uDD06 Senor?? ");
//        String bodyOfResponse = "\uD83C\uDF4E\uD83C\uDF4E\uD83C\uDF4E Some error happened:  \uD83C\uDF4E " + ex.toString() + "\n" + request.toString();
//        return handleExceptionInternal(ex, bodyOfResponse,
//                new HttpHeaders(), HttpStatus.BAD_REQUEST, request);
//    }
}

