package com.monitor.backend.utils;

import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import org.jetbrains.annotations.NotNull;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.TimeUnit;
//@Component
public class RateLimitInterceptor implements HandlerInterceptor {
    private static final Logger LOGGER = LoggerFactory.getLogger(RateLimitInterceptor.class.getSimpleName());

    private final Bucket bucket;

    private final int numTokens;
    private static final String mm = Emoji.BLUE_DOT + Emoji.BLUE_DOT + Emoji.BLUE_DOT + Emoji.BLUE_DOT;

    public RateLimitInterceptor(Bucket bucket, int numTokens) {
        this.bucket = bucket;
        this.numTokens = numTokens;
        LOGGER.info(mm + "RateLimitInterceptor construction, tokens: " + numTokens + " bucket tokens: " + bucket.getAvailableTokens());
    }

    @Override
    public boolean preHandle(@NotNull HttpServletRequest request, @NotNull HttpServletResponse response,
                             @NotNull Object handler) {

//        String url = request.getRequestURL().toString();
//        LOGGER.info(mm + " ... RateLimitInterceptor:preHandle: " + url
//        +  " - date: " + new DateTime().toDateTimeISO().toString());

        ConsumptionProbe probe = this.bucket.tryConsumeAndReturnRemaining(this.numTokens);
        if (probe.isConsumed()) {
            LOGGER.info(mm + Emoji.OK + Emoji.OK + " RateLimitInterceptor: RemainingTokens: "
                    + probe.getRemainingTokens() + " " + Emoji.YELLOW_BIRD + " Milliseconds to wait: "
                    + TimeUnit.NANOSECONDS.toMillis(probe.getNanosToWaitForRefill()) + Emoji.YELLOW_BIRD );
            response.addHeader("X-Rate-Limit-Remaining",
                    Long.toString(probe.getRemainingTokens()));
            return true;
        }

        LOGGER.info(mm + Emoji.NOT_OK + Emoji.NOT_OK +  Emoji.NOT_OK +  "RateLimitInterceptor: RemainingTokens: "
                + probe.getRemainingTokens() + " " + Emoji.ERROR);

        response.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
        try {
            response.getWriter().append("Too many requests");
        } catch (IOException e) {
            e.printStackTrace();
        }
        response.addHeader("X-Rate-Limit-Retry-After-Milliseconds",
                Long.toString(TimeUnit.NANOSECONDS.toMillis(probe.getNanosToWaitForRefill())));

        return false;

    }
}
