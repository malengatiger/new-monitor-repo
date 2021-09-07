package com.monitor.backend.utils;

import com.google.api.core.ApiFuture;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.monitor.backend.services.DataService;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;
import java.util.concurrent.ExecutionException;

@Component
public class MonitorAuthenticationFilter extends OncePerRequestFilter {
    public MonitorAuthenticationFilter() {
        System.out.println("\uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 " +
                "MonitorAuthenticationFilter which extends OncePerRequestFilter: constructor \uD83D\uDE21");
    }

    private static final Logger LOGGER = LoggerFactory.getLogger(MonitorAuthenticationFilter.class);

    @Autowired
    private DataService dataService;

    @Override
    protected void doFilterInternal(@NotNull HttpServletRequest httpServletRequest,
                                    @NotNull HttpServletResponse httpServletResponse,
                                    @NotNull FilterChain filterChain) throws ServletException, IOException {

//        print(httpServletRequest);

        String url = httpServletRequest.getRequestURL().toString();
        if (url.contains("192.168.86.240:8087")) {   //this is my local machine
            LOGGER.info(Emoji.ANGRY + "this request is not subject to authentication: "
                    + Emoji.HAND2 + url);
            doFilter(httpServletRequest, httpServletResponse, filterChain);
            return;
        }
        LOGGER.info(Emoji.ANGRY + Emoji.ANGRY + "this request IS subject to authentication: "
                + Emoji.HAND2 + url);
        String m = httpServletRequest.getHeader("Authorization");
        if (m == null) {
            String msg = "\uD83D\uDC7F \uD83D\uDC7F \uD83D\uDC7F " +
                    "Authorization Header is missing. Needs JWT token! \uD83C\uDF4E "
                    + httpServletRequest.getQueryString() + " \uD83C\uDF4E \uD83C\uDF4E";
            LOGGER.info(msg);
            httpServletResponse.sendError(403, "GTFO");
            return;
//            throw new ServletException("Forbidden!");
        }
        String token = m.substring(7);
        try {
            dataService.initializeFirebase();
            ApiFuture<FirebaseToken> future = FirebaseAuth.getInstance().verifyIdTokenAsync(token, true);
            FirebaseToken mToken = future.get();
            LOGGER.info("\uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 Authentication executed, uid: "
                    + mToken.getUid() + " \uD83D\uDE21 email: " + mToken.getEmail()
                    + "  \uD83C\uDF38" +
                    " \uD83C\uDF4E request authenticated OK!! \uD83C\uDF4E");
            doFilter(httpServletRequest, httpServletResponse, filterChain);

        } catch (Exception e) {
            String msg = "\uD83D\uDD06 \uD83D\uDD06 \uD83D\uDD06 " +
                    "FirebaseAuthException happened: \uD83C\uDF4E " + e.getMessage();
            LOGGER.info("\uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 " + msg);
            httpServletResponse.sendError(403, "GTFO");
//            throw new ServletException("Forbidden!");
        }

    }

    private void doFilter(@NotNull HttpServletRequest httpServletRequest,
                          @NotNull HttpServletResponse httpServletResponse,
                          FilterChain filterChain) throws IOException, ServletException {
        filterChain.doFilter(httpServletRequest, httpServletResponse);
        String url = httpServletRequest.getRequestURL().toString();
        LOGGER.info("\uD83D\uDD37 \uD83D\uDD37 \uD83D\uDD37 Response Status Code: "
                + httpServletResponse.getStatus() + "  \uD83D\uDD37 \uD83D\uDD37 \uD83D\uDD37 " + url + "  \uD83D\uDD37 \uD83D\uDD37 \uD83D\uDD37 ");
    }

    private void print(@NotNull HttpServletRequest httpServletRequest) {
        String url = httpServletRequest.getRequestURL().toString();
        LOGGER.info(Emoji.ANGRY + Emoji.ANGRY + Emoji.ANGRY + Emoji.BELL + "Authenticating this url: " + Emoji.BELL + " " + url);

        System.out.println("\uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 request header parameters ...");
        Enumeration<String> parms = httpServletRequest.getParameterNames();
        while (parms.hasMoreElements()) {
            String m = parms.nextElement();
            LOGGER.info("\uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 parameterName: " + m);

        }
        LOGGER.info("\uD83D\uDE21 \uD83D\uDE21 headers ...");
        Enumeration<String> names = httpServletRequest.getHeaderNames();
        while (names.hasMoreElements()) {
            String m = names.nextElement();
            LOGGER.info("\uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 headerName: " + m);
        }
        LOGGER.info("\uD83D\uDC9A \uD83D\uDC9A \uD83D\uDC9A Authorization: "
                + httpServletRequest.getHeader("Authorization") + " \uD83D\uDC9A \uD83D\uDC9A");
    }

}

