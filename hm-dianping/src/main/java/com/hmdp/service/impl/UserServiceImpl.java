package com.hmdp.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hmdp.dto.LoginFormDTO;
import com.hmdp.dto.Result;
import com.hmdp.dto.UserDTO;
import com.hmdp.entity.User;
import com.hmdp.mapper.UserMapper;
import com.hmdp.service.IUserService;
import com.hmdp.utils.RedisConstants;
import com.hmdp.utils.RegexUtils;
import com.hmdp.utils.SystemConstants;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/** 阶段 1 的主要练习位置。任务要求见 docs/01-验证码与登录.md。 */
@Slf4j
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {
    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public Result sendCode(String phone, HttpSession session) {
        //验证是否合法;
        if(RegexUtils.isPhoneInvalid(phone))
        {
            return Result.fail("手机号码格式不对");
        }
        //生成随机数
        String code =RandomUtil.randomNumbers(6);
        //拼接
        String key=RedisConstants.LOGIN_CODE_KEY+phone;


        stringRedisTemplate.opsForValue().set(
                key,code,RedisConstants.LOGIN_CODE_TTL,TimeUnit.MINUTES
        );

        log.debug("模拟发送验证码，手机号：{}，验证码：{}", phone, code);
        return Result.ok();
    }

    @Override
    public Result login(LoginFormDTO loginForm, HttpSession session) {
        // 1. 校验手机号和验证码是否填写
        if (loginForm == null
                || RegexUtils.isPhoneInvalid(loginForm.getPhone())) {
            return Result.fail("手机号格式错误");
        }

        if (StrUtil.isBlank(loginForm.getCode())) {
            return Result.fail("请输入验证码");
        }

        // 2. 从 Redis 读取服务器保存的验证码
        String phone = loginForm.getPhone();
        String codeKey = RedisConstants.LOGIN_CODE_KEY + phone;

        String cachedCode = stringRedisTemplate
                .opsForValue()
                .get(codeKey);

        // 不存在或不一致，都不能继续登录
        if (cachedCode == null
                || !cachedCode.equals(loginForm.getCode())) {
            return Result.fail("验证码错误或已过期");
        }

        // 3. 根据手机号查询数据库中的用户
        User user = getOne(
                new QueryWrapper<User>().eq("phone", phone)
        );

        // 首次登录：自动创建用户
        if (user == null) {
            user = new User();
            user.setPhone(phone);
            user.setNickName(
                    SystemConstants.USER_NICK_NAME_PREFIX
                            + RandomUtil.randomString(10)
            );

            if (!save(user)) {
                return Result.fail("创建用户失败");
            }
        }

        // 4. 生成随机 token，作为本次登录的凭证
        String token = UUID.randomUUID()
                .toString()
                .replace("-", "");

        // 5. 只提取需要保存在登录状态中的用户字段
        UserDTO userDTO = BeanUtil.copyProperties(user, UserDTO.class);

        Map<String, String> userMap = new HashMap<>();
        userMap.put("id", userDTO.getId().toString());

        if (userDTO.getNickName() != null) {
            userMap.put("nickName", userDTO.getNickName());
        }

        if (userDTO.getIcon() != null) {
            userMap.put("icon", userDTO.getIcon());
        }

        // 6. 将 token 与用户信息的对应关系保存到 Redis
        String tokenKey = RedisConstants.LOGIN_USER_KEY + token;
        stringRedisTemplate.opsForHash().putAll(tokenKey, userMap);

        Boolean expirationSet = stringRedisTemplate.expire(
                tokenKey,
                RedisConstants.LOGIN_USER_TTL,
                TimeUnit.MINUTES
        );

        if (!Boolean.TRUE.equals(expirationSet)) {
            stringRedisTemplate.delete(tokenKey);
            return Result.fail("保存登录状态失败，请重试");
        }

        // 7. 登录状态保存成功后，删除已经使用的验证码
        stringRedisTemplate.delete(codeKey);

        // 8. 把 token 返回前端
        return Result.ok(token);
    }
}
