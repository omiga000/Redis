package com.hmdp.controller;


import com.hmdp.dto.Result;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author 虎哥
 * @since 2021-12-22
 */
@RestController
@RequestMapping("/voucher-order")
public class VoucherOrderController {
    @PostMapping("seckill/{id}")
    public Result seckillVoucher(@PathVariable("id") Long voucherId) {
        // TODO P4：先完成数据库下单，再逐步解决并发问题。
        return Result.fail("待实现：阶段4-优惠券下单");
    }
}
