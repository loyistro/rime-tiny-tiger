--%a 星期简称，如Wed	%A 星期全称，如Wednesday
--%b 月份简称，如Sep	%B 月份全称，如September
--%c 日期时间格式 (e.g., 09/16/98 23:48:10)
--%d 一个月的第几天 [01-31]	%j 一年的第几天
--%H 24小时制 [00-23]	%I 12小时制 [01-12]
--%M 分钟 [00-59]	%m 月份 (09) [01-12]
--%p 上午/下午 (pm or am)
--%S 秒 (10) [00-61]
--%w 星期的第几天 [0-6 = Sunday-Saturday]	%W 一年的第几周
--%x 日期格式 (e.g., 09/16/98)	%X 时间格式 (e.g., 23:48:10)
--%Y 年份全称 (1998)	%y 年份简称 [00-99]
--%% 百分号
--os.date() 把时间戳转化成可显示的时间字符串
--os.time ([table])

-- 控制候选词的优先级，数值越大优先级越高。这里设置为 2，表明它的优先级高于默认值（通常默认是 0 或 1）
local function yield_cand(seg, text)
    local cand = Candidate('', seg.start, seg._end, text, '')
    cand.quality = 2
    yield(cand)
end

local M = {}

function M.init(env)
    local config = env.engine.schema.config
    env.name_space = env.name_space:gsub('^*', '')
    M.date = config:get_string(env.name_space .. '/date') or 'dda'
end

function M.func(input, seg, env)
    -- 日期匹配
    if (input == M.date) then
        local current_time = os.time()
        -- 生成候选日期
        yield_cand(seg, os.date('%y%m%d%H%M', current_time))  -- 短格式日期+时间
        yield_cand(seg, os.date('%Y%m%d', current_time))      -- 长格式日期
    end
end

return M
