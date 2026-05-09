package com.campus.ordering.common;

public class CacheConstants {

    public static final String CACHE_NAME = "campus:ordering:";

    public static final String SHOP_CATEGORY_LIST = CACHE_NAME + "shop:category:list";

    public static final String SHOP_LIST = CACHE_NAME + "shop:list:";

    public static final String SHOP_DETAIL = CACHE_NAME + "shop:detail:";

    public static final String PRODUCT_CATEGORY_LIST = CACHE_NAME + "product:category:";

    public static final String PRODUCT_LIST = CACHE_NAME + "product:list:";

    public static final String PRODUCT_DETAIL = CACHE_NAME + "product:detail:";

    public static final String SEARCH_PRODUCT = CACHE_NAME + "product:search:";

    public static final long DEFAULT_CACHE_TIME = 30;

    public static final long CACHE_TIME_30_MIN = 30;

    public static final long CACHE_TIME_1_HOUR = 60;

    public static final long CACHE_TIME_1_DAY = 60 * 24;

    private CacheConstants() {
    }
}
