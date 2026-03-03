-- 基于 cookbook_open 状态修改
AddStategraphState("wilson",
    State {
        name = "reading_tbat_adventurers_notes",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:ClearOverrideSymbol("book_cook")
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("reading_in", false)
            inst.AnimState:PushAnimation("reading_loop", true)
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst:PerformBufferedAction()
            end),
        },

        onupdate = function(inst)
            if not CanEntitySeeTarget(inst, inst) then
                inst.sg:GoToState("cookbook_close") -- 就用官方的 cookbook_close
            end
        end,

        events =
        {
            EventHandler("ms_closepopup", function(inst, data)
                -- 把HUD模板改成自己的
                if data.popup == POPUPS.ADVENTURERSNOTESSCREEN then
                    inst.sg:GoToState("cookbook_close")
                end
            end),
        },

        onexit = function(inst)
            inst:ShowPopUp(POPUPS.ADVENTURERSNOTESSCREEN, false)
        end,
    }
)

-- 不能没有客户端的部分,否则玩家开启延迟补偿,会不执行动作
AddStategraphState("wilson_client",
    State {
        name = "reading_tbat_adventurers_notes",
        server_states = { "reading_tbat_adventurers_notes" },
        forward_server_states = true,
        onenter = function(inst) inst.sg:GoToState("action_uniqueitem_busy") end,
    }
)
