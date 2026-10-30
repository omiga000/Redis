package com.hmdp.utils;

import org.springframework.stereotype.Component;

/** 阶段 4 练习：基于时间戳和 Redis 自增序列生成订单 ID。 */
@Component
public class RedisIdWorker {
    public long nextId(String keyPrefix) {
        // TODO P4：到优惠券下单阶段再实现；当前阶段不需要调用。
        throw new UnsupportedOperationException("待实现：阶段4-订单ID生成器");
    }
}
