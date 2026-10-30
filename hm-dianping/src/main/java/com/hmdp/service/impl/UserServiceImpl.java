package com.hmdp.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hmdp.dto.LoginFormDTO;
import com.hmdp.dto.Result;
import com.hmdp.entity.User;
import com.hmdp.mapper.UserMapper;
import com.hmdp.service.IUserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/** 阶段 1 的主要练习位置。任务要求见 docs/01-验证码与登录.md。 */
@Slf4j
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {
    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public Result sendCode(String phone, HttpSession session) {
        // TODO P1-01：校验手机号、生成验证码、写入 Redis 并设置有效期、打印模拟发送日志。
        return Result.fail("待实现：阶段1-发送验证码");
    }

    @Override
    public Result login(LoginFormDTO loginForm, HttpSession session) {
        // TODO P1-02：校验验证码、查询或创建用户、生成 token、保存登录状态。
        return Result.fail("待实现：阶段1-验证码登录");
    }
}
