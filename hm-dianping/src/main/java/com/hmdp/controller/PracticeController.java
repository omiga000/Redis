package com.hmdp.controller;

import com.hmdp.dto.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.LinkedHashMap;
import java.util.Map;

/** 练习环境标识，仅检查应用响应，不代表数据库或 Redis 已连通。 */
@RestController
@RequestMapping("/practice")
public class PracticeController {
    @GetMapping("/status")
    public Result status() {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("project", "dianping-practice");
        data.put("stage", "P0-ready");
        data.put("nextTask", "P1-01 sendCode");
        data.put("infrastructure", "not-checked-by-this-endpoint");
        return Result.ok(data);
    }
}
