package com.monitor.backend.utils;

import com.google.api.core.ApiFuture;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

    @Override
    protected void doFilterInternal(@NotNull HttpServletRequest httpServletRequest,
                                    @NotNull HttpServletResponse httpServletResponse,
                                    @NotNull FilterChain filterChain) throws ServletException, IOException {

        String url = httpServletRequest.getRequestURL().toString();
        LOGGER.info(Emoji.BELL + "Authenticating this url: " + Emoji.BELL + " " + url);

        if (url.contains("getNetworkNodes") || url.contains("generate")) {
            LOGGER.info(Emoji.ANGRY + "this request is not subject to authentication: "
                    + Emoji.HAND2 + url);
            doFilter(httpServletRequest, httpServletResponse, filterChain);
            return;
        }
        String m = httpServletRequest.getHeader("Authorization");
        if (m == null) {
            String msg = "\uD83D\uDD06 \uD83D\uDD06 \uD83D\uDD06 " +
                    "Authorization Header is missing. Needs JWT token! \uD83C\uDF4E "
                    + httpServletRequest.getContextPath() + " \uD83C\uDF4E \uD83C\uDF4E";
            LOGGER.info(msg);
            throw new ServletException(msg);
        }
        String token = m.substring(7);
        try {
            ApiFuture<FirebaseToken> future = FirebaseAuth.getInstance().verifyIdTokenAsync(token, true);
            FirebaseToken mToken = future.get();
            LOGGER.info("\uD83D\uDE21 Authentication for request executed, uid: "
                    + mToken.getUid() + " \uD83D\uDE21 email: " + mToken.getEmail()
                    + "  \uD83C\uDF38 isEmailVerified: " + mToken.isEmailVerified() + "  \uD83C\uDF38" +
                    " - going on to do the filter - \uD83C\uDF4E request has been authenticated OK \uD83C\uDF4E");
            doFilter(httpServletRequest, httpServletResponse, filterChain);

        } catch (InterruptedException | ExecutionException e) {
            String msg = "\uD83D\uDD06 \uD83D\uDD06 \uD83D\uDD06 " +
                    "FirebaseAuthException happened: \uD83C\uDF4E " + e.getMessage();
            System.out.println(msg);
            throw new ServletException(msg);
        }

    }

    private void doFilter(@NotNull HttpServletRequest httpServletRequest,
                          @NotNull HttpServletResponse httpServletResponse,
                          FilterChain filterChain) throws IOException, ServletException {
        filterChain.doFilter(httpServletRequest, httpServletResponse);
        LOGGER.info("\uD83D\uDD37 \uD83D\uDD37 \uD83D\uDD37 Response Status Code is: "
                + httpServletResponse.getStatus() + "  \uD83D\uDD37  \uD83D\uDD37");
    }

    private void print(@NotNull HttpServletRequest httpServletRequest) {
        System.out.println("\uD83D\uDE21 \uD83D\uDE21 parameters ...");
        Enumeration<String> parms = httpServletRequest.getParameterNames();
        while (parms.hasMoreElements()) {
            String m = parms.nextElement();
            LOGGER.info("\uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 parameterName: " + m);

        }
        System.out.println("\uD83D\uDE21 \uD83D\uDE21 headers ...");
        Enumeration<String> names = httpServletRequest.getHeaderNames();
        while (names.hasMoreElements()) {
            String m = names.nextElement();
            LOGGER.info("\uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 headerName: " + m);
        }
        System.out.println("\uD83D\uDC9A\uD83D\uDC9A\uD83D\uDC9A Header: Authorization: "
                + httpServletRequest.getHeader("Authorization") + " \uD83D\uDC9A");
    }

}

