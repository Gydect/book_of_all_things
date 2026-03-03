-- 目前是为冒险家笔记所创建的组件,完全 copy 官方的 simplebook 组件
local TbatNote = Class(function(self, inst)
	self.inst = inst

	self.inst:AddTag("tbat_note")

	--self.onreadfn = nil
end)

function TbatNote:OnRemoveFromEntity()
    self.inst:RemoveTag("tbat_note")
end

function TbatNote:Read(doer)
	if not CanEntitySeeTarget(doer, self.inst) then
		return false
	end

	if self.onreadfn then
		self.onreadfn(self.inst, doer)
	end
end

return TbatNote