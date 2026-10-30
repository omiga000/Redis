package com.hmdp.utils;

public class RedisConstants {
    public static final String LOGIN_CODE_KEY = "dp:practice:login:code:";
    public static final Long LOGIN_CODE_TTL = 2L;
    public static final String LOGIN_USER_KEY = "dp:practice:login:token:";
    // 登录有效期单位统一为分钟，调用 expire 时使用 TimeUnit.MINUTES。
    public static final Long LOGIN_USER_TTL = 30L;

    public static final Long CACHE_NULL_TTL = 2L;

    public static final Long CACHE_SHOP_TTL = 30L;
    public static final String CACHE_SHOP_KEY = "dp:practice:cache:shop:";

    public static final String LOCK_SHOP_KEY = "dp:practice:lock:shop:";
    public static final Long LOCK_SHOP_TTL = 10L;

    public static final String SECKILL_STOCK_KEY = "dp:practice:seckill:stock:";
    public static final String BLOG_LIKED_KEY = "dp:practice:blog:liked:";
    public static final String FEED_KEY = "dp:practice:feed:";
    public static final String SHOP_GEO_KEY = "dp:practice:shop:geo:";
    public static final String USER_SIGN_KEY = "dp:practice:sign:";
}
