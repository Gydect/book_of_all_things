-- atbook_brcverify local analyzer and generator
--
-- This script mirrors the logic from:
--   atbook_brcverify.lua
--   atbook_brcverifyutil.lua
--   atbook_brcverifyconst.lua
--
-- Real CDK format used by that verifier:
--   <key_id><base64(xor(payload, key))>
--
-- Payload format accepted by the verifier:
--   #token1,token2,token3,...#
--
-- Required conditions:
--   1. payload must start with '#'
--   2. payload must end with '#'
--   3. payload must contain '@atbook'
--   4. one token must equal the player's userid
--
-- Recognized tokens:
--   VIP       -> expand almost all skins except ids listed in limit
--   &HEX      -> expand skins from a hex bitfield
--   <number>  -> const.skin[number]
--   KU_xxx    -> userid check
--   @atbook   -> required marker
--
-- Notes:
--   1. Unknown tokens are ignored by the real verifier.
--   2. const.simplefn exists in the const file but is not used by the real verifier.
--
-- Usage examples:
--   lua test.lua
--   lua test.lua decode
--   lua test.lua decode "<cdk>" "<userid>"
--   lua test.lua generate
--   lua test.lua both

local SAMPLE_CDK = "7Z2VhKisZbnZifA9HchpmRExbHFMeHjZTaw8fZnFgX0F0cWdiaGdyYGB0B0dvSyNeL1lWfi0naAIMDwwAOTVDMSU1NT03PG5idHxeA2A="
local SAMPLE_USERID = "KU_84TfuVxe"

local CONFIG = {
    mode = "generate", -- decode / generate / both
    decode = {
        cdk = SAMPLE_CDK,
        userid = SAMPLE_USERID,
    },
    generate = {
        userid = SAMPLE_USERID,
        key_id = "7",
        use_vip = true,
        direct_ids = { "5", "61" },
        hex_values = { "8", "9", "10", "11" },
        noise_prefix = { "$demo" },
        noise_suffix = { "tail$" },
    },
}

local CONST = {}

CONST.keys = {
    ["1"] = "F3dHus5U01yPHK3g5PzKr1cXcnd97e5o",
    ["2"] = "hYBiIjohyDl1B5fu7VrS77Ul6Kzq1gaG",
    ["3"] = "1jf9DBGSu5xsCdzmZPNT9DhTuEs8fKHn",
    ["4"] = "ENKCDfxnCVSlMftvSU4YLIhHjrqluAsm",
    ["5"] = "ptkJsz2JOYn6180Ro9BVsR4B0hcffiSq",
    ["6"] = "keSiKkZF45iOfGHiQ3Y8kxHmV15laVUj",
    ["7"] = "DAWRXWBPPD7wCyVtxhz5xxP6XiyVAPoq",
    ["8"] = "fWm9HblPYl2u6Yi7TBD7HfnqAeH7eQxD",
    ["9"] = "N3pArHbzKevd22yCzmzuQLx3f9DWx2gx",
}

CONST.limit = {
    "1",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "61",
}

CONST.skin = {
    ["1"] = "tbat_eq_fantasy_tool_freya_s_wand",
    ["2"] = "tbat_eq_fantasy_tool_cheese_fork",
    ["3"] = "tbat_eq_universal_baton_2",
    ["4"] = "tbat_eq_universal_baton_3",
    ["5"] = "tbat_eq_universal_baton_pack",
    ["6"] = "tbat_baton_rabbit_ice_cream",
    ["7"] = "tbat_baton_bunny_scepter",
    ["8"] = "tbat_baton_jade_sword_immortal",
    ["9"] = "tbat_building_kitty_wooden_sign_9",
    ["10"] = "tbat_building_kitty_wooden_sign_10",
    ["11"] = "tbat_building_kitty_wooden_sign_11",
    ["12"] = "tbat_building_kitty_wooden_sign_12",
    ["13"] = "tbat_building_kitty_wooden_sign_13",
    ["14"] = "tbat_building_cloud_wooden_sign_7",
    ["15"] = "tbat_building_bunny_wooden_sign_6",
    ["16"] = "tbat_building_bunny_wooden_sign_7",
    ["17"] = "tbat_wreath_strawberry_bunny",
    ["18"] = "tbat_rayfish_hat_sweet_cocoa",
    ["19"] = "cb_rabbit_mini_icecream",
    ["20"] = "cbr_mini_labubu_colourful_feather",
    ["21"] = "cbr_mini_labubu_skyblue",
    ["22"] = "cbr_mini_labubu_pink_strawberry",
    ["23"] = "cbr_mini_labubu_flower_bud",
    ["24"] = "cbr_mini_labubu_orange",
    ["25"] = "cbr_mini_labubu_white_cherry",
    ["26"] = "cbr_mini_labubu_lemon_yellow",
    ["27"] = "cbr_mini_labubu_dream_blue",
    ["28"] = "cbr_mini_labubu_moon_white",
    ["29"] = "cbr_mini_labubu_purple_wind",
    ["30"] = "tbat_pc_strawberry_jam",
    ["31"] = "tbat_pc_pudding",
    ["32"] = "tbat_carpet_cream_puff_bread",
    ["33"] = "tbat_carpet_taro_bread",
    ["34"] = "tbat_carpet_taro_bread_with_bell",
    ["35"] = "tbat_carpet_hello_kitty",
    ["36"] = "carpet_claw_dreamweave_rug",
    ["37"] = "carpet_claw_petglyph_platform",
    ["38"] = "tbat_pb_bush_dreambloom",
    ["39"] = "tbat_pb_bush_mistbloom",
    ["40"] = "tbat_pb_bush_mosswhisper",
    ["41"] = "tbat_pb_bush_warm_rose",
    ["42"] = "tbat_pb_bush_spark_rose",
    ["43"] = "tbat_pb_bush_luminmist_rose",
    ["44"] = "tbat_pb_bush_frostberry_rose",
    ["45"] = "tbat_pb_bush_stellar_rose",
    ["46"] = "tbat_pot_verdant_grove",
    ["47"] = "tbat_pot_bunny_cart",
    ["48"] = "tbat_pot_dreambloom_vase",
    ["49"] = "tbat_pot_lavendream",
    ["50"] = "tbat_pot_cloudlamb_vase",
    ["51"] = "tbat_lamp_starwish",
    ["52"] = "tbat_lamp_moon_starwish",
    ["53"] = "tbat_lamp_moon_sleeping_kitty",
    ["54"] = "tbat_wood_sofa_magic_broom",
    ["55"] = "tbat_wood_sofa_sunbloom",
    ["56"] = "tbat_wood_sofa_lemon_cookie",
    ["57"] = "tbat_sunbloom_side_table",
    ["58"] = "tbat_whisper_tome_spellwisp_desk",
    ["59"] = "tbat_whisper_tome_chirpwell",
    ["60"] = "tbat_whisper_tome_purr_oven",
    ["61"] = "tbat_whisper_tome_swirl_vanity",
    ["62"] = "tbat_mpc_tree_ring_counter",
    ["63"] = "tbat_mpc_ferris_wheel",
    ["64"] = "tbat_mpc_gift_display_rack",
    ["65"] = "tbat_mpc_accordion",
    ["66"] = "tbat_mpc_dreampkin_hut",
    ["67"] = "tbat_mpc_grid_cabinet",
    ["68"] = "tbat_mpc_puffcap_stand",
    ["69"] = "tbat_pbt_sweetwhim_stand",
    ["70"] = "tbat_pbh_abysshell_stand",
    ["71"] = "tbat_wall_strawberry_cream_cake",
    ["72"] = "tbat_wall_coral_reef",
    ["73"] = "tbat_hamster_gumball_machine",
    ["74"] = "1",
    ["75"] = "2",
    ["76"] = "3",
    ["77"] = "tbat_brb_fly",
    ["78"] = "tbat_pc_pjty",
    ["79"] = "tbat_spph_mtlg",
    ["80"] = "tbat_fmc_lyth",
    ["81"] = "cb_rabbit_mini_dj",
    ["82"] = "tbat_pc_db",
    ["83"] = "tbat_baton_yltp",
    ["84"] = "tbat_baton_cjxy",
    ["85"] = "tbat_btg_flnf",
    ["86"] = "tbat_bgcwc_jyfd",
    ["87"] = "tbat_lamp_moon_xssxd",
    ["88"] = "tbat_pot_jsnf",
    ["89"] = "tbat_eq_fantasy_tool_tyych",
    ["90"] = "tbat_wood_sofa_fddd",
}

local function table_contains(list, value)
    for _, item in pairs(list or {}) do
        if item == value then
            return true
        end
    end
    return false
end

local function sorted_skin_ids()
    local ids = {}
    for id in pairs(CONST.skin) do
        ids[#ids + 1] = tonumber(id)
    end
    table.sort(ids)
    return ids
end

local SORTED_IDS = sorted_skin_ids()
local SKIN_TO_ID = {}
for id, code in pairs(CONST.skin) do
    if SKIN_TO_ID[code] == nil then
        SKIN_TO_ID[code] = id
    end
end

local function bytes_to_hex(str)
    local out = {}
    for i = 1, #str do
        out[#out + 1] = string.format("%02X", str:byte(i))
    end
    return table.concat(out, " ")
end

local function bytes_to_escaped(str)
    local out = {}
    for i = 1, #str do
        local b = str:byte(i)
        if b == 9 then
            out[#out + 1] = "\\t"
        elseif b == 10 then
            out[#out + 1] = "\\n"
        elseif b == 13 then
            out[#out + 1] = "\\r"
        elseif b == 92 then
            out[#out + 1] = "\\\\"
        elseif b >= 32 and b <= 126 then
            out[#out + 1] = string.char(b)
        else
            out[#out + 1] = string.format("\\x%02X", b)
        end
    end
    return table.concat(out)
end

local function print_string_report(label, str)
    print(label .. " length:", #str)
    print(label .. " escaped:")
    print(bytes_to_escaped(str))
    print(label .. " hex:")
    print(bytes_to_hex(str))
end

local base64_chars = {
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P",
    "Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f",
    "g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v",
    "w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/",
}

local reverse_chars = {}
for i, v in ipairs(base64_chars) do
    reverse_chars[v] = i - 1
end
reverse_chars["="] = 0

local function bit_xor(a, b)
    local result = 0
    local bitval = 1
    while a > 0 or b > 0 do
        local a_bit = a % 2
        local b_bit = b % 2
        if a_bit ~= b_bit then
            result = result + bitval
        end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bitval = bitval * 2
    end
    return result
end

local function base64_decode(data)
    data = data:gsub("[^%w+/=]", "")
    local result = {}
    local i = 1

    while i <= #data do
        if data:sub(i, i) == "=" then
            break
        end

        local a = reverse_chars[data:sub(i, i)] or 0
        local b = reverse_chars[data:sub(i + 1, i + 1)] or 0
        local c = reverse_chars[data:sub(i + 2, i + 2)] or 0
        local d = reverse_chars[data:sub(i + 3, i + 3)] or 0

        local n = a * 0x40000 + b * 0x1000 + c * 0x40 + d
        local c1 = math.floor(n / 0x10000) % 0x100
        local c2 = math.floor(n / 0x100) % 0x100
        local c3 = n % 0x100

        result[#result + 1] = string.char(c1)
        if data:sub(i + 2, i + 2) ~= "=" then
            result[#result + 1] = string.char(c2)
        end
        if data:sub(i + 3, i + 3) ~= "=" then
            result[#result + 1] = string.char(c3)
        end

        i = i + 4
    end

    return table.concat(result)
end

local function base64_encode(data)
    local result = {}
    local len = #data
    local pad = 0

    for i = 1, len, 3 do
        local b1 = data:byte(i) or 0
        local b2 = data:byte(i + 1) or 0
        local b3 = data:byte(i + 2) or 0
        local n = b1 * 0x10000 + b2 * 0x100 + b3

        local c1 = math.floor(n / 0x40000) % 0x40
        local c2 = math.floor(n / 0x1000) % 0x40
        local c3 = math.floor(n / 0x40) % 0x40
        local c4 = n % 0x40

        if i + 1 > len then
            pad = 2
        elseif i + 2 > len then
            pad = 1
        else
            pad = 0
        end

        result[#result + 1] = base64_chars[c1 + 1]
        result[#result + 1] = base64_chars[c2 + 1]
        result[#result + 1] = pad >= 2 and "=" or base64_chars[c3 + 1]
        result[#result + 1] = pad >= 1 and "=" or base64_chars[c4 + 1]
    end

    return table.concat(result)
end

local function crypt_core(input, key)
    if #key == 0 then
        return input
    end

    local key_bytes = { key:byte(1, #key) }
    local result = {}

    for i = 1, #input do
        local k = key_bytes[(i - 1) % #key_bytes + 1]
        local c = input:byte(i)
        result[i] = string.char(bit_xor(c, k))
    end

    return table.concat(result)
end

local function encrypt_body(plaintext, key)
    return base64_encode(crypt_core(plaintext, key))
end

local function decrypt_body(ciphertext, key)
    return crypt_core(base64_decode(ciphertext), key)
end

local function add_unique(list, value)
    if not table_contains(list, value) then
        list[#list + 1] = value
    end
end

local function split_csv(input)
    local result = {}
    input = input .. ","
    for match in input:gmatch("(.-),") do
        if match ~= "" then
            result[#result + 1] = match
        end
    end
    return result
end

local function vip_expand(info)
    for _, id_num in ipairs(SORTED_IDS) do
        local id = tostring(id_num)
        local skincode = CONST.skin[id]
        if not table_contains(CONST.limit, id) and not table_contains(info, skincode) then
            info[#info + 1] = skincode
        end
    end
end

local function simple_expand(info, num)
    for _, id_num in ipairs(SORTED_IDS) do
        local uid = tostring(id_num)
        local skincode = CONST.skin[uid]
        local prefix = uid:sub(1, #uid - 1)
        if prefix == num and not table_contains(info, skincode) then
            info[#info + 1] = skincode
        end
    end
end

local function hex_to_index_array(hex_string)
    local hex_to_bin_map = {
        ["0"] = "0000", ["1"] = "0001", ["2"] = "0010", ["3"] = "0011",
        ["4"] = "0100", ["5"] = "0101", ["6"] = "0110", ["7"] = "0111",
        ["8"] = "1000", ["9"] = "1001", ["a"] = "1010", ["b"] = "1011",
        ["c"] = "1100", ["d"] = "1101", ["e"] = "1110", ["f"] = "1111",
        ["A"] = "1010", ["B"] = "1011", ["C"] = "1100", ["D"] = "1101",
        ["E"] = "1110", ["F"] = "1111",
    }

    local binary_string = ""
    for i = 1, #hex_string do
        local char = hex_string:sub(i, i)
        local binary = hex_to_bin_map[char]
        if not binary then
            return {}
        end
        binary_string = binary_string .. binary
    end

    local start_pos = binary_string:find("1", 1, true)
    if not start_pos then
        return {}
    end

    binary_string = binary_string:sub(start_pos + 1)
    local result = {}
    for i = 1, #binary_string do
        result[#result + 1] = binary_string:sub(i, i)
    end
    return result
end

local function hex_expand(info, hex_value)
    local result = hex_to_index_array(hex_value)
    for index, flag in ipairs(result) do
        if flag == "1" and CONST.skin[tostring(index)] then
            info[#info + 1] = CONST.skin[tostring(index)]
        end
    end
end

local function resolve_index(value)
    if type(value) == "number" then
        return value
    end
    if type(value) ~= "string" then
        return nil
    end

    local direct_id = tonumber(value)
    if direct_id then
        return direct_id
    end

    local mapped_id = SKIN_TO_ID[value]
    if mapped_id then
        return tonumber(mapped_id)
    end

    return nil
end

local function encode_hex_indices(values)
    local indices = {}
    local max_index = 0

    for _, value in ipairs(values or {}) do
        local index = resolve_index(value)
        if index and index > 0 then
            indices[#indices + 1] = index
            if index > max_index then
                max_index = index
            end
        end
    end

    if max_index == 0 then
        return nil
    end

    local bits = {}
    for i = 1, max_index do
        bits[i] = "0"
    end
    for _, index in ipairs(indices) do
        bits[index] = "1"
    end

    local binary = "1" .. table.concat(bits)
    while (#binary % 4) ~= 0 do
        binary = "0" .. binary
    end

    local out = {}
    for i = 1, #binary, 4 do
        local nibble = binary:sub(i, i + 3)
        out[#out + 1] = string.format("%X", tonumber(nibble, 2))
    end
    return table.concat(out)
end

local function sort_strings(list)
    table.sort(list, function(a, b)
        return tostring(a) < tostring(b)
    end)
end

local function analyze_payload(plaintext, expected_userid)
    local report = {
        plaintext = plaintext,
        valid_wrapper = false,
        has_marker = false,
        tokens = {},
        unknown_tokens = {},
        found_userids = {},
        direct_tokens = {},
        hex_tokens = {},
        raw_skins = {},
        unique_skins = {},
        matched_userid = false,
        warnings = {},
    }

    report.valid_wrapper = plaintext:sub(1, 1) == "#" and plaintext:sub(-1) == "#"
    report.has_marker = plaintext:find("@atbook", 1, true) ~= nil

    local stripped = plaintext:gsub("#", "")
    report.tokens = split_csv(stripped)

    for _, token in ipairs(report.tokens) do
        if token == "@atbook" then
            -- marker only
        elseif token == "VIP" then
            vip_expand(report.raw_skins)
        elseif token:sub(1, 1) == "&" then
            report.hex_tokens[#report.hex_tokens + 1] = token
            hex_expand(report.raw_skins, token:sub(2))
        elseif token:match("^KU_") then
            report.found_userids[#report.found_userids + 1] = token
            if expected_userid and token == expected_userid then
                report.matched_userid = true
            end
        elseif CONST.skin[token] then
            report.direct_tokens[#report.direct_tokens + 1] = token
            report.raw_skins[#report.raw_skins + 1] = CONST.skin[token]
            if tostring(CONST.skin[token]):match("^%d+$") then
                report.warnings[#report.warnings + 1] =
                    ("direct token %s maps to numeric alias %s; simplefn exists in const but is not called by the real verifier")
                    :format(token, CONST.skin[token])
            end
        else
            report.unknown_tokens[#report.unknown_tokens + 1] = token
        end
    end

    for _, skin_code in ipairs(report.raw_skins) do
        add_unique(report.unique_skins, skin_code)
    end

    sort_strings(report.found_userids)
    sort_strings(report.unknown_tokens)
    sort_strings(report.unique_skins)
    return report
end

local function decrypt_cdk(cdk)
    if type(cdk) ~= "string" or #cdk < 2 then
        return nil, "cdk is too short"
    end

    local key_id = cdk:sub(1, 1)
    local key = CONST.keys[key_id]
    if not key then
        return nil, "unknown key id: " .. tostring(key_id)
    end

    local body = cdk:sub(2)
    local plaintext = decrypt_body(body, key)
    return {
        key_id = key_id,
        key = key,
        body = body,
        plaintext = plaintext,
    }
end

local function build_payload(userid, options)
    options = options or {}
    local tokens = {}

    for _, token in ipairs(options.noise_prefix or {}) do
        tokens[#tokens + 1] = tostring(token)
    end

    if options.use_vip then
        tokens[#tokens + 1] = "VIP"
    end

    local hex_token = encode_hex_indices(options.hex_values or {})
    if hex_token then
        tokens[#tokens + 1] = "&" .. hex_token
    end

    for _, direct_id in ipairs(options.direct_ids or {}) do
        tokens[#tokens + 1] = tostring(direct_id)
    end

    tokens[#tokens + 1] = userid
    tokens[#tokens + 1] = "@atbook"

    for _, token in ipairs(options.noise_suffix or {}) do
        tokens[#tokens + 1] = tostring(token)
    end

    return "#" .. table.concat(tokens, ",") .. "#"
end

local function generate_cdk(userid, key_id, options)
    local key = CONST.keys[key_id]
    if not key then
        error("unknown key id: " .. tostring(key_id))
    end
    local payload = build_payload(userid, options)
    local encrypted = encrypt_body(payload, key)
    return key_id .. encrypted, payload
end

local function print_list(title, list)
    print(title .. " count:", #list)
    for i, value in ipairs(list) do
        print(("  [%d] %s"):format(i, tostring(value)))
    end
end

local function print_report(report, expected_userid)
    print("valid wrapper:", report.valid_wrapper)
    print("has @atbook marker:", report.has_marker)
    if expected_userid then
        print("userid matched:", report.matched_userid)
        print("expected userid:", expected_userid)
    end
    print_list("tokens", report.tokens)
    print_list("found userids", report.found_userids)
    print_list("direct tokens", report.direct_tokens)
    print_list("hex tokens", report.hex_tokens)
    print_list("unknown tokens", report.unknown_tokens)
    print_list("unique skins", report.unique_skins)
    if #report.warnings > 0 then
        print_list("warnings", report.warnings)
    end
end

local function explain_decode(cdk, userid)
    print("== Decode CDK ==")
    print("input cdk:", cdk)
    print("cdk length:", #cdk)

    local result, err = decrypt_cdk(cdk)
    if not result then
        print("decrypt failed:", err)
        return
    end

    print("key id:", result.key_id)
    print("selected key:", result.key)
    print_string_report("encrypted body", result.body)
    print_string_report("plaintext payload", result.plaintext)

    local report = analyze_payload(result.plaintext, userid)
    print_report(report, userid)
end

local function explain_generate(userid, key_id, options)
    print("== Generate CDK ==")
    print("userid:", userid)
    print("key id:", key_id)
    print("note: unknown noise tokens are allowed because the real verifier ignores them")
    print("note: const.simplefn exists but is not used by atbook_brcverify.lua")

    local cdk, payload = generate_cdk(userid, key_id, options)
    print_string_report("generated payload", payload)
    print("generated cdk:", cdk)

    print("")
    print("== Self-check generated CDK ==")
    explain_decode(cdk, userid)
end

local mode = (arg and arg[1]) or CONFIG.mode
if mode == "decode" and arg and arg[2] then
    CONFIG.decode.cdk = arg[2]
end
if mode == "decode" and arg and arg[3] then
    CONFIG.decode.userid = arg[3]
end

if mode == "decode" then
    explain_decode(CONFIG.decode.cdk, CONFIG.decode.userid)
elseif mode == "generate" then
    explain_generate(CONFIG.generate.userid, CONFIG.generate.key_id, CONFIG.generate)
elseif mode == "both" then
    explain_decode(CONFIG.decode.cdk, CONFIG.decode.userid)
    print("")
    explain_generate(CONFIG.generate.userid, CONFIG.generate.key_id, CONFIG.generate)
else
    print("unknown mode:", tostring(mode))
    print("use: decode / generate / both")
end

